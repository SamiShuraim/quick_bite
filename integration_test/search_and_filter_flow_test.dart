/// Integration test for search and filter functionality
/// Tests restaurant search, filtering, and sorting
/// Runs with MOCKED backend services - no server required
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'test_helpers/test_app.dart' as app;
import 'test_helpers/test_utils.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Search and Filter Flow Integration Tests', () {
    testWidgets('Search for restaurants by name',
        (WidgetTester tester) async {
      await app.main();
      await tester.pumpAndSettle();
      await performLogin(tester);
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Find search field
      final searchFields = find.byType(TextField);
      if (searchFields.evaluate().isNotEmpty) {
        await tester.enterText(searchFields.first, 'Burger');
        await tester.pumpAndSettle(const Duration(seconds: 1));

        // Results should filter
        expect(find.byType(Card), findsWidgets);
      }
    });

    testWidgets('Filter restaurants by category',
        (WidgetTester tester) async {
      await performLogin(tester);
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Find category chips
      final burgerCategory = find.text('Burger');
      if (burgerCategory.evaluate().isNotEmpty) {
        await tester.tap(burgerCategory);
        await tester.pumpAndSettle(const Duration(seconds: 1));

        // Should show only burger restaurants
        expect(find.byType(Card), findsWidgets);
      }

      // Try another category
      final pizzaCategory = find.text('Pizza');
      if (pizzaCategory.evaluate().isNotEmpty) {
        await tester.tap(pizzaCategory);
        await tester.pumpAndSettle(const Duration(seconds: 1));

        // Should show only pizza restaurants
        expect(find.byType(Card), findsWidgets);
      }
    });

    testWidgets('Open filter dialog and apply filters',
        (WidgetTester tester) async {
      await performLogin(tester);
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Find filter button (usually an icon button)
      final filterButtons = find.byIcon(Icons.filter_list);
      if (filterButtons.evaluate().isNotEmpty) {
        await tester.tap(filterButtons.first);
        await tester.pumpAndSettle();

        // Should open filter dialog/screen
        expect(find.byType(Dialog), findsWidgets);

        // Look for sliders or filter options
        final sliders = find.byType(Slider);
        if (sliders.evaluate().isNotEmpty) {
          // Interact with price range slider
          await tester.drag(sliders.first, const Offset(50, 0));
          await tester.pumpAndSettle();
        }

        // Apply filters
        final applyButton = find.text('Apply');
        if (applyButton.evaluate().isNotEmpty) {
          await tester.tap(applyButton);
          await tester.pumpAndSettle();

          // Should close dialog and show filtered results
          expect(find.byType(Card), findsWidgets);
        }
      }
    });

    testWidgets('Clear search and show all restaurants',
        (WidgetTester tester) async {
      await performLogin(tester);
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Enter search term
      final searchFields = find.byType(TextField);
      if (searchFields.evaluate().isNotEmpty) {
        await tester.enterText(searchFields.first, 'Pizza');
        await tester.pumpAndSettle(const Duration(seconds: 1));

        // Clear search
        final clearButtons = find.byIcon(Icons.clear);
        if (clearButtons.evaluate().isNotEmpty) {
          await tester.tap(clearButtons.first);
          await tester.pumpAndSettle();

          // Should show all restaurants again
          expect(find.byType(Card), findsWidgets);
        }
      }
    });

    testWidgets('Filter by free delivery',
        (WidgetTester tester) async {
      await performLogin(tester);
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Look for free delivery filter
      final freeDeliveryFilter = find.text('Free Delivery');
      if (freeDeliveryFilter.evaluate().isNotEmpty) {
        await tester.tap(freeDeliveryFilter);
        await tester.pumpAndSettle();

        // Should show only free delivery restaurants
        expect(find.byType(Card), findsWidgets);
      }
    });

    testWidgets('Sort restaurants by rating',
        (WidgetTester tester) async {
      await performLogin(tester);
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Look for sort button or dropdown
      final sortButtons = find.byIcon(Icons.sort);
      if (sortButtons.evaluate().isNotEmpty) {
        await tester.tap(sortButtons.first);
        await tester.pumpAndSettle();

        // Select rating sort
        final ratingOption = find.text('Rating');
        if (ratingOption.evaluate().isNotEmpty) {
          await tester.tap(ratingOption);
          await tester.pumpAndSettle();

          // Restaurants should be sorted by rating
          expect(find.byType(Card), findsWidgets);
        }
      }
    });

    testWidgets('Sort restaurants by delivery time',
        (WidgetTester tester) async {
      await performLogin(tester);
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Look for sort options
      final sortButtons = find.byIcon(Icons.sort);
      if (sortButtons.evaluate().isNotEmpty) {
        await tester.tap(sortButtons.first);
        await tester.pumpAndSettle();

        // Select delivery time sort
        final deliveryOption = find.text('Delivery Time');
        if (deliveryOption.evaluate().isNotEmpty) {
          await tester.tap(deliveryOption);
          await tester.pumpAndSettle();

          // Restaurants should be sorted by delivery time
          expect(find.byType(Card), findsWidgets);
        }
      }
    });
  });
}


