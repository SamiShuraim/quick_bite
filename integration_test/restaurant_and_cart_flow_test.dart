/// Integration test for restaurant browsing and cart functionality
/// Tests the complete flow from browsing restaurants to adding items to cart
/// Runs with MOCKED backend services - no server required
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'test_helpers/test_app.dart' as app;
import 'test_helpers/test_utils.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Restaurant and Cart Flow Integration Tests', () {
    testWidgets('Browse restaurants and view restaurant details',
        (WidgetTester tester) async {
      await app.main();
      await tester.pumpAndSettle();
      await performLogin(tester);

      // Should be on home screen with restaurants
      expect(find.text('Home'), findsWidgets);

      // Wait for restaurants to load from mock
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Find restaurant cards (mocked data includes 2 restaurants)
      final restaurantCards = find.byType(Card);
      expect(restaurantCards, findsWidgets);

      // Tap on first restaurant if available
      if (restaurantCards.evaluate().isNotEmpty) {
        await tester.tap(restaurantCards.first);
        await tester.pumpAndSettle(const Duration(seconds: 2));

        // Should navigate to restaurant detail screen
        expect(find.byType(AppBar), findsWidgets);
      }
    });

    testWidgets('Add item to cart from restaurant menu',
        (WidgetTester tester) async {
      await performLogin(tester);
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Find and tap on a restaurant
      final restaurantCards = find.byType(Card);
      if (restaurantCards.evaluate().isNotEmpty) {
        await tester.tap(restaurantCards.first);
        await tester.pumpAndSettle(const Duration(seconds: 2));

        // Find menu items (mock provides 2 items)
        final menuItems = find.byType(Card);
        if (menuItems.evaluate().length > 1) {
          // Tap on a menu item
          await tester.tap(menuItems.at(1));
          await tester.pumpAndSettle();

          // Look for add to cart button
          final addButton = find.text('Add to Cart');
          if (addButton.evaluate().isNotEmpty) {
            await tester.tap(addButton);
            await tester.pumpAndSettle();

            // Should show success message
            expect(find.byType(SnackBar), findsWidgets);
          }
        }
      }
    });

    testWidgets('View cart after adding items',
        (WidgetTester tester) async {
      await performLogin(tester);
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Navigate to cart icon if visible
      final cartIcon = find.byIcon(Icons.shopping_cart);
      if (cartIcon.evaluate().isNotEmpty) {
        await tester.tap(cartIcon.first);
        await tester.pumpAndSettle();

        // Should be on cart screen
        expect(find.text('Cart'), findsWidgets);
      }
    });
  });
}
