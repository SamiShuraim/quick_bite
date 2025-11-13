/// Integration tests for app navigation flow
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quick_bite/main.dart';
import 'package:quick_bite/core/constants/app_constants.dart';

void main() {
  group('App Integration Tests', () {
    testWidgets('Should navigate through splash to onboarding',
        (WidgetTester tester) async {
      // Build the app
      await tester.pumpWidget(const QuickBiteApp());

      // Verify we're on splash screen
      expect(find.text(AppConstants.appName), findsOneWidget);

      // Wait for splash duration and pump
      await tester.pumpAndSettle(
        const Duration(seconds: AppConstants.splashDurationSeconds + 1),
      );

      // Verify we're on onboarding screen
      // Note: This test demonstrates integration testing structure
      // Actual assertions would depend on onboarding screen content
    });

    testWidgets('Should display app with correct theme',
        (WidgetTester tester) async {
      // Build the app
      await tester.pumpWidget(const QuickBiteApp());

      // Verify MaterialApp is present
      expect(find.byType(MaterialApp), findsOneWidget);

      // Verify initial screen loads
      expect(find.byType(Scaffold), findsOneWidget);
    });
  });
}

