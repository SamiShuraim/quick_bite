/// Shared utility functions for integration tests
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Helper function to perform login flow
/// This handles the onboarding, dialog dismissal, and login
/// NOTE: Call this AFTER app.main() and initial pumpAndSettle()
Future<void> performLogin(WidgetTester tester) async {
  // Wait for splash screen
  await tester.pumpAndSettle(const Duration(seconds: 3));

  // Skip onboarding if present
  final skipButton = find.text('Skip');
  if (skipButton.evaluate().isNotEmpty) {
    await tester.tap(skipButton);
    await tester.pumpAndSettle();
  } else {
    // Check if PageView exists before trying to swipe
    final pageView = find.byType(PageView);
    if (pageView.evaluate().isNotEmpty) {
      // Swipe through onboarding
      for (int i = 0; i < 4; i++) {
        await tester.drag(pageView, const Offset(-400, 0));
        await tester.pumpAndSettle();
      }
    }
    final getStarted = find.text('GET STARTED');
    if (getStarted.evaluate().isNotEmpty) {
      await tester.tap(getStarted);
      await tester.pumpAndSettle();
    }
  }

  // Dismiss the test account dialog
  await tester.pumpAndSettle(const Duration(seconds: 1));
  final okButton = find.text('OK');
  if (okButton.evaluate().isNotEmpty) {
    await tester.tap(okButton);
    await tester.pumpAndSettle();
  }

  // Enter credentials
  final emailFields = find.byType(TextFormField);
  if (emailFields.evaluate().length >= 2) {
    await tester.enterText(emailFields.at(0), 'test@example.com');
    await tester.pumpAndSettle();
    await tester.enterText(emailFields.at(1), 'password123');
    await tester.pumpAndSettle();
  }

  // Tap login button (warnIfMissed: false to avoid obscured widget warnings)
  final loginButton = find.text('LOG IN');
  if (loginButton.evaluate().isEmpty) {
    print('❌ LOGIN button not found!');
    // Debug: Print what's on screen
    print('📱 Current screen widgets:');
    print('  - Log In title: ${find.text('Log In').evaluate().isNotEmpty}');
    print('  - Sign Up title: ${find.text('Sign Up').evaluate().isNotEmpty}');
    print('  - Onboarding: ${find.text('Skip').evaluate().isNotEmpty}');
    return;
  }
  
  print('✅ Tapping LOGIN button...');
  await tester.tap(loginButton, warnIfMissed: false);
  await tester.pumpAndSettle();

  // Wait for navigation to complete (login has 500ms delay + animation)
  print('⏳ Waiting for navigation...');
  await tester.pumpAndSettle(const Duration(seconds: 4));
  
  // Debug: Check what's on screen now
  print('📱 After login attempt:');
  print('  - Home: ${find.text('Home').evaluate().isNotEmpty}');
  print('  - Orders: ${find.text('Orders').evaluate().isNotEmpty}');
  print('  - Profile: ${find.text('Profile').evaluate().isNotEmpty}');
  print('  - Log In: ${find.text('Log In').evaluate().isNotEmpty}');
}

/// Helper to dismiss any dialogs that might be present
Future<void> dismissDialogs(WidgetTester tester) async {
  await tester.pumpAndSettle(const Duration(milliseconds: 500));
  
  final okButton = find.text('OK');
  if (okButton.evaluate().isNotEmpty) {
    await tester.tap(okButton);
    await tester.pumpAndSettle();
  }
  
  final closeButton = find.byIcon(Icons.close);
  if (closeButton.evaluate().isNotEmpty) {
    await tester.tap(closeButton.first);
    await tester.pumpAndSettle();
  }
}

/// Helper to navigate to a specific bottom nav tab
Future<void> navigateToTab(WidgetTester tester, String tabLabel) async {
  final tab = find.text(tabLabel);
  if (tab.evaluate().isNotEmpty) {
    await tester.tap(tab);
    await tester.pumpAndSettle();
  }
}

/// Helper to wait for widgets to appear
Future<void> waitForWidget(
  WidgetTester tester,
  Finder finder, {
  Duration timeout = const Duration(seconds: 5),
}) async {
  final end = DateTime.now().add(timeout);
  
  while (DateTime.now().isBefore(end)) {
    await tester.pumpAndSettle(const Duration(milliseconds: 100));
    
    if (finder.evaluate().isNotEmpty) {
      return;
    }
  }
  
  throw Exception('Widget not found after ${timeout.inSeconds} seconds');
}

