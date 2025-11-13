/// Widget tests for SplashScreen
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quick_bite/features/onboarding/presentation/screens/splash_screen.dart';
import 'package:quick_bite/core/constants/app_constants.dart';

void main() {
  group('SplashScreen Widget Tests', () {
    testWidgets('Should display app name', (WidgetTester tester) async {
      // Build the SplashScreen widget
      await tester.pumpWidget(
        const MaterialApp(
          home: SplashScreen(),
        ),
      );

      // Verify that app name is displayed
      expect(find.text(AppConstants.appName), findsOneWidget);
    });

    testWidgets('Should display app tagline', (WidgetTester tester) async {
      // Build the SplashScreen widget
      await tester.pumpWidget(
        const MaterialApp(
          home: SplashScreen(),
        ),
      );

      // Verify that tagline is displayed
      expect(find.text(AppConstants.appTagline), findsOneWidget);
    });

    testWidgets('Should display logo', (WidgetTester tester) async {
      // Build the SplashScreen widget
      await tester.pumpWidget(
        const MaterialApp(
          home: SplashScreen(),
        ),
      );

      // Verify that logo emoji is displayed
      expect(find.text('🍔'), findsOneWidget);
    });
  });
}

