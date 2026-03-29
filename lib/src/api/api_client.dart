import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:swf_app/src/api/api_result.dart';

/// Centralized HTTP client for the StuffWithFantasy API.
///
/// Wraps [http.Client] with:
/// - base URL resolution
/// - standard headers
/// - response envelope parsing (`{ success, data }` / `{ error }`)
/// - typed error handling via [ApiResult]
///
/// Usage:
/// ```dart
/// final client = ApiClient(baseUrl: 'https://stuffwithfantasy.com');
/// final result = await client.get('/api/books', fromJson: ...);
/// ```
class ApiClient {
  ApiClient({
    required this.baseUrl,
    http.Client? httpClient,
  }) : _http = httpClient ?? http.Client();

  final String baseUrl;
  final http.Client _http;
  String? _sessionToken;

  /// Set (or clear) the better-auth session token for authenticated requests.
  void setSessionToken(String? token) => _sessionToken = token;

  Map<String, String> get _defaultHeaders => {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.acceptHeader: 'application/json',
        if (_sessionToken != null)
          HttpHeaders.cookieHeader:
              '__Secure-better-auth.session_token=$_sessionToken',
      };

  // ---------------------------------------------------------------------------
  // Public API
  // ---------------------------------------------------------------------------

  /// GET request. Parses the `data` field with [fromJson].
  Future<ApiResult<T>> get<T>(
    String path, {
    required T Function(Object json) fromJson,
    Map<String, String>? queryParams,
    Map<String, String>? headers,
  }) async {
    return _request(
      () => _http.get(
        _buildUri(path, queryParams),
        headers: {..._defaultHeaders, ...?headers},
      ),
      fromJson: fromJson,
    );
  }

  /// POST request with a JSON body. Parses the `data` field with [fromJson].
  Future<ApiResult<T>> post<T>(
    String path, {
    required T Function(Object json) fromJson,
    Object? body,
    Map<String, String>? headers,
  }) async {
    return _request(
      () => _http.post(
        _buildUri(path),
        headers: {..._defaultHeaders, ...?headers},
        body: body != null ? jsonEncode(body) : null,
      ),
      fromJson: fromJson,
    );
  }

  /// PUT request with a JSON body.
  Future<ApiResult<T>> put<T>(
    String path, {
    required T Function(Object json) fromJson,
    Object? body,
    Map<String, String>? headers,
  }) async {
    return _request(
      () => _http.put(
        _buildUri(path),
        headers: {..._defaultHeaders, ...?headers},
        body: body != null ? jsonEncode(body) : null,
      ),
      fromJson: fromJson,
    );
  }

  /// PATCH request with a JSON body.
  Future<ApiResult<T>> patch<T>(
    String path, {
    required T Function(Object json) fromJson,
    Object? body,
    Map<String, String>? headers,
  }) async {
    return _request(
      () => _http.patch(
        _buildUri(path),
        headers: {..._defaultHeaders, ...?headers},
        body: body != null ? jsonEncode(body) : null,
      ),
      fromJson: fromJson,
    );
  }

  /// DELETE request.
  Future<ApiResult<T>> delete<T>(
    String path, {
    required T Function(Object json) fromJson,
    Map<String, String>? headers,
  }) async {
    return _request(
      () => _http.delete(
        _buildUri(path),
        headers: {..._defaultHeaders, ...?headers},
      ),
      fromJson: fromJson,
    );
  }

  /// Close the underlying HTTP client.
  void dispose() => _http.close();

  // ---------------------------------------------------------------------------
  // Internals
  // ---------------------------------------------------------------------------

  Uri _buildUri(String path, [Map<String, String>? queryParams]) {
    final uri = Uri.parse('$baseUrl$path');
    if (queryParams != null && queryParams.isNotEmpty) {
      return uri.replace(queryParameters: queryParams);
    }
    return uri;
  }

  /// Runs [send], parses the standard API envelope, and returns a typed result.
  Future<ApiResult<T>> _request<T>(
    Future<http.Response> Function() send, {
    required T Function(Object json) fromJson,
  }) async {
    try {
      final response = await send();
      final body = jsonDecode(response.body) as Map<String, Object?>;

      if (response.statusCode >= 200 && response.statusCode < 300) {
        // Standard envelope: { success: true, data: T }
        final data = body['data'];
        if (data != null) {
          return Success(fromJson(data));
        }
        // Some endpoints return the payload at the top level.
        return Success(fromJson(body));
      }

      // Error envelope: { error: "message" }
      final errorMessage =
          body['error'] as String? ?? 'Request failed (${response.statusCode})';
      return Failure(errorMessage, statusCode: response.statusCode);
    } on SocketException {
      return const Failure('No internet connection');
    } on HttpException {
      return const Failure('Server unreachable');
    } on FormatException {
      return const Failure('Invalid response from server');
    } catch (e) {
      debugPrint('ApiClient error: $e');
      return Failure('Unexpected error: $e');
    }
  }
}
