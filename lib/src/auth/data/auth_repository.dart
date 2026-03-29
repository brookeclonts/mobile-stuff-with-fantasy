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
    final token = _sessionStore.token;
    print('[AUTH] getCurrentUser: hasToken=${token != null}, '
        'tokenLength=${token?.length ?? 0}');

    // Use better-auth's native get-session endpoint which supports Bearer
    // auth via the bearer plugin. The custom /api/auth/me route doesn't go
    // through better-auth's middleware so Bearer tokens don't work there.
    // Note: better-auth returns `null` (not an error) when unauthenticated,
    // which causes a FormatException in ApiClient. We treat that as 401.
    final result = await _apiClient.get<User>(
      '/api/auth/get-session',
      fromJson: (json) {
        final data = json as Map<String, Object?>;
        final userData = data['user'] as Map<String, Object?>?;
        if (userData == null) throw const FormatException('No user in session');
        return User.fromJson(userData);
      },
    );

    // `null` body from better-auth → FormatException → "Invalid response"
    if (result is Failure<User> &&
        result.message == 'Invalid response from server') {
      print('[AUTH] getCurrentUser: no session (null response)');
      _clearSession();
      return const Failure('Not authenticated', statusCode: 401);
    }

    if (result is Success<User>) {
      print('[AUTH] getCurrentUser: SUCCESS ${result.value.email}');
      if (token != null && token.isNotEmpty) {
        _sessionStore.save(token: token, user: result.value);
      }
      return result;
    }

    if (result is Failure<User>) {
      print('[AUTH] getCurrentUser: FAILED ${result.statusCode} — '
          '${result.message}');
      if (result.statusCode == 401) {
        _clearSession();
      }
    }

    return result;
  }

  /// Create a new account via better-auth.
  ///
  /// POST /api/auth/sign-up/email → creates auth user + session.
  /// The backend defaults new users to the "reader" role.
  Future<ApiResult<User>> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      // ── Step 1: better-auth sign-up ──
      final url = '$_baseUrl/api/auth/sign-up/email';
      debugPrint('AuthRepository.signUp: POST $url');

      final response = await _http.post(
        Uri.parse(url),
        headers: _jsonHeaders,
        body: jsonEncode({
          'email': email.toLowerCase().trim(),
          'password': password,
          'name': name.trim(),
        }),
      );

      debugPrint(
        'AuthRepository.signUp: ${response.statusCode} '
        '(${response.body.length} bytes)',
      );

      if (response.body.isEmpty) {
        return Failure(
          'Server returned an empty response (${response.statusCode})',
          statusCode: response.statusCode,
        );
      }

      final Object? decoded;
      try {
        decoded = jsonDecode(response.body);
      } on FormatException {
        debugPrint(
          'AuthRepository.signUp: non-JSON response: '
          '${response.body.substring(0, response.body.length.clamp(0, 500))}',
        );
        return Failure(
          'Server returned a non-JSON response (${response.statusCode})',
          statusCode: response.statusCode,
        );
      }

      if (decoded is! Map<String, Object?>) {
        return Failure(
          'Unexpected response format (${response.statusCode})',
          statusCode: response.statusCode,
        );
      }

      final body = decoded;

      if (response.statusCode < 200 || response.statusCode >= 300) {
        final error = _parseError(body) ?? 'Sign up failed';
        return Failure(error, statusCode: response.statusCode);
      }

      // The bearer plugin adds a `set-auth-token` response header with the
      // full signed token (token.hmac). This is what we need for Bearer auth.
      // Fall back to the body token if the header isn't present.
      final setAuthToken = response.headers['set-auth-token'];
      final sessionData = body['session'] as Map<String, Object?>?;
      String? token = setAuthToken;
      token ??= sessionData?['token'] as String?;
      token ??= body['token'] as String?;

      print('[AUTH] signUp: set-auth-token header present: ${setAuthToken != null}, '
          'token length: ${token?.length ?? 0}');

      final userData = body['user'] as Map<String, Object?>?;
      final user = User(
        id: (userData?['id'] ?? '').toString(),
        email: userData?['email'] as String? ?? email,
        name: userData?['name'] as String? ?? name,
      );

      if (token == null || token.isEmpty) {
        debugPrint(
          'AuthRepository.signUp: no token found. '
          'Full response body: ${response.body}',
        );
        return const Failure('Sign up succeeded, but no session was returned');
      }

      _sessionStore.save(token: token, user: user);
      _apiClient.setSessionToken(token);

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

  Future<ApiResult<void>> deleteAccount() async {
    final result = await _apiClient.delete<void>(
      '/api/user/delete/account',
      fromJson: (_) {},
    );

    if (result is Success<void>) {
      _clearSession();
    }

    return result;
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
          HttpHeaders.authorizationHeader: 'Bearer $token',
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

  void _clearSession() {
    _sessionStore.clear();
    _apiClient.setSessionToken(null);
  }

  void dispose() => _http.close();
}
