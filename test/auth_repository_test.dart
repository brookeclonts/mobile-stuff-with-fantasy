import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:swf_app/src/api/api_client.dart';
import 'package:swf_app/src/api/api_result.dart';
import 'package:swf_app/src/auth/data/auth_repository.dart';
import 'package:swf_app/src/auth/data/session_store.dart';
import 'package:swf_app/src/auth/models/user.dart';

void main() {
  test('getCurrentUser refreshes the session user from the backend', () async {
    final httpClient = MockClient((request) async {
      expect(request.url.path, '/api/auth/me');
      expect(
        request.headers[HttpHeaders.cookieHeader],
        'better-auth.session_token=token-123',
      );
      return http.Response(
        jsonEncode({
          'success': true,
          'data': {
            'user': {
              'id': 'user-1',
              'email': 'reader@example.com',
              'name': 'Updated Reader',
              'role': 'author',
            },
          },
        }),
        200,
        headers: {'content-type': 'application/json'},
      );
    });
    final apiClient = ApiClient(
      baseUrl: 'http://localhost',
      httpClient: httpClient,
    )..setSessionToken('token-123');
    final sessionStore = SessionStore()
      ..save(
        token: 'token-123',
        user: const User(
          id: 'user-1',
          email: 'reader@example.com',
          name: 'Old Name',
          role: 'reader',
        ),
      );
    final repository = AuthRepository(
      baseUrl: 'http://localhost',
      apiClient: apiClient,
      sessionStore: sessionStore,
      httpClient: httpClient,
    );

    final result = await repository.getCurrentUser();

    expect(result, isA<Success<User>>());
    expect(sessionStore.user?.name, 'Updated Reader');
    expect(sessionStore.user?.role, 'author');
  });

  test(
    'getCurrentUser clears the session when the backend returns 401',
    () async {
      final httpClient = MockClient((request) async {
        return http.Response(
          jsonEncode({'error': 'Not authenticated'}),
          401,
          headers: {'content-type': 'application/json'},
        );
      });
      final apiClient = ApiClient(
        baseUrl: 'http://localhost',
        httpClient: httpClient,
      )..setSessionToken('token-123');
      final sessionStore = SessionStore()
        ..save(
          token: 'token-123',
          user: const User(
            id: 'user-1',
            email: 'reader@example.com',
            name: 'Reader',
            role: 'reader',
          ),
        );
      final repository = AuthRepository(
        baseUrl: 'http://localhost',
        apiClient: apiClient,
        sessionStore: sessionStore,
        httpClient: httpClient,
      );

      final result = await repository.getCurrentUser();

      expect(result, isA<Failure<User>>());
      expect(sessionStore.isAuthenticated, isFalse);
      expect(sessionStore.user, isNull);
    },
  );

  test('signUp fails when role persistence fails', () async {
    final sessionStore = SessionStore();
    final repository = AuthRepository(
      baseUrl: 'http://localhost',
      apiClient: ApiClient(baseUrl: 'http://localhost'),
      sessionStore: sessionStore,
      httpClient: MockClient((request) async {
        if (request.url.path == '/api/auth/sign-up/email') {
          return http.Response(
            jsonEncode({
              'user': {
                'id': 'user-1',
                'email': 'reader@example.com',
                'name': 'Reader',
              },
              'session': {'token': 'token-123'},
            }),
            200,
            headers: {'content-type': 'application/json'},
          );
        }

        if (request.url.path == '/api/user/role') {
          return http.Response(
            jsonEncode({'error': 'Unauthorized'}),
            401,
            headers: {'content-type': 'application/json'},
          );
        }

        throw UnimplementedError('Unexpected request: ${request.url}');
      }),
    );

    final result = await repository.signUp(
      name: 'Reader',
      email: 'reader@example.com',
      password: 'password123',
      role: UserRole.reader,
    );

    expect(result, isA<Failure<User>>());
    expect(
      result.when(success: (_) => null, failure: (message, _) => message),
      'Unauthorized',
    );
    expect(sessionStore.isAuthenticated, isFalse);
    expect(sessionStore.token, isNull);
    expect(sessionStore.user, isNull);
  });

  test(
    'signUp restores the previous session when role persistence fails',
    () async {
      final sessionStore = SessionStore()
        ..save(
          token: 'existing-token',
          user: const User(
            id: 'existing-user',
            email: 'existing@example.com',
            name: 'Existing',
            role: 'reader',
          ),
        );
      final repository = AuthRepository(
        baseUrl: 'http://localhost',
        apiClient: ApiClient(baseUrl: 'http://localhost'),
        sessionStore: sessionStore,
        httpClient: MockClient((request) async {
          if (request.url.path == '/api/auth/sign-up/email') {
            return http.Response(
              jsonEncode({
                'user': {
                  'id': 'user-2',
                  'email': 'reader@example.com',
                  'name': 'Reader',
                },
                'session': {'token': 'token-456'},
              }),
              200,
              headers: {'content-type': 'application/json'},
            );
          }

          if (request.url.path == '/api/user/role') {
            return http.Response(
              jsonEncode({'error': 'Unauthorized'}),
              401,
              headers: {'content-type': 'application/json'},
            );
          }

          throw UnimplementedError('Unexpected request: ${request.url}');
        }),
      );

      final result = await repository.signUp(
        name: 'Reader',
        email: 'reader@example.com',
        password: 'password123',
        role: UserRole.reader,
      );

      expect(result, isA<Failure<User>>());
      expect(sessionStore.isAuthenticated, isTrue);
      expect(sessionStore.token, 'existing-token');
      expect(sessionStore.user?.id, 'existing-user');
      expect(sessionStore.user?.email, 'existing@example.com');
    },
  );

  test('signUp succeeds when role persistence succeeds', () async {
    final sessionStore = SessionStore();
    final repository = AuthRepository(
      baseUrl: 'http://localhost',
      apiClient: ApiClient(baseUrl: 'http://localhost'),
      sessionStore: sessionStore,
      httpClient: MockClient((request) async {
        if (request.url.path == '/api/auth/sign-up/email') {
          return http.Response(
            jsonEncode({
              'user': {
                'id': 'user-1',
                'email': 'author@example.com',
                'name': 'Author',
              },
              'session': {'token': 'token-123'},
            }),
            200,
            headers: {'content-type': 'application/json'},
          );
        }

        if (request.url.path == '/api/user/role') {
          expect(
            request.headers[HttpHeaders.cookieHeader],
            'better-auth.session_token=token-123',
          );
          return http.Response(
            jsonEncode({
              'success': true,
              'data': {'role': 'author'},
            }),
            200,
            headers: {'content-type': 'application/json'},
          );
        }

        throw UnimplementedError('Unexpected request: ${request.url}');
      }),
    );

    final result = await repository.signUp(
      name: 'Author',
      email: 'author@example.com',
      password: 'password123',
      role: UserRole.author,
    );

    expect(result, isA<Success<User>>());
    expect(sessionStore.isAuthenticated, isTrue);
    expect(sessionStore.user?.role, UserRole.author.apiValue);
  });

  test('signOut clears the local session on success', () async {
    final apiClient = ApiClient(baseUrl: 'http://localhost')
      ..setSessionToken('token-123');
    final sessionStore = SessionStore()
      ..save(
        token: 'token-123',
        user: const User(
          id: 'user-1',
          email: 'reader@example.com',
          name: 'Reader',
          role: 'reader',
        ),
      );
    final repository = AuthRepository(
      baseUrl: 'http://localhost',
      apiClient: apiClient,
      sessionStore: sessionStore,
      httpClient: MockClient((request) async {
        expect(request.url.path, '/api/auth/sign-out');
        expect(
          request.headers[HttpHeaders.cookieHeader],
          'better-auth.session_token=token-123',
        );
        return http.Response('', 200);
      }),
    );

    final result = await repository.signOut();

    expect(result, isA<Success<void>>());
    expect(sessionStore.isAuthenticated, isFalse);
    expect(sessionStore.user, isNull);
  });
}
