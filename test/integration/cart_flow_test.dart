/// Integration tests for cart flow
/// Tests adding items to cart, validating restaurant restrictions, and checkout flow
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quick_bite/features/restaurant/presentation/providers/cart_provider.dart';
import 'package:quick_bite/features/restaurant/domain/entities/menu_item_entity.dart';
import 'package:provider/provider.dart';

void main() {
  group('Cart Flow Integration Tests', () {
    testWidgets('Adding items from same restaurant should work',
        (WidgetTester tester) async {
      final cartProvider = CartProvider();

      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider.value(
            value: cartProvider,
            child: Builder(
              builder: (context) {
                final cart = Provider.of<CartProvider>(context);

                return Scaffold(
                  body: Column(
                    children: [
                      Text('Cart Items: ${cart.itemCount}'),
                      Text('Total: ${cart.total.toStringAsFixed(2)}'),
                      ElevatedButton(
                        onPressed: () {
                          cart.addItem(
                            menuItem: const MenuItemEntity(
                              id: 'item1',
                              restaurantId: 'rest1',
                              name: 'Burger',
                              description: 'Delicious',
                              imageUrl: 'url',
                              price: 25.0,
                              category: 'Fast Food',
                              rating: 4.5,
                              reviewCount: 100,
                              ingredients: [],
                            ),
                            restaurantId: 'rest1',
                            restaurantName: 'Restaurant 1',
                            restaurantDeliveryFee: 5.0,
                            isFreeDelivery: false,
                          );
                        },
                        child: const Text('Add Burger'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          cart.addItem(
                            menuItem: const MenuItemEntity(
                              id: 'item2',
                              restaurantId: 'rest1',
                              name: 'Fries',
                              description: 'Crispy',
                              imageUrl: 'url',
                              price: 10.0,
                              category: 'Sides',
                              rating: 4.0,
                              reviewCount: 50,
                              ingredients: [],
                            ),
                            restaurantId: 'rest1',
                            restaurantName: 'Restaurant 1',
                            restaurantDeliveryFee: 5.0,
                            isFreeDelivery: false,
                          );
                        },
                        child: const Text('Add Fries'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      );

      expect(find.text('Cart Items: 0'), findsOneWidget);

      // Add first item
      await tester.tap(find.text('Add Burger'));
      await tester.pumpAndSettle();

      expect(find.text('Cart Items: 1'), findsOneWidget);

      // Add second item from same restaurant
      await tester.tap(find.text('Add Fries'));
      await tester.pumpAndSettle();

      expect(find.text('Cart Items: 2'), findsOneWidget);
    });

    testWidgets('Detecting different restaurant should work correctly',
        (WidgetTester tester) async {
      final cartProvider = CartProvider();

      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider.value(
            value: cartProvider,
            child: Builder(
              builder: (context) {
                final cart = Provider.of<CartProvider>(context);

                return Scaffold(
                  body: Column(
                    children: [
                      Text('Restaurant: ${cart.restaurantName ?? "None"}'),
                      ElevatedButton(
                        onPressed: () {
                          cart.addItem(
                            menuItem: const MenuItemEntity(
                              id: 'item1',
                              restaurantId: 'rest1',
                              name: 'Burger',
                              description: 'Delicious',
                              imageUrl: 'url',
                              price: 25.0,
                              category: 'Fast Food',
                              rating: 4.5,
                              reviewCount: 100,
                              ingredients: [],
                            ),
                            restaurantId: 'rest1',
                            restaurantName: 'Restaurant 1',
                            restaurantDeliveryFee: 5.0,
                            isFreeDelivery: false,
                          );
                        },
                        child: const Text('Add from Restaurant 1'),
                      ),
                      Text(
                        cart.hasDifferentRestaurant('rest2')
                            ? 'Different Restaurant!'
                            : 'Same Restaurant',
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      );

      // Add item from restaurant 1
      await tester.tap(find.text('Add from Restaurant 1'));
      await tester.pumpAndSettle();

      expect(find.text('Restaurant: Restaurant 1'), findsOneWidget);
      expect(find.text('Different Restaurant!'), findsOneWidget);
    });

    testWidgets('Clearing cart should reset all values',
        (WidgetTester tester) async {
      final cartProvider = CartProvider();

      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider.value(
            value: cartProvider,
            child: Builder(
              builder: (context) {
                final cart = Provider.of<CartProvider>(context);

                return Scaffold(
                  body: Column(
                    children: [
                      Text('Cart Items: ${cart.itemCount}'),
                      Text('Subtotal: ${cart.subtotal}'),
                      ElevatedButton(
                        onPressed: () {
                          cart.addItem(
                            menuItem: const MenuItemEntity(
                              id: 'item1',
                              restaurantId: 'rest1',
                              name: 'Burger',
                              description: 'Delicious',
                              imageUrl: 'url',
                              price: 25.0,
                              category: 'Fast Food',
                              rating: 4.5,
                              reviewCount: 100,
                              ingredients: [],
                            ),
                            restaurantId: 'rest1',
                            restaurantName: 'Restaurant 1',
                            restaurantDeliveryFee: 5.0,
                            isFreeDelivery: false,
                          );
                        },
                        child: const Text('Add Item'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          cart.clearCart();
                        },
                        child: const Text('Clear Cart'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      );

      // Add item
      await tester.tap(find.text('Add Item'));
      await tester.pumpAndSettle();

      expect(find.text('Cart Items: 1'), findsOneWidget);
      expect(find.text('Subtotal: 25.0'), findsOneWidget);

      // Clear cart
      await tester.tap(find.text('Clear Cart'));
      await tester.pumpAndSettle();

      expect(find.text('Cart Items: 0'), findsOneWidget);
      expect(find.text('Subtotal: 0.0'), findsOneWidget);
    });

    testWidgets('Updating item quantity should recalculate totals',
        (WidgetTester tester) async {
      final cartProvider = CartProvider();

      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider.value(
            value: cartProvider,
            child: Builder(
              builder: (context) {
                final cart = Provider.of<CartProvider>(context);

                return Scaffold(
                  body: Column(
                    children: [
                      Text('Cart Items: ${cart.itemCount}'),
                      Text('Subtotal: ${cart.subtotal}'),
                      ElevatedButton(
                        onPressed: () {
                          cart.addItem(
                            menuItem: const MenuItemEntity(
                              id: 'item1',
                              restaurantId: 'rest1',
                              name: 'Burger',
                              description: 'Delicious',
                              imageUrl: 'url',
                              price: 20.0,
                              category: 'Fast Food',
                              rating: 4.5,
                              reviewCount: 100,
                              ingredients: [],
                            ),
                            restaurantId: 'rest1',
                            restaurantName: 'Restaurant 1',
                            restaurantDeliveryFee: 5.0,
                            isFreeDelivery: false,
                          );
                        },
                        child: const Text('Add Item'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          if (cart.items.isNotEmpty) {
                            cart.updateQuantity(0, 3);
                          }
                        },
                        child: const Text('Update to 3'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      );

      // Add item
      await tester.tap(find.text('Add Item'));
      await tester.pumpAndSettle();

      expect(find.text('Cart Items: 1'), findsOneWidget);
      expect(find.text('Subtotal: 20.0'), findsOneWidget);

      // Update quantity to 3
      await tester.tap(find.text('Update to 3'));
      await tester.pumpAndSettle();

      expect(find.text('Cart Items: 3'), findsOneWidget);
      expect(find.text('Subtotal: 60.0'), findsOneWidget);
    });

    testWidgets('Removing item should update cart',
        (WidgetTester tester) async {
      final cartProvider = CartProvider();

      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider.value(
            value: cartProvider,
            child: Builder(
              builder: (context) {
                final cart = Provider.of<CartProvider>(context);

                return Scaffold(
                  body: Column(
                    children: [
                      Text('Cart Items: ${cart.itemCount}'),
                      ElevatedButton(
                        onPressed: () {
                          cart.addItem(
                            menuItem: const MenuItemEntity(
                              id: 'item1',
                              restaurantId: 'rest1',
                              name: 'Burger',
                              description: 'Delicious',
                              imageUrl: 'url',
                              price: 25.0,
                              category: 'Fast Food',
                              rating: 4.5,
                              reviewCount: 100,
                              ingredients: [],
                            ),
                            restaurantId: 'rest1',
                            restaurantName: 'Restaurant 1',
                            restaurantDeliveryFee: 5.0,
                            isFreeDelivery: false,
                          );
                        },
                        child: const Text('Add Item'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          if (cart.items.isNotEmpty) {
                            cart.removeItem(0);
                          }
                        },
                        child: const Text('Remove Item'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      );

      // Add item
      await tester.tap(find.text('Add Item'));
      await tester.pumpAndSettle();

      expect(find.text('Cart Items: 1'), findsOneWidget);

      // Remove item
      await tester.tap(find.text('Remove Item'));
      await tester.pumpAndSettle();

      expect(find.text('Cart Items: 0'), findsOneWidget);
    });

    testWidgets('Cart calculations with tax and delivery fee should be correct',
        (WidgetTester tester) async {
      final cartProvider = CartProvider();

      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider.value(
            value: cartProvider,
            child: Builder(
              builder: (context) {
                final cart = Provider.of<CartProvider>(context);

                return Scaffold(
                  body: Column(
                    children: [
                      Text('Subtotal: ${cart.subtotal.toStringAsFixed(2)}'),
                      Text('Tax: ${cart.tax.toStringAsFixed(2)}'),
                      Text('Delivery: ${cart.deliveryFee.toStringAsFixed(2)}'),
                      Text('Total: ${cart.total.toStringAsFixed(2)}'),
                      ElevatedButton(
                        onPressed: () {
                          cart.addItem(
                            menuItem: const MenuItemEntity(
                              id: 'item1',
                              restaurantId: 'rest1',
                              name: 'Burger',
                              description: 'Delicious',
                              imageUrl: 'url',
                              price: 100.0,
                              category: 'Fast Food',
                              rating: 4.5,
                              reviewCount: 100,
                              ingredients: [],
                            ),
                            restaurantId: 'rest1',
                            restaurantName: 'Restaurant 1',
                            restaurantDeliveryFee: 10.0,
                            isFreeDelivery: false,
                          );
                        },
                        child: const Text('Add Item'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      );

      // Add item
      await tester.tap(find.text('Add Item'));
      await tester.pumpAndSettle();

      // Subtotal: 100, Tax: 15 (15%), Delivery: 10, Total: 125
      expect(find.text('Subtotal: 100.00'), findsOneWidget);
      expect(find.text('Tax: 15.00'), findsOneWidget);
      expect(find.text('Delivery: 10.00'), findsOneWidget);
      expect(find.text('Total: 125.00'), findsOneWidget);
    });
  });
}
