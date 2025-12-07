/// Widget tests for MenuItemCard
/// Tests menu item card display and interactions
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quick_bite/features/restaurant/presentation/widgets/menu_item_card.dart';
import 'package:quick_bite/features/restaurant/domain/entities/menu_item_entity.dart';

void main() {
  group('MenuItemCard Widget Tests', () {
    late MenuItemEntity testMenuItem;

    setUp(() {
      testMenuItem = const MenuItemEntity(
        id: 'item1',
        restaurantId: 'rest1',
        name: 'Delicious Burger',
        description: 'A tasty beef burger with cheese',
        imageUrl: 'https://example.com/burger.jpg',
        price: 25.50,
        category: 'Fast Food',
        rating: 4.5,
        reviewCount: 75,
        isPopular: true,
        isVegetarian: false,
        ingredients: ['beef', 'cheese', 'lettuce'],
      );
    });

    testWidgets('MenuItemCard should display item name',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MenuItemCard(
              menuItem: testMenuItem,
              onTap: () {},
            ),
          ),
        ),
      );

      expect(find.text('Delicious Burger'), findsOneWidget);
    });

    testWidgets('MenuItemCard should display item description',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MenuItemCard(
              menuItem: testMenuItem,
              onTap: () {},
            ),
          ),
        ),
      );

      expect(find.text('A tasty beef burger with cheese'), findsOneWidget);
    });

    testWidgets('MenuItemCard should display rating',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MenuItemCard(
              menuItem: testMenuItem,
              onTap: () {},
            ),
          ),
        ),
      );

      expect(find.text('4.5'), findsOneWidget);
      expect(find.text(' (75)'), findsOneWidget);
      expect(find.byIcon(Icons.star), findsOneWidget);
    });

    testWidgets('MenuItemCard should display price',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MenuItemCard(
              menuItem: testMenuItem,
              onTap: () {},
            ),
          ),
        ),
      );

      // Price should be formatted with SAR currency
      expect(find.textContaining('25'), findsOneWidget);
    });

    testWidgets('MenuItemCard should show popular indicator when isPopular is true',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MenuItemCard(
              menuItem: testMenuItem,
              onTap: () {},
            ),
          ),
        ),
      );

      expect(find.text('🔥'), findsOneWidget);
    });

    testWidgets('MenuItemCard should not show popular indicator when isPopular is false',
        (WidgetTester tester) async {
      final menuItem = MenuItemEntity(
        id: testMenuItem.id,
        restaurantId: testMenuItem.restaurantId,
        name: testMenuItem.name,
        description: testMenuItem.description,
        imageUrl: testMenuItem.imageUrl,
        price: testMenuItem.price,
        category: testMenuItem.category,
        rating: testMenuItem.rating,
        reviewCount: testMenuItem.reviewCount,
        isPopular: false,
        ingredients: testMenuItem.ingredients,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MenuItemCard(
              menuItem: menuItem,
              onTap: () {},
            ),
          ),
        ),
      );

      expect(find.text('🔥'), findsNothing);
    });

    testWidgets('MenuItemCard should be tappable', (WidgetTester tester) async {
      var tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MenuItemCard(
              menuItem: testMenuItem,
              onTap: () {
                tapped = true;
              },
            ),
          ),
        ),
      );

      await tester.tap(find.byType(MenuItemCard));
      await tester.pump();

      expect(tapped, true);
    });

    testWidgets('MenuItemCard should handle image loading errors',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MenuItemCard(
              menuItem: testMenuItem,
              onTap: () {},
            ),
          ),
        ),
      );

      // Wait for image to attempt to load and fail
      await tester.pump();

      // Should show fallback icon
      expect(find.byIcon(Icons.fastfood), findsOneWidget);
    });

    testWidgets('MenuItemCard should display different ratings correctly',
        (WidgetTester tester) async {
      final menuItem = MenuItemEntity(
        id: testMenuItem.id,
        restaurantId: testMenuItem.restaurantId,
        name: testMenuItem.name,
        description: testMenuItem.description,
        imageUrl: testMenuItem.imageUrl,
        price: testMenuItem.price,
        category: testMenuItem.category,
        rating: 3.7,
        reviewCount: 50,
        ingredients: testMenuItem.ingredients,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MenuItemCard(
              menuItem: menuItem,
              onTap: () {},
            ),
          ),
        ),
      );

      expect(find.text('3.7'), findsOneWidget);
      expect(find.text(' (50)'), findsOneWidget);
    });

    testWidgets('MenuItemCard should display different prices correctly',
        (WidgetTester tester) async {
      final menuItem = MenuItemEntity(
        id: testMenuItem.id,
        restaurantId: testMenuItem.restaurantId,
        name: testMenuItem.name,
        description: testMenuItem.description,
        imageUrl: testMenuItem.imageUrl,
        price: 99.99,
        category: testMenuItem.category,
        rating: testMenuItem.rating,
        reviewCount: testMenuItem.reviewCount,
        ingredients: testMenuItem.ingredients,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MenuItemCard(
              menuItem: menuItem,
              onTap: () {},
            ),
          ),
        ),
      );

      expect(find.textContaining('99'), findsOneWidget);
    });
  });
}
