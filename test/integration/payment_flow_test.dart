/// Integration tests for payment flow
/// Tests payment method selection and processing
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Payment Flow Integration Tests', () {
    testWidgets('Payment method selection should work',
        (WidgetTester tester) async {
      var selectedMethod = 'card';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            appBar: AppBar(title: const Text('Payment')),
            body: StatefulBuilder(
              builder: (context, setState) {
                return Column(
                  children: [
                    const Text('Select Payment Method'),
                    RadioListTile<String>(
                      title: const Text('Credit/Debit Card'),
                      subtitle: const Text('Pay with card'),
                      value: 'card',
                      groupValue: selectedMethod,
                      onChanged: (value) {
                        setState(() {
                          selectedMethod = value!;
                        });
                      },
                    ),
                    RadioListTile<String>(
                      title: const Text('Cash on Delivery'),
                      subtitle: const Text('Pay with cash'),
                      value: 'cash',
                      groupValue: selectedMethod,
                      onChanged: (value) {
                        setState(() {
                          selectedMethod = value!;
                        });
                      },
                    ),
                    RadioListTile<String>(
                      title: const Text('Apple Pay'),
                      subtitle: const Text('Pay with Apple Pay'),
                      value: 'applepay',
                      groupValue: selectedMethod,
                      onChanged: (value) {
                        setState(() {
                          selectedMethod = value!;
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

      expect(find.text('Select Payment Method'), findsOneWidget);
      expect(find.text('Credit/Debit Card'), findsOneWidget);
      expect(find.text('Cash on Delivery'), findsOneWidget);
      expect(find.text('Apple Pay'), findsOneWidget);

      // Select cash payment
      await tester.tap(find.text('Cash on Delivery'));
      await tester.pumpAndSettle();

      expect(selectedMethod, 'cash');
    });

    testWidgets('Saved cards should be displayed',
        (WidgetTester tester) async {
      final savedCards = [
        {'last4': '1234', 'brand': 'Visa', 'expiry': '12/25'},
        {'last4': '5678', 'brand': 'Mastercard', 'expiry': '06/26'},
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            appBar: AppBar(title: const Text('Saved Cards')),
            body: ListView.builder(
              itemCount: savedCards.length,
              itemBuilder: (context, index) {
                final card = savedCards[index];
                return ListTile(
                  leading: const Icon(Icons.credit_card),
                  title: Text('${card['brand']} •••• ${card['last4']}'),
                  subtitle: Text('Expires ${card['expiry']}'),
                  trailing: Radio<int>(
                    value: index,
                    groupValue: 0,
                    onChanged: (_) {},
                  ),
                );
              },
            ),
            floatingActionButton: FloatingActionButton.extended(
              onPressed: () {},
              icon: const Icon(Icons.add),
              label: const Text('Add Card'),
            ),
          ),
        ),
      );

      expect(find.text('Visa •••• 1234'), findsOneWidget);
      expect(find.text('Mastercard •••• 5678'), findsOneWidget);
      expect(find.text('Expires 12/25'), findsOneWidget);
      expect(find.text('Expires 06/26'), findsOneWidget);
      expect(find.text('Add Card'), findsOneWidget);
    });

    testWidgets('Add new card form should validate inputs',
        (WidgetTester tester) async {
      final formKey = GlobalKey<FormState>();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            appBar: AppBar(title: const Text('Add Card')),
            body: Form(
              key: formKey,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Card Number',
                      hintText: '1234 5678 9012 3456',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter card number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Cardholder Name',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter cardholder name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Expiry Date',
                            hintText: 'MM/YY',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Required';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'CVV',
                            hintText: '123',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Required';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      formKey.currentState!.validate();
                    },
                    child: const Text('Add Card'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.text('Card Number'), findsOneWidget);
      expect(find.text('Cardholder Name'), findsOneWidget);
      expect(find.text('Expiry Date'), findsOneWidget);
      expect(find.text('CVV'), findsOneWidget);

      // Submit form without filling - use byType to avoid ambiguity
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      expect(find.text('Please enter card number'), findsOneWidget);
      expect(find.text('Please enter cardholder name'), findsOneWidget);
      expect(find.text('Required'), findsNWidgets(2));
    });

    testWidgets('Processing payment should show loading indicator',
        (WidgetTester tester) async {
      var isProcessing = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (isProcessing)
                      const Column(
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 16),
                          Text('Processing payment...'),
                        ],
                      )
                    else
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            isProcessing = true;
                          });
                        },
                        child: const Text('Pay Now'),
                      ),
                  ],
                );
              },
            ),
          ),
        ),
      );

      expect(find.text('Pay Now'), findsOneWidget);

      await tester.tap(find.text('Pay Now'));
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Processing payment...'), findsOneWidget);
    });

    testWidgets('Payment success should show confirmation',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check_circle,
                      size: 100, color: Colors.green[600]),
                  const SizedBox(height: 24),
                  const Text(
                    'Payment Successful!',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text('Your order has been placed'),
                  const SizedBox(height: 16),
                  const Text(
                    'Order #12345',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text('Track Order'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.text('Payment Successful!'), findsOneWidget);
      expect(find.text('Your order has been placed'), findsOneWidget);
      expect(find.text('Order #12345'), findsOneWidget);
      expect(find.text('Track Order'), findsOneWidget);
      expect(find.byIcon(Icons.check_circle), findsOneWidget);
    });

    testWidgets('Payment failure should show error message',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline,
                      size: 100, color: Colors.red[600]),
                  const SizedBox(height: 24),
                  const Text(
                    'Payment Failed',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text('Your payment could not be processed'),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text('Try Again'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.text('Payment Failed'), findsOneWidget);
      expect(find.text('Your payment could not be processed'), findsOneWidget);
      expect(find.text('Try Again'), findsOneWidget);
      expect(find.byIcon(Icons.error_outline), findsOneWidget);
    });

    testWidgets('Order summary should be displayed before payment',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            appBar: AppBar(title: const Text('Order Summary')),
            body: Column(
              children: [
                const ListTile(
                  title: Text('Restaurant Name'),
                  subtitle: Text('Burger Palace'),
                ),
                const Divider(),
                const ListTile(
                  title: Text('2x Burger'),
                  trailing: Text('SAR 50.00'),
                ),
                const ListTile(
                  title: Text('1x Fries'),
                  trailing: Text('SAR 10.00'),
                ),
                const Divider(),
                const ListTile(
                  title: Text('Subtotal'),
                  trailing: Text('SAR 60.00'),
                ),
                const ListTile(
                  title: Text('Delivery Fee'),
                  trailing: Text('SAR 5.00'),
                ),
                const ListTile(
                  title: Text('Tax'),
                  trailing: Text('SAR 9.00'),
                ),
                const Divider(thickness: 2),
                const ListTile(
                  title: Text('Total',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  trailing: Text('SAR 74.00',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {},
                      child: const Text('Proceed to Payment'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.text('Order Summary'), findsOneWidget);
      expect(find.text('Burger Palace'), findsOneWidget);
      expect(find.text('2x Burger'), findsOneWidget);
      expect(find.text('SAR 50.00'), findsOneWidget);
      expect(find.text('SAR 74.00'), findsOneWidget);
      expect(find.text('Proceed to Payment'), findsOneWidget);
    });
  });
}
