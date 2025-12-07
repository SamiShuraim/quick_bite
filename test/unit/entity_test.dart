/// Unit tests for domain entities
/// Tests entity creation, equality, and copyWith methods
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:quick_bite/features/authentication/domain/entities/user_entity.dart';
import 'package:quick_bite/features/restaurant/domain/entities/restaurant_entity.dart';
import 'package:quick_bite/features/restaurant/domain/entities/menu_item_entity.dart';
import 'package:quick_bite/features/restaurant/domain/entities/cart_entity.dart';

void main() {
  group('UserEntity Tests', () {
    test('UserEntity should be created with all properties', () {
      final user = UserEntity(
        id: '123',
        email: 'test@example.com',
        name: 'Test User',
        phone: '+966501234567',
        role: 'customer',
        isEmailVerified: true,
        createdAt: DateTime(2024, 1, 1),
      );

      expect(user.id, '123');
      expect(user.email, 'test@example.com');
      expect(user.name, 'Test User');
      expect(user.phone, '+966501234567');
      expect(user.role, 'customer');
      expect(user.isEmailVerified, true);
    });

    test('UserEntity copyWith should update only specified fields', () {
      final user = UserEntity(
        id: '123',
        email: 'test@example.com',
        name: 'Test User',
        role: 'customer',
        isEmailVerified: false,
      );

      final updatedUser = user.copyWith(
        name: 'Updated User',
        isEmailVerified: true,
      );

      expect(updatedUser.id, '123');
      expect(updatedUser.email, 'test@example.com');
      expect(updatedUser.name, 'Updated User');
      expect(updatedUser.isEmailVerified, true);
    });

    test('UserEntity equality should work correctly', () {
      final user1 = UserEntity(
        id: '123',
        email: 'test@example.com',
        name: 'Test User',
        role: 'customer',
        isEmailVerified: true,
      );

      final user2 = UserEntity(
        id: '123',
        email: 'test@example.com',
        name: 'Test User',
        role: 'customer',
        isEmailVerified: true,
      );

      final user3 = UserEntity(
        id: '456',
        email: 'other@example.com',
        name: 'Other User',
        role: 'customer',
        isEmailVerified: true,
      );

      expect(user1, equals(user2));
      expect(user1, isNot(equals(user3)));
    });
  });

  group('RestaurantEntity Tests', () {
    test('RestaurantEntity should be created with all properties', () {
      final restaurant = RestaurantEntity(
        id: 'rest1',
        name: 'Test Restaurant',
        description: 'A test restaurant',
        imageUrl: 'https://example.com/image.jpg',
        rating: 4.5,
        reviewCount: 100,
        deliveryTime: 30,
        deliveryFee: 5.0,
        categories: ['Fast Food', 'Burgers'],
        isFreeDelivery: false,
        isPopular: true,
        hasVegetarianOptions: true,
        address: '123 Test St',
        distance: 2.5,
      );

      expect(restaurant.id, 'rest1');
      expect(restaurant.name, 'Test Restaurant');
      expect(restaurant.rating, 4.5);
      expect(restaurant.deliveryTime, 30);
      expect(restaurant.deliveryFee, 5.0);
      expect(restaurant.categories, contains('Fast Food'));
      expect(restaurant.isPopular, true);
    });

    test('RestaurantEntity with free delivery should have isFreeDelivery true', () {
      final restaurant = RestaurantEntity(
        id: 'rest1',
        name: 'Test Restaurant',
        description: 'A test restaurant',
        imageUrl: 'https://example.com/image.jpg',
        rating: 4.5,
        reviewCount: 100,
        deliveryTime: 30,
        deliveryFee: 0.0,
        categories: ['Fast Food'],
        isFreeDelivery: true,
        address: '123 Test St',
        distance: 2.5,
      );

      expect(restaurant.isFreeDelivery, true);
      expect(restaurant.deliveryFee, 0.0);
    });

    test('RestaurantEntity equality should work correctly', () {
      final restaurant1 = RestaurantEntity(
        id: 'rest1',
        name: 'Test Restaurant',
        description: 'A test restaurant',
        imageUrl: 'https://example.com/image.jpg',
        rating: 4.5,
        reviewCount: 100,
        deliveryTime: 30,
        deliveryFee: 5.0,
        categories: ['Fast Food'],
        address: '123 Test St',
        distance: 2.5,
      );

      final restaurant2 = RestaurantEntity(
        id: 'rest1',
        name: 'Test Restaurant',
        description: 'A test restaurant',
        imageUrl: 'https://example.com/image.jpg',
        rating: 4.5,
        reviewCount: 100,
        deliveryTime: 30,
        deliveryFee: 5.0,
        categories: ['Fast Food'],
        address: '123 Test St',
        distance: 2.5,
      );

      expect(restaurant1, equals(restaurant2));
    });
  });

  group('MenuItemEntity Tests', () {
    test('MenuItemEntity should be created with basic properties', () {
      final menuItem = MenuItemEntity(
        id: 'item1',
        restaurantId: 'rest1',
        name: 'Burger',
        description: 'Delicious burger',
        imageUrl: 'https://example.com/burger.jpg',
        price: 25.0,
        category: 'Fast Food',
        rating: 4.5,
        reviewCount: 50,
        ingredients: ['beef', 'lettuce', 'tomato'],
      );

      expect(menuItem.id, 'item1');
      expect(menuItem.name, 'Burger');
      expect(menuItem.price, 25.0);
      expect(menuItem.ingredients.length, 3);
      expect(menuItem.isVegetarian, false);
    });

    test('MenuItemEntity with customizations should store them correctly', () {
      final customizations = [
        CustomizationOption(
          id: 'opt1',
          name: 'Size',
          choices: [
            CustomizationChoice(id: 'small', name: 'Small', additionalPrice: 0),
            CustomizationChoice(id: 'large', name: 'Large', additionalPrice: 5.0),
          ],
          isRequired: true,
        ),
      ];

      final menuItem = MenuItemEntity(
        id: 'item1',
        restaurantId: 'rest1',
        name: 'Pizza',
        description: 'Delicious pizza',
        imageUrl: 'https://example.com/pizza.jpg',
        price: 35.0,
        category: 'Italian',
        rating: 4.8,
        reviewCount: 100,
        ingredients: ['cheese', 'tomato sauce'],
        customizations: customizations,
      );

      expect(menuItem.customizations.length, 1);
      expect(menuItem.customizations[0].choices.length, 2);
      expect(menuItem.customizations[0].isRequired, true);
    });

    test('CustomizationChoice should have additional price', () {
      final choice = CustomizationChoice(
        id: 'extra_cheese',
        name: 'Extra Cheese',
        additionalPrice: 5.0,
      );

      expect(choice.additionalPrice, 5.0);
    });
  });

  group('CartEntity Tests', () {
    test('CartEntity should be created with items and calculations', () {
      final menuItem = MenuItemEntity(
        id: 'item1',
        restaurantId: 'rest1',
        name: 'Burger',
        description: 'Delicious burger',
        imageUrl: 'https://example.com/burger.jpg',
        price: 25.0,
        category: 'Fast Food',
        rating: 4.5,
        reviewCount: 50,
        ingredients: ['beef'],
      );

      final cartItem = CartItem(
        menuItem: menuItem,
        quantity: 2,
        totalPrice: 50.0,
      );

      final cart = CartEntity(
        items: [cartItem],
        subtotal: 50.0,
        deliveryFee: 5.0,
        tax: 7.5,
        total: 62.5,
      );

      expect(cart.items.length, 1);
      expect(cart.subtotal, 50.0);
      expect(cart.deliveryFee, 5.0);
      expect(cart.tax, 7.5);
      expect(cart.total, 62.5);
    });

    test('CartItem should store quantity and total price', () {
      final menuItem = MenuItemEntity(
        id: 'item1',
        restaurantId: 'rest1',
        name: 'Burger',
        description: 'Delicious burger',
        imageUrl: 'https://example.com/burger.jpg',
        price: 25.0,
        category: 'Fast Food',
        rating: 4.5,
        reviewCount: 50,
        ingredients: ['beef'],
      );

      final cartItem = CartItem(
        menuItem: menuItem,
        quantity: 3,
        totalPrice: 75.0,
      );

      expect(cartItem.quantity, 3);
      expect(cartItem.totalPrice, 75.0);
    });

    test('CartItem copyWith should update quantity and price', () {
      final menuItem = MenuItemEntity(
        id: 'item1',
        restaurantId: 'rest1',
        name: 'Burger',
        description: 'Delicious burger',
        imageUrl: 'https://example.com/burger.jpg',
        price: 25.0,
        category: 'Fast Food',
        rating: 4.5,
        reviewCount: 50,
        ingredients: ['beef'],
      );

      final cartItem = CartItem(
        menuItem: menuItem,
        quantity: 2,
        totalPrice: 50.0,
      );

      final updatedItem = cartItem.copyWith(
        quantity: 5,
        totalPrice: 125.0,
      );

      expect(updatedItem.quantity, 5);
      expect(updatedItem.totalPrice, 125.0);
      expect(updatedItem.menuItem.id, 'item1');
    });

    test('CartEntity copyWith should update cart values', () {
      final cart = CartEntity(
        items: [],
        subtotal: 50.0,
        deliveryFee: 5.0,
        tax: 7.5,
        total: 62.5,
      );

      final updatedCart = cart.copyWith(
        subtotal: 100.0,
        total: 115.0,
      );

      expect(updatedCart.subtotal, 100.0);
      expect(updatedCart.deliveryFee, 5.0);
      expect(updatedCart.total, 115.0);
    });
  });
}
