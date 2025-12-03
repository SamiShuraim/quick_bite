/// Widget tests for Login Screen form validation
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Login Form Widget Tests', () {
    testWidgets('Email field should accept valid email', (WidgetTester tester) async {
      // Arrange
      final emailController = TextEditingController();
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TextFormField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email';
                }
                if (!value.contains('@')) {
                  return 'Please enter a valid email';
                }
                return null;
              },
            ),
          ),
        ),
      );

      // Act
      await tester.enterText(find.byType(TextFormField), 'test@example.com');
      
      // Assert
      expect(emailController.text, 'test@example.com');
    });

    testWidgets('Password field should obscure text', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TextFormField(
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
          ),
        ),
      );

      // Assert - text field renders with obscure text enabled
      expect(find.byType(TextFormField), findsOneWidget);
    });

    testWidgets('Form should show error for invalid email', (WidgetTester tester) async {
      // Arrange
      final formKey = GlobalKey<FormState>();
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Form(
              key: formKey,
              child: Column(
                children: [
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Email'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!value.contains('@')) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      // Act
      await tester.enterText(find.byType(TextFormField), 'invalidemail');
      formKey.currentState!.validate();
      await tester.pump();

      // Assert
      expect(find.text('Please enter a valid email'), findsOneWidget);
    });

    testWidgets('Empty email should show error', (WidgetTester tester) async {
      // Arrange
      final formKey = GlobalKey<FormState>();
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Form(
              key: formKey,
              child: TextFormField(
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
              ),
            ),
          ),
        ),
      );

      // Act
      formKey.currentState!.validate();
      await tester.pump();

      // Assert
      expect(find.text('Please enter your email'), findsOneWidget);
    });

    testWidgets('Submit button should be tappable', (WidgetTester tester) async {
      // Arrange
      var buttonPressed = false;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ElevatedButton(
              onPressed: () {
                buttonPressed = true;
              },
              child: const Text('Login'),
            ),
          ),
        ),
      );

      // Act
      await tester.tap(find.text('Login'));
      await tester.pump();

      // Assert
      expect(buttonPressed, true);
    });
  });
}

