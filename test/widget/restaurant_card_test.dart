/// Widget tests for RestaurantCard
/// Tests restaurant card display and interactions
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quick_bite/features/restaurant/presentation/widgets/restaurant_card.dart';
import 'package:quick_bite/features/restaurant/domain/entities/restaurant_entity.dart';

void main() {
  group('RestaurantCard Widget Tests', () {
    late RestaurantEntity testRestaurant;

    setUp(() {
      testRestaurant = const RestaurantEntity(
        id: 'rest1',
        name: 'Test Restaurant',
        description: 'A delicious test restaurant',
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
    });

    testWidgets('RestaurantCard should display restaurant name',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RestaurantCard(
              restaurant: testRestaurant,
              onTap: () {},
            ),
          ),
        ),
      );

      expect(find.text('Test Restaurant'), findsOneWidget);
    });

    testWidgets('RestaurantCard should display restaurant description',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RestaurantCard(
              restaurant: testRestaurant,
              onTap: () {},
            ),
          ),
        ),
      );

      expect(find.text('A delicious test restaurant'), findsOneWidget);
    });

    testWidgets('RestaurantCard should display rating',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RestaurantCard(
              restaurant: testRestaurant,
              onTap: () {},
            ),
          ),
        ),
      );

      expect(find.text('4.5'), findsOneWidget);
      expect(find.text(' (100)'), findsOneWidget);
      expect(find.byIcon(Icons.star), findsOneWidget);
    });

    testWidgets('RestaurantCard should display delivery time',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RestaurantCard(
              restaurant: testRestaurant,
              onTap: () {},
            ),
          ),
        ),
      );

      expect(find.text('30 min'), findsOneWidget);
      expect(find.byIcon(Icons.access_time), findsOneWidget);
    });

    testWidgets('RestaurantCard should display distance',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RestaurantCard(
              restaurant: testRestaurant,
              onTap: () {},
            ),
          ),
        ),
      );

      expect(find.text('2.5 km'), findsOneWidget);
      expect(find.byIcon(Icons.location_on_outlined), findsOneWidget);
    });

    testWidgets('RestaurantCard should show Popular badge when isPopular is true',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RestaurantCard(
              restaurant: testRestaurant,
              onTap: () {},
            ),
          ),
        ),
      );

      expect(find.text('Popular'), findsOneWidget);
    });

    testWidgets('RestaurantCard should not show Popular badge when isPopular is false',
        (WidgetTester tester) async {
      final restaurant = testRestaurant.copyWith(isPopular: false);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RestaurantCard(
              restaurant: restaurant,
              onTap: () {},
            ),
          ),
        ),
      );

      expect(find.text('Popular'), findsNothing);
    });

    testWidgets('RestaurantCard should show Free delivery badge when isFreeDelivery is true',
        (WidgetTester tester) async {
      final restaurant = testRestaurant.copyWith(isFreeDelivery: true);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RestaurantCard(
              restaurant: restaurant,
              onTap: () {},
            ),
          ),
        ),
      );

      expect(find.text('Free'), findsOneWidget);
      expect(find.byIcon(Icons.delivery_dining), findsOneWidget);
    });

    testWidgets('RestaurantCard should not show Free delivery badge when isFreeDelivery is false',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RestaurantCard(
              restaurant: testRestaurant,
              onTap: () {},
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.delivery_dining), findsNothing);
    });

    testWidgets('RestaurantCard should be tappable', (WidgetTester tester) async {
      var tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RestaurantCard(
              restaurant: testRestaurant,
              onTap: () {
                tapped = true;
              },
            ),
          ),
        ),
      );

      await tester.tap(find.byType(RestaurantCard));
      await tester.pump();

      expect(tapped, true);
    });

    testWidgets('RestaurantCard should handle image loading errors',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RestaurantCard(
              restaurant: testRestaurant,
              onTap: () {},
            ),
          ),
        ),
      );

      // Wait for image to attempt to load and fail
      await tester.pump();

      // Should show fallback icon
      expect(find.byIcon(Icons.restaurant), findsOneWidget);
    });
  });
}

// Extension for testing
extension RestaurantEntityCopyWith on RestaurantEntity {
  RestaurantEntity copyWith({
    bool? isPopular,
    bool? isFreeDelivery,
  }) {
    return RestaurantEntity(
      id: id,
      name: name,
      description: description,
      imageUrl: imageUrl,
      rating: rating,
      reviewCount: reviewCount,
      deliveryTime: deliveryTime,
      deliveryFee: deliveryFee,
      categories: categories,
      isFreeDelivery: isFreeDelivery ?? this.isFreeDelivery,
      isPopular: isPopular ?? this.isPopular,
      hasVegetarianOptions: hasVegetarianOptions,
      address: address,
      distance: distance,
    );
  }
}
