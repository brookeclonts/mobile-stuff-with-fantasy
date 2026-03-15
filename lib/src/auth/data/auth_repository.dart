import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:swf_app/src/api/api_client.dart';
import 'package:swf_app/src/api/api_result.dart';
import 'package:swf_app/src/auth/data/session_store.dart';
import 'package:swf_app/src/auth/models/user.dart';

/// Handles sign-up and sign-in via the better-auth API.
///
/// Uses a raw [http.Client] rather than [ApiClient] because auth endpoints
/// have a non-standard response envelope (better-auth's own format) and we
/// need to extract the session token from the response body.
///
/// After a successful auth call the session token is stored in [SessionStore]
/// and injected into [ApiClient] for all subsequent requests.
class AuthRepository {
  AuthRepository({
    required String baseUrl,
    required ApiClient apiClient,
    required SessionStore sessionStore,
    http.Client? httpClient,
  }) : _baseUrl = baseUrl,
       _apiClient = apiClient,
       _sessionStore = sessionStore,
       _http = httpClient ?? http.Client() {
    final token = sessionStore.token;
    if (token != null && token.isNotEmpty) {
      _apiClient.setSessionToken(token);
    }
  }

  final String _baseUrl;
  final ApiClient _apiClient;
  final SessionStore _sessionStore;
  final http.Client _http;

  static const _jsonHeaders = {
    HttpHeaders.contentTypeHeader: 'application/json',
    HttpHeaders.acceptHeader: 'application/json',
  };

  SessionStore get sessionStore => _sessionStore;

  Future<ApiResult<User>> getCurrentUser() async {
    final result = await _apiClient.get<User>(
      '/api/auth/me',
      fromJson: (json) {
        final data = json as Map<String, Object?>;
        return User.fromJson(data['user'] ?? json);
      },
    );

    if (result is Success<User>) {
      final token = _sessionStore.token;
      if (token != null && token.isNotEmpty) {
        _sessionStore.save(token: token, user: result.value);
      }
      return result;
    }

    if (result is Failure<User> && result.statusCode == 401) {
      _clearSession();
    }

    return result;
  }

  /// Create a new account via better-auth and set the chosen role.
  ///
  /// 1. POST /api/auth/sign-up/email  → creates auth user + session
  /// 2. POST /api/user/role            → sets the user's role
  Future<ApiResult<User>> signUp({
    required String name,
    required String email,
    required String password,
    required UserRole role,
  }) async {
    try {
      final previousToken = _sessionStore.token;
      final previousUser = _sessionStore.user;

      // ── Step 1: better-auth sign-up ──
      final response = await _http.post(
        Uri.parse('$_baseUrl/api/auth/sign-up/email'),
        headers: _jsonHeaders,
        body: jsonEncode({
          'email': email.toLowerCase().trim(),
          'password': password,
          'name': name.trim(),
        }),
      );

      final body = jsonDecode(response.body) as Map<String, Object?>;

      if (response.statusCode < 200 || response.statusCode >= 300) {
        final error = _parseError(body) ?? 'Sign up failed';
        return Failure(error, statusCode: response.statusCode);
      }

      // better-auth returns { user: {...}, session: { token, ... } }
      final sessionData = body['session'] as Map<String, Object?>?;
      final token = sessionData?['token'] as String?;

      final userData = body['user'] as Map<String, Object?>?;
      final user = User(
        id: (userData?['id'] ?? '').toString(),
        email: userData?['email'] as String? ?? email,
        name: userData?['name'] as String? ?? name,
        role: role.apiValue,
      );

      if (token == null || token.isEmpty) {
        return const Failure('Sign up succeeded, but no session was returned');
      }

      _sessionStore.save(token: token, user: user);
      _apiClient.setSessionToken(token);

      // ── Step 2: set chosen role ──
      final roleResult = await _setRole(role, token);
      if (roleResult is Failure<void>) {
        if (previousToken != null && previousUser != null) {
          _restoreSession(previousToken, previousUser);
        } else {
          _clearSession();
        }
        return Failure(roleResult.message, statusCode: roleResult.statusCode);
      }

      return Success(user);
    } on SocketException {
      return const Failure('No internet connection');
    } on HttpException {
      return const Failure('Server unreachable');
    } on FormatException {
      return const Failure('Invalid response from server');
    } catch (e) {
      debugPrint('AuthRepository.signUp error: $e');
      return Failure('Unexpected error: $e');
    }
  }

  /// Call POST /api/user/role to persist the selected role.
  Future<ApiResult<void>> _setRole(UserRole role, String token) async {
    try {
      final response = await _http.post(
        Uri.parse('$_baseUrl/api/user/role'),
        headers: {
          ..._jsonHeaders,
          HttpHeaders.cookieHeader: 'better-auth.session_token=$token',
        },
        body: jsonEncode({'role': role.apiValue}),
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return const Success<void>(null);
      }

      final body = jsonDecode(response.body) as Map<String, Object?>;
      return Failure(
        _parseError(body) ?? 'Failed to set account role',
        statusCode: response.statusCode,
      );
    } catch (e) {
      debugPrint('AuthRepository._setRole error: $e');
      if (e is SocketException) {
        return const Failure('No internet connection');
      }
      if (e is HttpException) {
        return const Failure('Server unreachable');
      }
      if (e is FormatException) {
        return const Failure('Invalid response from server');
      }
      return Failure('Unexpected error: $e');
    }
  }

  Future<ApiResult<void>> signOut() async {
    final token = _sessionStore.token;
    if (token == null || token.isEmpty) {
      _clearSession();
      return const Success<void>(null);
    }

    try {
      final response = await _http.post(
        Uri.parse('$_baseUrl/api/auth/sign-out'),
        headers: {
          ..._jsonHeaders,
          HttpHeaders.cookieHeader: 'better-auth.session_token=$token',
        },
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        _clearSession();
        return const Success<void>(null);
      }

      if (response.statusCode == 401) {
        _clearSession();
        return const Success<void>(null);
      }

      return Failure(
        _parseErrorResponse(response) ?? 'Failed to sign out',
        statusCode: response.statusCode,
      );
    } catch (e) {
      debugPrint('AuthRepository.signOut error: $e');
      if (e is SocketException) {
        return const Failure('No internet connection');
      }
      if (e is HttpException) {
        return const Failure('Server unreachable');
      }
      if (e is FormatException) {
        return const Failure('Invalid response from server');
      }
      return Failure('Unexpected error: $e');
    }
  }

  /// Pull a human-readable error from various response shapes.
  String? _parseError(Map<String, Object?> body) {
    // better-auth: { message: "..." }
    if (body['message'] is String) return body['message'] as String;
    // Standard envelope: { error: "..." }
    if (body['error'] is String) return body['error'] as String;
    return null;
  }

  String? _parseErrorResponse(http.Response response) {
    if (response.body.isEmpty) return null;

    try {
      final body = jsonDecode(response.body);
      if (body is Map<String, Object?>) {
        return _parseError(body);
      }
    } on FormatException {
      return null;
    }

    return null;
  }

  void _restoreSession(String token, User user) {
    _sessionStore.save(token: token, user: user);
    _apiClient.setSessionToken(token);
  }

  void _clearSession() {
    _sessionStore.clear();
    _apiClient.setSessionToken(null);
  }

  void dispose() => _http.close();
}
