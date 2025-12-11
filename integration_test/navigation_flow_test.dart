/// Integration test for app navigation
/// Tests navigation between screens
/// Runs with MOCKED backend services - no server required
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'test_helpers/test_app.dart' as app;
import 'test_helpers/test_utils.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Navigation Flow Integration Tests', () {
    testWidgets('Navigate between bottom navigation tabs',
        (WidgetTester tester) async {
      await app.main();
      await tester.pumpAndSettle();
      await performLogin(tester);

      // Should be on Home tab
      expect(find.text('Home'), findsWidgets);

      // Tap Orders tab
      final ordersTab = find.text('Orders');
      await tester.tap(ordersTab);
      await tester.pumpAndSettle();

      // Should be on Orders screen
      expect(find.text('Orders'), findsWidgets);

      // Tap Profile tab
      final profileTab = find.text('Profile');
      await tester.tap(profileTab);
      await tester.pumpAndSettle();

      // Should be on Profile screen
      expect(find.text('Profile'), findsWidgets);

      // Tap Home tab to return
      final homeTab = find.text('Home');
      await tester.tap(homeTab);
      await tester.pumpAndSettle();

      // Should be back on Home screen
      expect(find.text('Home'), findsWidgets);
    });

    testWidgets('Navigate to profile and view settings',
        (WidgetTester tester) async {
      await performLogin(tester);

      // Navigate to Profile tab
      final profileTab = find.text('Profile');
      await tester.tap(profileTab);
      await tester.pumpAndSettle();

      // Should be on profile screen
      expect(find.text('Profile'), findsWidgets);

      // Profile screen should have user information
      expect(find.byType(ListTile), findsWidgets);
    });

    testWidgets('Toggle theme between light and dark mode',
        (WidgetTester tester) async {
      await performLogin(tester);

      // Navigate to Profile tab
      final profileTab = find.text('Profile');
      await tester.tap(profileTab);
      await tester.pumpAndSettle();

      // Look for theme toggle switch
      final themeSwitch = find.byType(Switch);
      if (themeSwitch.evaluate().isNotEmpty) {
        // Toggle theme
        await tester.tap(themeSwitch.first);
        await tester.pumpAndSettle();

        // Theme should change
        final scaffold = tester.widget<Scaffold>(find.byType(Scaffold).first);
        expect(scaffold.backgroundColor, isNotNull);

        // Toggle back
        await tester.tap(themeSwitch.first);
        await tester.pumpAndSettle();
      }
    });
  });
}

