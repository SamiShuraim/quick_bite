/// Integration tests for restaurant selection and menu browsing
/// Tests the flow from restaurant list to menu item selection
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quick_bite/features/restaurant/domain/entities/restaurant_entity.dart';
import 'package:quick_bite/features/restaurant/domain/entities/menu_item_entity.dart';

// Helper widget for filtering test
class _FilterableRestaurantList extends StatefulWidget {
  final List<RestaurantEntity> allRestaurants;

  const _FilterableRestaurantList({required this.allRestaurants});

  @override
  State<_FilterableRestaurantList> createState() =>
      _FilterableRestaurantListState();
}

class _FilterableRestaurantListState extends State<_FilterableRestaurantList> {
  String selectedCategory = 'All';

  @override
  Widget build(BuildContext context) {
    final filteredRestaurants = selectedCategory == 'All'
        ? widget.allRestaurants
        : widget.allRestaurants
            .where((r) => r.categories.contains(selectedCategory))
            .toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Restaurants')),
      body: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      selectedCategory = 'All';
                    });
                  },
                  child: const Text('All'),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      selectedCategory = 'Fast Food';
                    });
                  },
                  child: const Text('Fast Food'),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      selectedCategory = 'Italian';
                    });
                  },
                  child: const Text('Italian'),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredRestaurants.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(filteredRestaurants[index].name),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// Helper widget for search test
class _SearchableRestaurantList extends StatefulWidget {
  final List<RestaurantEntity> allRestaurants;

  const _SearchableRestaurantList({required this.allRestaurants});

  @override
  State<_SearchableRestaurantList> createState() =>
      _SearchableRestaurantListState();
}

