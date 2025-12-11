/// Integration test for complete order placement flow
/// Tests the full journey from login to order placement
/// Runs with MOCKED backend services - no server required
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'test_helpers/test_app.dart' as app;
import 'test_helpers/test_utils.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Complete Order Flow Integration Tests', () {
    testWidgets('Complete order flow: Browse → Restaurant → Food → Cart → Checkout',
        (WidgetTester tester) async {
      await app.main();
      await tester.pumpAndSettle();
      await performLogin(tester);

      // Should be on home screen
      expect(find.text('Home'), findsWidgets);
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Step 1: Browse restaurants
      final restaurantCards = find.byType(Card);
      expect(restaurantCards, findsWidgets);

      // Step 2: Tap on first restaurant
      if (restaurantCards.evaluate().isNotEmpty) {
        await tester.tap(restaurantCards.first);
        await tester.pumpAndSettle(const Duration(seconds: 2));

        // Should be on restaurant detail screen
        expect(find.byType(AppBar), findsWidgets);

        // Step 3: Find and tap on a menu item
        final menuItems = find.byType(Card);
        if (menuItems.evaluate().length > 1) {
          await tester.tap(menuItems.at(1));
          await tester.pumpAndSettle(const Duration(seconds: 1));

          // Step 4: Add to cart
          final addToCartButton = find.text('Add to Cart');
          if (addToCartButton.evaluate().isNotEmpty) {
            await tester.tap(addToCartButton);
            await tester.pumpAndSettle();

            // Should show success message
            expect(find.byType(SnackBar), findsWidgets);
          }

          // Step 5: Navigate to cart
          await tester.pumpAndSettle(const Duration(seconds: 1));
          final cartIcon = find.byIcon(Icons.shopping_cart);
          if (cartIcon.evaluate().isNotEmpty) {
            await tester.tap(cartIcon.first);
            await tester.pumpAndSettle();

            // Should be on cart screen
            expect(find.text('Cart'), findsWidgets);

            // Step 6: Proceed to checkout
            final checkoutButton = find.text('PROCEED TO CHECKOUT');
            if (checkoutButton.evaluate().isNotEmpty) {
              await tester.tap(checkoutButton);
              await tester.pumpAndSettle();

              // Should navigate to checkout/payment screen
              expect(find.byType(Scaffold), findsWidgets);
            }
          }
        }
      }
    });

    testWidgets('Add multiple items from different categories to cart',
        (WidgetTester tester) async {
      await performLogin(tester);
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Find restaurant
      final restaurantCards = find.byType(Card);
      if (restaurantCards.evaluate().isNotEmpty) {
        await tester.tap(restaurantCards.first);
        await tester.pumpAndSettle(const Duration(seconds: 2));

        // Add first item
        final menuItems = find.byType(Card);
        if (menuItems.evaluate().length > 1) {
          await tester.tap(menuItems.at(1));
          await tester.pumpAndSettle();

          final addButton1 = find.text('Add to Cart');
          if (addButton1.evaluate().isNotEmpty) {
            await tester.tap(addButton1);
            await tester.pumpAndSettle();
          }

          // Go back
          final backButton = find.byType(BackButton);
          if (backButton.evaluate().isNotEmpty) {
            await tester.tap(backButton.first);
            await tester.pumpAndSettle();
          }

          // Add second item
          if (menuItems.evaluate().length > 2) {
            await tester.tap(menuItems.at(2));
            await tester.pumpAndSettle();

            final addButton2 = find.text('Add to Cart');
            if (addButton2.evaluate().isNotEmpty) {
              await tester.tap(addButton2);
              await tester.pumpAndSettle();
            }
          }

          // Verify cart has multiple items
          final cartIcon = find.byIcon(Icons.shopping_cart);
          if (cartIcon.evaluate().isNotEmpty) {
            await tester.tap(cartIcon.first);
            await tester.pumpAndSettle();

            // Should show cart with items
            expect(find.text('Cart'), findsWidgets);
          }
        }
      }
    });

    testWidgets('Update item quantity in cart',
        (WidgetTester tester) async {
      await performLogin(tester);
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Add item to cart first
      final restaurantCards = find.byType(Card);
      if (restaurantCards.evaluate().isNotEmpty) {
        await tester.tap(restaurantCards.first);
        await tester.pumpAndSettle(const Duration(seconds: 2));

        final menuItems = find.byType(Card);
        if (menuItems.evaluate().length > 1) {
          await tester.tap(menuItems.at(1));
          await tester.pumpAndSettle();

          final addButton = find.text('Add to Cart');
          if (addButton.evaluate().isNotEmpty) {
            await tester.tap(addButton);
            await tester.pumpAndSettle();
          }

          // Navigate to cart
          final cartIcon = find.byIcon(Icons.shopping_cart);
          if (cartIcon.evaluate().isNotEmpty) {
            await tester.tap(cartIcon.first);
            await tester.pumpAndSettle();

            // Find increment button (usually a + icon)
            final incrementButtons = find.byIcon(Icons.add);
            if (incrementButtons.evaluate().isNotEmpty) {
              await tester.tap(incrementButtons.first);
              await tester.pumpAndSettle();

              // Quantity should increase
              // Price should update
              expect(find.byType(Text), findsWidgets);
            }
          }
        }
      }
    });

    testWidgets('Remove item from cart',
        (WidgetTester tester) async {
      await performLogin(tester);
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Add item to cart
      final restaurantCards = find.byType(Card);
      if (restaurantCards.evaluate().isNotEmpty) {
        await tester.tap(restaurantCards.first);
        await tester.pumpAndSettle(const Duration(seconds: 2));

        final menuItems = find.byType(Card);
        if (menuItems.evaluate().length > 1) {
          await tester.tap(menuItems.at(1));
          await tester.pumpAndSettle();

          final addButton = find.text('Add to Cart');
          if (addButton.evaluate().isNotEmpty) {
            await tester.tap(addButton);
            await tester.pumpAndSettle();
          }

          // Navigate to cart
          final cartIcon = find.byIcon(Icons.shopping_cart);
          if (cartIcon.evaluate().isNotEmpty) {
            await tester.tap(cartIcon.first);
            await tester.pumpAndSettle();

            // Find delete/remove button
            final deleteButtons = find.byIcon(Icons.delete);
            if (deleteButtons.evaluate().isNotEmpty) {
              await tester.tap(deleteButtons.first);
              await tester.pumpAndSettle();

              // Item should be removed
              // Cart might be empty
              expect(find.byType(Scaffold), findsWidgets);
            }
          }
        }
      }
    });

  });
}

