import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:swf_app/src/api/api_client.dart';
import 'package:swf_app/src/auth/data/auth_repository.dart';
import 'package:swf_app/src/auth/data/session_store.dart';
import 'package:swf_app/src/auth/models/user.dart';
import 'package:swf_app/src/profile/data/profile_repository.dart';
import 'package:swf_app/src/profile/presentation/profile_page.dart';

void main() {
  testWidgets('author profile shows a locked subscriber ledger', (
    WidgetTester tester,
  ) async {
    final sessionStore = SessionStore()
      ..save(
        token: 'token-123',
        user: const User(
          id: 'author-1',
          email: 'author@example.com',
          name: 'Author',
          role: 'author',
        ),
      );
    final httpClient = MockClient((request) async {
      if (request.url.path == '/api/auth/me') {
        expect(
          request.headers[HttpHeaders.cookieHeader],
          'better-auth.session_token=token-123',
        );
        return http.Response(
          jsonEncode({
            'success': true,
            'data': {
              'user': {
                'id': 'author-1',
                'email': 'author@example.com',
                'name': 'Author',
                'role': 'author',
              },
            },
          }),
          200,
          headers: {'content-type': 'application/json'},
        );
      }

      if (request.url.path == '/api/subscribers/count') {
        return http.Response(
          jsonEncode({
            'success': true,
            'data': {
              'count': 184,
              'confirmed': 172,
              'unsubscribed': 9,
              'active': 163,
              'authorName': 'Author',
            },
          }),
          200,
          headers: {'content-type': 'application/json'},
        );
      }

      throw UnimplementedError('Unexpected request: ${request.url}');
    });
    final apiClient = ApiClient(
      baseUrl: 'http://localhost',
      httpClient: httpClient,
    )..setSessionToken('token-123');
    final authRepository = AuthRepository(
      baseUrl: 'http://localhost',
      apiClient: apiClient,
      sessionStore: sessionStore,
      httpClient: httpClient,
    );
    final profileRepository = ProfileRepository(apiClient: apiClient);

    await tester.pumpWidget(
      MaterialApp(
        home: ProfilePage(
          authRepository: authRepository,
          profileRepository: profileRepository,
          sessionStore: sessionStore,
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Field Journal'), findsWidgets);
    expect(find.text('Author Field Journal'), findsOneWidget);
    expect(find.byKey(const Key('subscriber-ledger-card')), findsOneWidget);
    expect(find.text('???'), findsOneWidget);
    expect(find.text('Locked upgrade'), findsOneWidget);
    expect(find.text('Open Author Help Scroll'), findsOneWidget);
  });

  testWidgets('completing a journal entry reveals its relic', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(800, 1600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final sessionStore = SessionStore()
      ..save(
        token: 'token-123',
        user: const User(
          id: 'reader-1',
          email: 'reader@example.com',
          name: 'Reader',
          role: 'reader',
        ),
      );
    final httpClient = MockClient((request) async {
      if (request.url.path == '/api/auth/me') {
        return http.Response(
          jsonEncode({
            'success': true,
            'data': {
              'user': {
                'id': 'reader-1',
                'email': 'reader@example.com',
                'name': 'Reader',
                'role': 'reader',
              },
            },
          }),
          200,
          headers: {'content-type': 'application/json'},
        );
      }

      throw UnimplementedError('Unexpected request: ${request.url}');
    });
    final apiClient = ApiClient(
      baseUrl: 'http://localhost',
      httpClient: httpClient,
    )..setSessionToken('token-123');
    final authRepository = AuthRepository(
      baseUrl: 'http://localhost',
      apiClient: apiClient,
      sessionStore: sessionStore,
      httpClient: httpClient,
    );

    await tester.pumpWidget(
      MaterialApp(
        home: ProfilePage(
          authRepository: authRepository,
          sessionStore: sessionStore,
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('quest-toggle-reader-taste-subgenre')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('quest-toggle-reader-taste-tropes')));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.byKey(const Key('quest-toggle-reader-taste-format')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('quest-toggle-reader-taste-format')));
    await tester.pumpAndSettle();

    expect(find.text('Relic Unlocked'), findsOneWidget);
    expect(find.text('Compass Rune'), findsWidgets);
    expect(find.text('Continue questing'), findsOneWidget);
  });
}
