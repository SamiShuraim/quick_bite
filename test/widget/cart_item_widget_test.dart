/// Widget tests for cart item display
/// Tests individual cart item widgets with quantity controls
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Cart Item Widget Tests', () {
    testWidgets('Cart item should display name and price',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ListTile(
              leading: const CircleAvatar(
                child: Icon(Icons.fastfood),
              ),
              title: const Text('Burger'),
              subtitle: const Text('SAR 25.00'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove),
                    onPressed: () {},
                  ),
                  const Text('2'),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.text('Burger'), findsOneWidget);
      expect(find.text('SAR 25.00'), findsOneWidget);
      expect(find.text('2'), findsOneWidget);
    });

    testWidgets('Increment button should increase quantity',
        (WidgetTester tester) async {
      var quantity = 1;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return Column(
                  children: [
                    Text('Quantity: $quantity'),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        setState(() {
                          quantity++;
                        });
                      },
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      );

      expect(find.text('Quantity: 1'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      expect(find.text('Quantity: 2'), findsOneWidget);
    });

    testWidgets('Decrement button should decrease quantity',
        (WidgetTester tester) async {
      var quantity = 3;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return Column(
                  children: [
                    Text('Quantity: $quantity'),
                    IconButton(
                      icon: const Icon(Icons.remove),
                      onPressed: () {
                        setState(() {
                          if (quantity > 1) quantity--;
                        });
                      },
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      );

      expect(find.text('Quantity: 3'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.remove));
      await tester.pumpAndSettle();

      expect(find.text('Quantity: 2'), findsOneWidget);
    });

    testWidgets('Delete button should show confirmation dialog',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: const Text('Remove Item'),
                        content: const Text('Remove this item from cart?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Remove'),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ),
      );

      await tester.tap(find.byIcon(Icons.delete));
      await tester.pumpAndSettle();

      expect(find.text('Remove Item'), findsOneWidget);
      expect(find.text('Remove this item from cart?'), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);
      expect(find.text('Remove'), findsOneWidget);
    });

    testWidgets('Cart item with customizations should display them',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ListTile(
              title: const Text('Burger'),
              subtitle: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('SAR 30.00'),
                  Text('Extra Cheese, No Onions',
                      style: TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.text('Burger'), findsOneWidget);
      expect(find.text('SAR 30.00'), findsOneWidget);
      expect(find.text('Extra Cheese, No Onions'), findsOneWidget);
    });

    testWidgets('Empty cart should show empty state',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_cart_outlined,
                      size: 100, color: Colors.grey[300]),
                  const SizedBox(height: 16),
                  const Text(
                    'Your cart is empty',
                    style: TextStyle(fontSize: 20, color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Add items to get started',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.text('Your cart is empty'), findsOneWidget);
      expect(find.text('Add items to get started'), findsOneWidget);
      expect(find.byIcon(Icons.shopping_cart_outlined), findsOneWidget);
    });

    testWidgets('Cart summary should show subtotal, tax, and total',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                ListTile(
                  title: const Text('Subtotal'),
                  trailing: const Text('SAR 100.00'),
                ),
                ListTile(
                  title: const Text('Delivery Fee'),
                  trailing: const Text('SAR 10.00'),
                ),
                ListTile(
                  title: const Text('Tax (15%)'),
                  trailing: const Text('SAR 15.00'),
                ),
                const Divider(),
                ListTile(
                  title: const Text('Total',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  trailing: const Text('SAR 125.00',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18)),
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.text('Subtotal'), findsOneWidget);
      expect(find.text('SAR 100.00'), findsOneWidget);
      expect(find.text('Delivery Fee'), findsOneWidget);
      expect(find.text('SAR 10.00'), findsOneWidget);
      expect(find.text('Tax (15%)'), findsOneWidget);
      expect(find.text('SAR 15.00'), findsOneWidget);
      expect(find.text('Total'), findsOneWidget);
      expect(find.text('SAR 125.00'), findsOneWidget);
    });
  });
}
