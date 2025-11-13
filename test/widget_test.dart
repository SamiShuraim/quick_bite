/// Widget tests for QuickBite app
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quick_bite/main.dart';

void main() {
  testWidgets('QuickBite app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const QuickBiteApp());

    // Verify that MaterialApp is created
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