class _SearchableRestaurantListState
    extends State<_SearchableRestaurantList> {
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final filteredRestaurants = searchQuery.isEmpty
        ? widget.allRestaurants
        : widget.allRestaurants
            .where((r) =>
                r.name.toLowerCase().contains(searchQuery.toLowerCase()))
            .toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Restaurants')),
      body: Column(
        children: [
          TextField(
            decoration: const InputDecoration(
              hintText: 'Search restaurants',
            ),
            onChanged: (value) {
              setState(() {
                searchQuery = value;
              });
            },
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredRestaurants.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(filteredRestaurants[index].name),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

void main() {
  group('Restaurant Selection Flow Integration Tests', () {
    testWidgets('Selecting restaurant should navigate to menu',
        (WidgetTester tester) async {
      final restaurants = [
        const RestaurantEntity(
          id: 'rest1',
          name: 'Burger Palace',
          description: 'Best burgers in town',
          imageUrl: 'url',
          rating: 4.5,
          reviewCount: 100,
          deliveryTime: 30,
          deliveryFee: 5.0,
          categories: ['Fast Food'],
          address: '123 Main St',
          distance: 2.5,
        ),
        const RestaurantEntity(
          id: 'rest2',
          name: 'Pizza House',
          description: 'Authentic Italian pizza',
          imageUrl: 'url',
          rating: 4.8,
          reviewCount: 200,
          deliveryTime: 40,
          deliveryFee: 7.0,
          categories: ['Italian'],
          address: '456 Oak Ave',
          distance: 3.2,
        ),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            appBar: AppBar(title: const Text('Restaurants')),
            body: ListView.builder(
              itemCount: restaurants.length,
              itemBuilder: (context, index) {
                final restaurant = restaurants[index];
                return ListTile(
                  title: Text(restaurant.name),
                  subtitle: Text(restaurant.description),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => Scaffold(
                          appBar: AppBar(title: Text(restaurant.name)),
                          body: const Center(
                            child: Text('Menu Items'),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ),
      );

      // Verify restaurants are displayed
      expect(find.text('Burger Palace'), findsOneWidget);
      expect(find.text('Pizza House'), findsOneWidget);

      // Tap on first restaurant
      await tester.tap(find.text('Burger Palace'));
      await tester.pumpAndSettle();

      // Should navigate to menu screen
      expect(find.text('Menu Items'), findsOneWidget);
    });

    testWidgets('Filtering restaurants by category should work',
        (WidgetTester tester) async {
      final allRestaurants = [
        const RestaurantEntity(
          id: 'rest1',
          name: 'Burger Palace',
          description: 'Best burgers',
          imageUrl: 'url',
          rating: 4.5,
          reviewCount: 100,
          deliveryTime: 30,
          deliveryFee: 5.0,
          categories: ['Fast Food'],
          address: '123 Main St',
          distance: 2.5,
        ),
        const RestaurantEntity(
          id: 'rest2',
          name: 'Pizza House',
          description: 'Italian pizza',
          imageUrl: 'url',
          rating: 4.8,
          reviewCount: 200,
          deliveryTime: 40,
          deliveryFee: 7.0,
          categories: ['Italian'],
          address: '456 Oak Ave',
          distance: 3.2,
        ),
        const RestaurantEntity(
          id: 'rest3',
          name: 'Sushi Bar',
          description: 'Fresh sushi',
          imageUrl: 'url',
          rating: 4.7,
          reviewCount: 150,
          deliveryTime: 35,
          deliveryFee: 6.0,
          categories: ['Japanese'],
          address: '789 Pine St',
          distance: 4.0,
        ),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: _FilterableRestaurantList(allRestaurants: allRestaurants),
        ),
      );

      // Initially all restaurants visible
      expect(find.text('Burger Palace'), findsOneWidget);
      expect(find.text('Pizza House'), findsOneWidget);
      expect(find.text('Sushi Bar'), findsOneWidget);

      // Filter by Fast Food
      await tester.tap(find.text('Fast Food'));
      await tester.pumpAndSettle();

      expect(find.text('Burger Palace'), findsOneWidget);
      expect(find.text('Pizza House'), findsNothing);
      expect(find.text('Sushi Bar'), findsNothing);
    });

    testWidgets('Filtering back to All should show all restaurants',
        (WidgetTester tester) async {
      final allRestaurants = [
        const RestaurantEntity(
          id: 'rest1',
          name: 'Burger Palace',
          description: 'Best burgers',
          imageUrl: 'url',
          rating: 4.5,
          reviewCount: 100,
          deliveryTime: 30,
          deliveryFee: 5.0,
          categories: ['Fast Food'],
          address: '123 Main St',
          distance: 2.5,
        ),
        const RestaurantEntity(
          id: 'rest2',
          name: 'Pizza House',
          description: 'Italian pizza',
          imageUrl: 'url',
          rating: 4.8,
          reviewCount: 200,
          deliveryTime: 40,
          deliveryFee: 7.0,
          categories: ['Italian'],
          address: '456 Oak Ave',
          distance: 3.2,
        ),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: _FilterableRestaurantList(allRestaurants: allRestaurants),
        ),
      );

      // Filter by Fast Food
      await tester.tap(find.text('Fast Food'));
      await tester.pumpAndSettle();

      expect(find.text('Burger Palace'), findsOneWidget);
      expect(find.text('Pizza House'), findsNothing);

      // Filter back to All
      await tester.tap(find.text('All'));
      await tester.pumpAndSettle();

      expect(find.text('Burger Palace'), findsOneWidget);
      expect(find.text('Pizza House'), findsOneWidget);
    });

    testWidgets('Menu item selection should show details',
        (WidgetTester tester) async {
      final menuItems = [
        const MenuItemEntity(
          id: 'item1',
          restaurantId: 'rest1',
          name: 'Classic Burger',
          description: 'Beef patty with cheese',
          imageUrl: 'url',
          price: 25.0,
          category: 'Burgers',
          rating: 4.5,
          reviewCount: 100,
          ingredients: ['beef', 'cheese', 'lettuce'],
        ),
        const MenuItemEntity(
          id: 'item2',
          restaurantId: 'rest1',
          name: 'Chicken Burger',
          description: 'Grilled chicken',
          imageUrl: 'url',
          price: 22.0,
          category: 'Burgers',
          rating: 4.3,
          reviewCount: 80,
          ingredients: ['chicken', 'lettuce'],
        ),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            appBar: AppBar(title: const Text('Menu')),
            body: ListView.builder(
              itemCount: menuItems.length,
              itemBuilder: (context, index) {
                final item = menuItems[index];
                return ListTile(
                  title: Text(item.name),
                  subtitle: Text('SAR ${item.price.toStringAsFixed(2)}'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => Scaffold(
                          appBar: AppBar(title: Text(item.name)),
                          body: Column(
                            children: [
                              Text('Description: ${item.description}'),
                              Text('Price: SAR ${item.price.toStringAsFixed(2)}'),
                              Text('Rating: ${item.rating}'),
                              const ElevatedButton(
                                onPressed: null,
                                child: Text('Add to Cart'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ),
      );

      // Verify menu items are displayed
      expect(find.text('Classic Burger'), findsOneWidget);
      expect(find.text('Chicken Burger'), findsOneWidget);

      // Tap on first item
      await tester.tap(find.text('Classic Burger'));
      await tester.pumpAndSettle();

      // Should show item details
      expect(find.text('Description: Beef patty with cheese'), findsOneWidget);
      expect(find.text('Price: SAR 25.00'), findsOneWidget);
      expect(find.text('Rating: 4.5'), findsOneWidget);
      expect(find.text('Add to Cart'), findsOneWidget);
    });

    testWidgets('Searching restaurants should filter results',
        (WidgetTester tester) async {
      final allRestaurants = [
        const RestaurantEntity(
          id: 'rest1',
          name: 'Burger Palace',
          description: 'Best burgers',
          imageUrl: 'url',
          rating: 4.5,
          reviewCount: 100,
          deliveryTime: 30,
          deliveryFee: 5.0,
          categories: ['Fast Food'],
          address: '123 Main St',
          distance: 2.5,
        ),
        const RestaurantEntity(
          id: 'rest2',
          name: 'Pizza House',
          description: 'Italian pizza',
          imageUrl: 'url',
          rating: 4.8,
          reviewCount: 200,
          deliveryTime: 40,
          deliveryFee: 7.0,
          categories: ['Italian'],
          address: '456 Oak Ave',
          distance: 3.2,
        ),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: _SearchableRestaurantList(allRestaurants: allRestaurants),
        ),
      );

      // Initially all restaurants visible
      expect(find.text('Burger Palace'), findsOneWidget);
      expect(find.text('Pizza House'), findsOneWidget);

      // Search for "burger"
      await tester.enterText(
          find.byType(TextField), 'burger');
      await tester.pumpAndSettle();

      expect(find.text('Burger Palace'), findsOneWidget);
      expect(find.text('Pizza House'), findsNothing);
    });

    testWidgets('Clearing search should show all restaurants',
        (WidgetTester tester) async {
      final allRestaurants = [
        const RestaurantEntity(
          id: 'rest1',
          name: 'Burger Palace',
          description: 'Best burgers',
          imageUrl: 'url',
          rating: 4.5,
          reviewCount: 100,
          deliveryTime: 30,
          deliveryFee: 5.0,
          categories: ['Fast Food'],
          address: '123 Main St',
          distance: 2.5,
        ),
        const RestaurantEntity(
          id: 'rest2',
          name: 'Pizza House',
          description: 'Italian pizza',
          imageUrl: 'url',
          rating: 4.8,
          reviewCount: 200,
          deliveryTime: 40,
          deliveryFee: 7.0,
          categories: ['Italian'],
          address: '456 Oak Ave',
          distance: 3.2,
        ),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: _SearchableRestaurantList(allRestaurants: allRestaurants),
        ),
      );

      // Search for "burger"
      await tester.enterText(find.byType(TextField), 'burger');
      await tester.pumpAndSettle();

      expect(find.text('Burger Palace'), findsOneWidget);
      expect(find.text('Pizza House'), findsNothing);

      // Clear search
      await tester.enterText(find.byType(TextField), '');
      await tester.pumpAndSettle();

      expect(find.text('Burger Palace'), findsOneWidget);
      expect(find.text('Pizza House'), findsOneWidget);
    });

    testWidgets('Case insensitive search should work',
        (WidgetTester tester) async {
      final allRestaurants = [
        const RestaurantEntity(
          id: 'rest1',
          name: 'Burger Palace',
          description: 'Best burgers',
          imageUrl: 'url',
          rating: 4.5,
          reviewCount: 100,
          deliveryTime: 30,
          deliveryFee: 5.0,
          categories: ['Fast Food'],
          address: '123 Main St',
          distance: 2.5,
        ),
        const RestaurantEntity(
          id: 'rest2',
          name: 'Pizza House',
          description: 'Italian pizza',
          imageUrl: 'url',
          rating: 4.8,
          reviewCount: 200,
          deliveryTime: 40,
          deliveryFee: 7.0,
          categories: ['Italian'],
          address: '456 Oak Ave',
          distance: 3.2,
        ),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: _SearchableRestaurantList(allRestaurants: allRestaurants),
        ),
      );

      // Search with uppercase
      await tester.enterText(find.byType(TextField), 'PIZZA');
      await tester.pumpAndSettle();

      expect(find.text('Pizza House'), findsOneWidget);
      expect(find.text('Burger Palace'), findsNothing);
    });

    testWidgets('No results should show empty list',
        (WidgetTester tester) async {
      final allRestaurants = [
        const RestaurantEntity(
          id: 'rest1',
          name: 'Burger Palace',
          description: 'Best burgers',
          imageUrl: 'url',
          rating: 4.5,
          reviewCount: 100,
          deliveryTime: 30,
          deliveryFee: 5.0,
          categories: ['Fast Food'],
          address: '123 Main St',
          distance: 2.5,
        ),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: _SearchableRestaurantList(allRestaurants: allRestaurants),
        ),
      );

      // Search for non-existent restaurant
      await tester.enterText(find.byType(TextField), 'Sushi');
      await tester.pumpAndSettle();

      expect(find.text('Burger Palace'), findsNothing);
    });
  });
}
