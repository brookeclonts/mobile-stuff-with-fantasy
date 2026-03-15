import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:swf_app/src/app.dart';

void main() {
  testWidgets('renders the sign-up flow shell', (WidgetTester tester) async {
    await tester.pumpWidget(const SwfApp());

    expect(find.byType(PageView), findsOneWidget);
    expect(find.text('Skip'), findsOneWidget);
  });
}
