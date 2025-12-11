/// Integration test for complete authentication flow
/// Tests login, signup, and navigation to home screen
/// Runs on real device/emulator with MOCKED backend services
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'test_helpers/test_app.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Authentication Flow Integration Tests', () {
    testWidgets('Complete login journey from splash to home',
        (WidgetTester tester) async {
      // Start the test app with mocked services
      await app.main();
      await tester.pumpAndSettle();

      // Wait for splash screen to complete (shorter in test mode)
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Should be on onboarding screen - skip to login
      // Look for skip button or get started button
      final skipButton = find.text('Skip');
      if (skipButton.evaluate().isNotEmpty) {
        await tester.tap(skipButton);
        await tester.pumpAndSettle();
      } else {
        // Swipe through onboarding pages
        for (int i = 0; i < 4; i++) {
          await tester.drag(
            find.byType(PageView),
            const Offset(-400, 0),
          );
          await tester.pumpAndSettle();
        }
        // Tap Get Started button
        await tester.tap(find.text('GET STARTED'));
        await tester.pumpAndSettle();
      }

      // Should now be on login screen
      expect(find.text('Log In'), findsWidgets);
      expect(find.text('Please sign in to your existing account'), findsOneWidget);

      // Close the test account dialog if it appears
      await tester.pumpAndSettle(const Duration(seconds: 1));
      final okButton = find.text('OK');
      if (okButton.evaluate().isNotEmpty) {
        await tester.tap(okButton);
        await tester.pumpAndSettle();
      }

      // Enter login credentials (any credentials work with mock)
      final emailFields = find.byType(TextFormField);
      
      await tester.enterText(emailFields.at(0), 'test@example.com');
      await tester.pumpAndSettle();

      await tester.enterText(emailFields.at(1), 'password123');
      await tester.pumpAndSettle();

      // Tap login button (use warnIfMissed: false since button might be partially obscured)
      await tester.tap(find.text('LOG IN'), warnIfMissed: false);
      await tester.pumpAndSettle();

      // Wait for mock API call and navigation (needs more time)
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Should navigate to home screen with bottom navigation
      expect(find.text('Home'), findsWidgets);
      expect(find.text('Orders'), findsOneWidget);
      expect(find.text('Profile'), findsOneWidget);

      // Verify we're on the home screen
      expect(find.byIcon(Icons.home), findsWidgets);
    });

    testWidgets('Navigate to signup screen from login',
        (WidgetTester tester) async {
      await app.main();
      await tester.pumpAndSettle();

      // Navigate through splash and onboarding
      await tester.pumpAndSettle(const Duration(seconds: 3));


      // Skip onboarding
      final skipButton = find.text('Skip');
      if (skipButton.evaluate().isNotEmpty) {
        await tester.tap(skipButton);
        await tester.pumpAndSettle();
      }

      // Close dialog
      await tester.pumpAndSettle(const Duration(seconds: 1));
      final okButton = find.text('OK');
      if (okButton.evaluate().isNotEmpty) {
        await tester.tap(okButton);
        await tester.pumpAndSettle();
      }

      // Tap SIGN UP link
      await tester.tap(find.text('SIGN UP'));
      await tester.pumpAndSettle();

      // Should be on signup screen
      expect(find.text('Sign Up'), findsWidgets);
      expect(find.text('Please sign up to get started'), findsWidgets);
    });

  });
}

