import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:swf_app/src/api/service_locator.dart';
import 'package:swf_app/src/app.dart';

void main() {
  setUp(() {
    // Initialize services with a dummy base URL for tests.
    // Network calls will fail but the app should still render.
    ServiceLocator.init(baseUrl: 'http://localhost:0');
  });

  tearDown(ServiceLocator.dispose);

  testWidgets('renders the book catalog', (WidgetTester tester) async {
    await tester.pumpWidget(const SwfApp());

    // Search bar is present
    expect(find.byType(TextField), findsOneWidget);

    // Loading indicator appears while fetching
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
