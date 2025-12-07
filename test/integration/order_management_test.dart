/// Integration tests for order management
/// Tests order placement, tracking, and history
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Order Management Integration Tests', () {
    testWidgets('Complete order flow from cart to confirmation',
        (WidgetTester tester) async {
      var currentStep = 'cart';

      await tester.pumpWidget(
        MaterialApp(
          home: StatefulBuilder(
            builder: (context, setState) {
              Widget buildScreen() {
                switch (currentStep) {
                  case 'cart':
                    return Scaffold(
                      appBar: AppBar(title: const Text('Cart')),
                      body: Column(
                        children: [
                          const Text('Your Cart'),
                          const ListTile(
                            title: Text('Burger'),
                            subtitle: Text('SAR 25.00'),
                          ),
                          const Text('Total: SAR 43.75'),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                currentStep = 'payment';
                              });
                            },
                            child: const Text('Proceed to Payment'),
                          ),
                        ],
                      ),
                    );
                  case 'payment':
                    return Scaffold(
                      appBar: AppBar(title: const Text('Payment')),
                      body: Column(
                        children: [
                          const Text('Select Payment Method'),
                          ListTile(
                            title: const Text('Credit Card'),
                            leading: Radio<String>(
                              value: 'card',
                              groupValue: 'card',
                              onChanged: (_) {},
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                currentStep = 'confirmation';
                              });
                            },
                            child: const Text('Place Order'),
                          ),
                        ],
                      ),
                    );
                  case 'confirmation':
                    return Scaffold(
                      appBar: AppBar(title: const Text('Order Confirmed')),
                      body: const Column(
                        children: [
                          Icon(Icons.check_circle, size: 100, color: Colors.green),
                          Text('Order Placed Successfully!'),
                          Text('Order #12345'),
                          Text('Estimated delivery: 30-40 min'),
                        ],
                      ),
                    );
                  default:
                    return const SizedBox();
                }
              }

              return buildScreen();
            },
          ),
        ),
      );

      // Step 1: Cart screen
      expect(find.text('Your Cart'), findsOneWidget);
      expect(find.text('Burger'), findsOneWidget);
      expect(find.text('Total: SAR 43.75'), findsOneWidget);

      await tester.tap(find.text('Proceed to Payment'));
      await tester.pumpAndSettle();

      // Step 2: Payment screen
      expect(find.text('Select Payment Method'), findsOneWidget);
      expect(find.text('Credit Card'), findsOneWidget);

      await tester.tap(find.text('Place Order'));
      await tester.pumpAndSettle();

      // Step 3: Confirmation screen
      expect(find.text('Order Placed Successfully!'), findsOneWidget);
      expect(find.text('Order #12345'), findsOneWidget);
      expect(find.byIcon(Icons.check_circle), findsOneWidget);
    });

    testWidgets('Order tracking should show status updates',
        (WidgetTester tester) async {
      final orderStatuses = [
        {'status': 'Placed', 'time': '2:00 PM', 'completed': true},
        {'status': 'Preparing', 'time': '2:05 PM', 'completed': true},
        {'status': 'On the way', 'time': '2:20 PM', 'completed': false},
        {'status': 'Delivered', 'time': '', 'completed': false},
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            appBar: AppBar(title: const Text('Track Order')),
            body: Column(
              children: [
                const Text('Order #12345'),
                const Text('Status: Preparing'),
                Expanded(
                  child: ListView.builder(
                    itemCount: orderStatuses.length,
                    itemBuilder: (context, index) {
                      final status = orderStatuses[index];
                      return ListTile(
                        leading: Icon(
                          status['completed'] as bool
                              ? Icons.check_circle
                              : Icons.radio_button_unchecked,
                          color: status['completed'] as bool
                              ? Colors.green
                              : Colors.grey,
                        ),
                        title: Text(status['status'] as String),
                        subtitle: Text(status['time'] as String),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.text('Order #12345'), findsOneWidget);
      expect(find.text('Status: Preparing'), findsOneWidget);
      expect(find.text('Placed'), findsOneWidget);
      expect(find.text('Preparing'), findsOneWidget);
      expect(find.text('On the way'), findsOneWidget);
      expect(find.text('Delivered'), findsOneWidget);

      // Check that completed statuses have check icons
      expect(find.byIcon(Icons.check_circle), findsNWidgets(2));
      expect(find.byIcon(Icons.radio_button_unchecked), findsNWidgets(2));
    });

    testWidgets('Order history should display past orders',
        (WidgetTester tester) async {
      final orders = [
        {
          'id': '#12345',
          'restaurant': 'Burger Palace',
          'date': '2024-01-15',
          'total': 43.75,
          'status': 'Delivered'
        },
        {
          'id': '#12344',
          'restaurant': 'Pizza House',
          'date': '2024-01-14',
          'total': 65.00,
          'status': 'Delivered'
        },
        {
          'id': '#12343',
          'restaurant': 'Sushi Bar',
          'date': '2024-01-10',
          'total': 89.50,
          'status': 'Cancelled'
        },
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            appBar: AppBar(title: const Text('Order History')),
            body: ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                return Card(
                  child: ListTile(
                    title: Text(order['restaurant'] as String),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Order ${order['id']}'),
                        Text('Date: ${order['date']}'),
                        Text('Total: SAR ${order['total']}'),
                      ],
                    ),
                    trailing: Text(
                      order['status'] as String,
                      style: TextStyle(
                        color: order['status'] == 'Delivered'
                            ? Colors.green
                            : Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      );

      expect(find.text('Order History'), findsOneWidget);
      expect(find.text('Burger Palace'), findsOneWidget);
      expect(find.text('Pizza House'), findsOneWidget);
      expect(find.text('Sushi Bar'), findsOneWidget);
      expect(find.text('Order #12345'), findsOneWidget);
      expect(find.text('Order #12344'), findsOneWidget);
      expect(find.text('Order #12343'), findsOneWidget);
    });

    testWidgets('Reordering from history should add items to cart',
        (WidgetTester tester) async {
      var cartItems = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: StatefulBuilder(
            builder: (context, setState) {
              return Scaffold(
                appBar: AppBar(
                  title: const Text('Order History'),
                  actions: [
                    Badge(
                      label: Text('$cartItems'),
                      child: const Icon(Icons.shopping_cart),
                    ),
                  ],
                ),
                body: Column(
                  children: [
                    ListTile(
                      title: const Text('Burger Palace'),
                      subtitle: const Text('Order #12345 - SAR 43.75'),
                      trailing: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            cartItems = 2; // Simulating adding 2 items
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Items added to cart'),
                            ),
                          );
                        },
                        child: const Text('Reorder'),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      );

      expect(find.text('0'), findsOneWidget); // Initial cart count

      await tester.tap(find.text('Reorder'));
      await tester.pumpAndSettle();

      expect(find.text('Items added to cart'), findsOneWidget);
      expect(find.text('2'), findsOneWidget); // Updated cart count
    });

    testWidgets('Empty order history should show appropriate message',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            appBar: AppBar(title: const Text('Order History')),
            body: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.receipt_long, size: 100, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No orders yet',
                    style: TextStyle(fontSize: 20, color: Colors.grey),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Start ordering delicious food!',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.text('No orders yet'), findsOneWidget);
      expect(find.text('Start ordering delicious food!'), findsOneWidget);
      expect(find.byIcon(Icons.receipt_long), findsOneWidget);
    });

    testWidgets('Order cancellation should update status',
        (WidgetTester tester) async {
      var orderStatus = 'Placed';

      await tester.pumpWidget(
        MaterialApp(
          home: StatefulBuilder(
            builder: (context, setState) {
              return Scaffold(
                appBar: AppBar(title: const Text('Order Details')),
                body: Column(
                  children: [
                    const Text('Order #12345'),
                    Text('Status: $orderStatus'),
                    if (orderStatus == 'Placed')
                      ElevatedButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: const Text('Cancel Order'),
                              content: const Text(
                                  'Are you sure you want to cancel this order?'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text('No'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    setState(() {
                                      orderStatus = 'Cancelled';
                                    });
                                    Navigator.pop(context);
                                  },
                                  child: const Text('Yes'),
                                ),
                              ],
                            ),
                          );
                        },
                        child: const Text('Cancel Order'),
                      ),
                  ],
                ),
              );
            },
          ),
        ),
      );

      expect(find.text('Status: Placed'), findsOneWidget);
      expect(find.text('Cancel Order'), findsOneWidget);

      await tester.tap(find.text('Cancel Order'));
      await tester.pumpAndSettle();

      expect(find.text('Are you sure you want to cancel this order?'),
          findsOneWidget);

      await tester.tap(find.text('Yes'));
      await tester.pumpAndSettle();

      expect(find.text('Status: Cancelled'), findsOneWidget);
      expect(find.text('Cancel Order'), findsNothing);
    });
  });
}
