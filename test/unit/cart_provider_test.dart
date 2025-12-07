/// Unit tests for CartProvider
/// Tests cart operations, calculations, and state management
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:quick_bite/features/restaurant/presentation/providers/cart_provider.dart';
import 'package:quick_bite/features/restaurant/domain/entities/cart_entity.dart';
import 'package:quick_bite/features/restaurant/domain/entities/menu_item_entity.dart';

void main() {
  group('CartProvider Unit Tests', () {
    late CartProvider cartProvider;

    setUp(() {
      cartProvider = CartProvider();
    });

    test('Initial cart state should be empty', () {
      expect(cartProvider.items, isEmpty);
      expect(cartProvider.itemCount, 0);
      expect(cartProvider.isEmpty, true);
      expect(cartProvider.subtotal, 0.0);
      expect(cartProvider.total, 0.0);
      expect(cartProvider.restaurantId, isNull);
    });

    test('Adding item should update cart state', () {
      final menuItem = MenuItemEntity(
        id: '1',
        restaurantId: 'rest1',
        name: 'Burger',
        description: 'Delicious burger',
        imageUrl: 'url',
        price: 25.0,
        category: 'Fast Food',
        rating: 4.5,
        reviewCount: 100,
        ingredients: ['beef', 'lettuce'],
      );

      cartProvider.addItem(
        menuItem: menuItem,
        restaurantId: 'rest1',
        restaurantName: 'Test Restaurant',
        restaurantDeliveryFee: 5.0,
        isFreeDelivery: false,
      );

      expect(cartProvider.items.length, 1);
      expect(cartProvider.itemCount, 1);
      expect(cartProvider.isEmpty, false);
      expect(cartProvider.restaurantId, 'rest1');
      expect(cartProvider.restaurantName, 'Test Restaurant');
    });

    test('Subtotal should be calculated correctly', () {
      final menuItem1 = MenuItemEntity(
        id: '1',
        restaurantId: 'rest1',
        name: 'Burger',
        description: 'Delicious burger',
        imageUrl: 'url',
        price: 25.0,
        category: 'Fast Food',
        rating: 4.5,
        reviewCount: 100,
        ingredients: ['beef'],
      );

      final menuItem2 = MenuItemEntity(
        id: '2',
        restaurantId: 'rest1',
        name: 'Pizza',
        description: 'Tasty pizza',
        imageUrl: 'url',
        price: 35.0,
        category: 'Italian',
        rating: 4.8,
        reviewCount: 150,
        ingredients: ['cheese'],
      );

      cartProvider.addItem(
        menuItem: menuItem1,
        restaurantId: 'rest1',
        restaurantName: 'Test Restaurant',
        restaurantDeliveryFee: 5.0,
        isFreeDelivery: false,
      );

      cartProvider.addItem(
        menuItem: menuItem2,
        restaurantId: 'rest1',
        restaurantName: 'Test Restaurant',
        restaurantDeliveryFee: 5.0,
        isFreeDelivery: false,
      );

      expect(cartProvider.subtotal, 60.0);
    });

    test('Tax should be calculated correctly (15%)', () {
      final menuItem = MenuItemEntity(
        id: '1',
        restaurantId: 'rest1',
        name: 'Burger',
        description: 'Delicious burger',
        imageUrl: 'url',
        price: 100.0,
        category: 'Fast Food',
        rating: 4.5,
        reviewCount: 100,
        ingredients: ['beef'],
      );

      cartProvider.addItem(
        menuItem: menuItem,
        restaurantId: 'rest1',
        restaurantName: 'Test Restaurant',
        restaurantDeliveryFee: 10.0,
        isFreeDelivery: false,
      );

      expect(cartProvider.tax, 15.0); // 15% of 100
    });

    test('Delivery fee should be applied correctly', () {
      final menuItem = MenuItemEntity(
        id: '1',
        restaurantId: 'rest1',
        name: 'Burger',
        description: 'Delicious burger',
        imageUrl: 'url',
        price: 50.0,
        category: 'Fast Food',
        rating: 4.5,
        reviewCount: 100,
        ingredients: ['beef'],
      );

      cartProvider.addItem(
        menuItem: menuItem,
        restaurantId: 'rest1',
        restaurantName: 'Test Restaurant',
        restaurantDeliveryFee: 10.0,
        isFreeDelivery: false,
      );

      expect(cartProvider.deliveryFee, 10.0);
    });

    test('Free delivery should have zero delivery fee', () {
      final menuItem = MenuItemEntity(
        id: '1',
        restaurantId: 'rest1',
        name: 'Burger',
        description: 'Delicious burger',
        imageUrl: 'url',
        price: 50.0,
        category: 'Fast Food',
        rating: 4.5,
        reviewCount: 100,
        ingredients: ['beef'],
      );

      cartProvider.addItem(
        menuItem: menuItem,
        restaurantId: 'rest1',
        restaurantName: 'Test Restaurant',
        restaurantDeliveryFee: 10.0,
        isFreeDelivery: true,
      );

      expect(cartProvider.deliveryFee, 0.0);
    });

    test('Total should include subtotal, tax, and delivery fee', () {
      final menuItem = MenuItemEntity(
        id: '1',
        restaurantId: 'rest1',
        name: 'Burger',
        description: 'Delicious burger',
        imageUrl: 'url',
        price: 100.0,
        category: 'Fast Food',
        rating: 4.5,
        reviewCount: 100,
        ingredients: ['beef'],
      );

      cartProvider.addItem(
        menuItem: menuItem,
        restaurantId: 'rest1',
        restaurantName: 'Test Restaurant',
        restaurantDeliveryFee: 10.0,
        isFreeDelivery: false,
      );

      // Subtotal: 100, Tax: 15, Delivery: 10 = Total: 125
      expect(cartProvider.total, 125.0);
    });

    test('Adding same item should increase quantity', () {
      final menuItem = MenuItemEntity(
        id: '1',
        restaurantId: 'rest1',
        name: 'Burger',
        description: 'Delicious burger',
        imageUrl: 'url',
        price: 25.0,
        category: 'Fast Food',
        rating: 4.5,
        reviewCount: 100,
        ingredients: ['beef'],
      );

      cartProvider.addItem(
        menuItem: menuItem,
        restaurantId: 'rest1',
        restaurantName: 'Test Restaurant',
        restaurantDeliveryFee: 5.0,
        isFreeDelivery: false,
      );

      cartProvider.addItem(
        menuItem: menuItem,
        restaurantId: 'rest1',
        restaurantName: 'Test Restaurant',
        restaurantDeliveryFee: 5.0,
        isFreeDelivery: false,
      );

      expect(cartProvider.items.length, 1);
      expect(cartProvider.items[0].quantity, 2);
      expect(cartProvider.itemCount, 2);
    });

    test('Removing item should update cart', () {
      final menuItem = MenuItemEntity(
        id: '1',
        restaurantId: 'rest1',
        name: 'Burger',
        description: 'Delicious burger',
        imageUrl: 'url',
        price: 25.0,
        category: 'Fast Food',
        rating: 4.5,
        reviewCount: 100,
        ingredients: ['beef'],
      );

      cartProvider.addItem(
        menuItem: menuItem,
        restaurantId: 'rest1',
        restaurantName: 'Test Restaurant',
        restaurantDeliveryFee: 5.0,
        isFreeDelivery: false,
      );

      expect(cartProvider.items.length, 1);

      cartProvider.removeItem(0);

      expect(cartProvider.items.length, 0);
      expect(cartProvider.isEmpty, true);
    });

    test('Updating quantity should update item price', () {
      final menuItem = MenuItemEntity(
        id: '1',
        restaurantId: 'rest1',
        name: 'Burger',
        description: 'Delicious burger',
        imageUrl: 'url',
        price: 25.0,
        category: 'Fast Food',
        rating: 4.5,
        reviewCount: 100,
        ingredients: ['beef'],
      );

      cartProvider.addItem(
        menuItem: menuItem,
        restaurantId: 'rest1',
        restaurantName: 'Test Restaurant',
        restaurantDeliveryFee: 5.0,
        isFreeDelivery: false,
      );

      cartProvider.updateQuantity(0, 3);

      expect(cartProvider.items[0].quantity, 3);
      expect(cartProvider.items[0].totalPrice, 75.0);
      expect(cartProvider.itemCount, 3);
    });

    test('Updating quantity to zero should remove item', () {
      final menuItem = MenuItemEntity(
        id: '1',
        restaurantId: 'rest1',
        name: 'Burger',
        description: 'Delicious burger',
        imageUrl: 'url',
        price: 25.0,
        category: 'Fast Food',
        rating: 4.5,
        reviewCount: 100,
        ingredients: ['beef'],
      );

      cartProvider.addItem(
        menuItem: menuItem,
        restaurantId: 'rest1',
        restaurantName: 'Test Restaurant',
        restaurantDeliveryFee: 5.0,
        isFreeDelivery: false,
      );

      cartProvider.updateQuantity(0, 0);

      expect(cartProvider.items.length, 0);
    });

    test('Clearing cart should reset all state', () {
      final menuItem = MenuItemEntity(
        id: '1',
        restaurantId: 'rest1',
        name: 'Burger',
        description: 'Delicious burger',
        imageUrl: 'url',
        price: 25.0,
        category: 'Fast Food',
        rating: 4.5,
        reviewCount: 100,
        ingredients: ['beef'],
      );

      cartProvider.addItem(
        menuItem: menuItem,
        restaurantId: 'rest1',
        restaurantName: 'Test Restaurant',
        restaurantDeliveryFee: 5.0,
        isFreeDelivery: false,
      );

      cartProvider.clearCart();

      expect(cartProvider.items, isEmpty);
      expect(cartProvider.restaurantId, isNull);
      expect(cartProvider.restaurantName, isNull);
      expect(cartProvider.subtotal, 0.0);
    });

    test('hasDifferentRestaurant should return true for different restaurant', () {
      final menuItem = MenuItemEntity(
        id: '1',
        restaurantId: 'rest1',
        name: 'Burger',
        description: 'Delicious burger',
        imageUrl: 'url',
        price: 25.0,
        category: 'Fast Food',
        rating: 4.5,
        reviewCount: 100,
        ingredients: ['beef'],
      );

      cartProvider.addItem(
        menuItem: menuItem,
        restaurantId: 'rest1',
        restaurantName: 'Test Restaurant',
        restaurantDeliveryFee: 5.0,
        isFreeDelivery: false,
      );

      expect(cartProvider.hasDifferentRestaurant('rest2'), true);
      expect(cartProvider.hasDifferentRestaurant('rest1'), false);
    });

    test('Adding item with customizations should increase price', () {
      final menuItem = MenuItemEntity(
        id: '1',
        restaurantId: 'rest1',
        name: 'Burger',
        description: 'Delicious burger',
        imageUrl: 'url',
        price: 25.0,
        category: 'Fast Food',
        rating: 4.5,
        reviewCount: 100,
        ingredients: ['beef'],
      );

      final customizations = [
        SelectedCustomization(
          optionId: 'option1',
          optionName: 'Extra Cheese',
          selectedChoices: [
            CustomizationChoice(
              id: 'cheese1',
              name: 'Cheddar',
              additionalPrice: 5.0,
            ),
          ],
        ),
      ];

      cartProvider.addItem(
        menuItem: menuItem,
        restaurantId: 'rest1',
        restaurantName: 'Test Restaurant',
        restaurantDeliveryFee: 5.0,
        isFreeDelivery: false,
        customizations: customizations,
      );

      expect(cartProvider.items[0].totalPrice, 30.0); // 25 + 5
    });

    test('clearExisting flag should remove items from different restaurant', () {
      final menuItem1 = MenuItemEntity(
        id: '1',
        restaurantId: 'rest1',
        name: 'Burger',
        description: 'Delicious burger',
        imageUrl: 'url',
        price: 25.0,
        category: 'Fast Food',
        rating: 4.5,
        reviewCount: 100,
        ingredients: ['beef'],
      );

      final menuItem2 = MenuItemEntity(
        id: '2',
        restaurantId: 'rest2',
        name: 'Pizza',
        description: 'Tasty pizza',
        imageUrl: 'url',
        price: 35.0,
        category: 'Italian',
        rating: 4.8,
        reviewCount: 150,
        ingredients: ['cheese'],
      );

      cartProvider.addItem(
        menuItem: menuItem1,
        restaurantId: 'rest1',
        restaurantName: 'Restaurant 1',
        restaurantDeliveryFee: 5.0,
        isFreeDelivery: false,
      );

      expect(cartProvider.restaurantId, 'rest1');
      expect(cartProvider.items.length, 1);

      cartProvider.addItem(
        menuItem: menuItem2,
        restaurantId: 'rest2',
        restaurantName: 'Restaurant 2',
        restaurantDeliveryFee: 7.0,
        isFreeDelivery: false,
        clearExisting: true,
      );

      expect(cartProvider.restaurantId, 'rest2');
      expect(cartProvider.items.length, 1);
      expect(cartProvider.items[0].menuItem.id, '2');
    });
  });
}
