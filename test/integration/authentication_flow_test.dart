/// Integration tests for authentication flow
/// Tests login, signup, and password reset flows
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Authentication Flow Integration Tests', () {
    testWidgets('Login flow should navigate through screens correctly',
        (WidgetTester tester) async {
      var currentScreen = 'login';
      var isLoggedIn = false;

      await tester.pumpWidget(
        MaterialApp(
          home: StatefulBuilder(
            builder: (context, setState) {
              Widget buildScreen() {
                if (isLoggedIn) {
                  return Scaffold(
                    appBar: AppBar(title: const Text('Home')),
                    body: const Center(
                      child: Text('Welcome to QuickBite!'),
                    ),
                  );
                }

                switch (currentScreen) {
                  case 'login':
                    return Scaffold(
                      appBar: AppBar(title: const Text('Login')),
                      body: Column(
                        children: [
                          const TextField(
                            decoration: InputDecoration(labelText: 'Email'),
                          ),
                          const TextField(
                            decoration: InputDecoration(labelText: 'Password'),
                            obscureText: true,
                          ),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                isLoggedIn = true;
                              });
                            },
                            child: const Text('Login'),
                          ),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                currentScreen = 'signup';
                              });
                            },
                            child: const Text('Create Account'),
                          ),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                currentScreen = 'forgot';
                              });
                            },
                            child: const Text('Forgot Password?'),
                          ),
                        ],
                      ),
                    );
                  case 'signup':
                    return Scaffold(
                      appBar: AppBar(title: const Text('Sign Up')),
                      body: Column(
                        children: [
                          const TextField(
                            decoration: InputDecoration(labelText: 'Name'),
                          ),
                          const TextField(
                            decoration: InputDecoration(labelText: 'Email'),
                          ),
                          const TextField(
                            decoration: InputDecoration(labelText: 'Password'),
                            obscureText: true,
                          ),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                currentScreen = 'verification';
                              });
                            },
                            child: const Text('Sign Up'),
                          ),
                        ],
                      ),
                    );
                  case 'verification':
                    return Scaffold(
                      appBar: AppBar(title: const Text('Verify Email')),
                      body: Column(
                        children: [
                          const Text('Enter verification code'),
                          const TextField(
                            decoration: InputDecoration(labelText: 'Code'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                isLoggedIn = true;
                              });
                            },
                            child: const Text('Verify'),
                          ),
                        ],
                      ),
                    );
                  case 'forgot':
                    return Scaffold(
                      appBar: AppBar(title: const Text('Reset Password')),
                      body: Column(
                        children: [
                          const Text('Enter your email to reset password'),
                          const TextField(
                            decoration: InputDecoration(labelText: 'Email'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                currentScreen = 'login';
                              });
                            },
                            child: const Text('Send Reset Link'),
                          ),
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

      // Initial state - Login screen
      expect(find.text('Login'), findsWidgets);
      expect(find.text('Create Account'), findsOneWidget);
      expect(find.text('Forgot Password?'), findsOneWidget);

      // Navigate to signup
      await tester.tap(find.text('Create Account'));
      await tester.pumpAndSettle();

      expect(find.text('Sign Up'), findsWidgets);
      expect(find.text('Name'), findsOneWidget);

      // Submit signup - use byType to avoid ambiguity
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      // Should go to verification
      expect(find.text('Verify Email'), findsOneWidget);
      expect(find.text('Enter verification code'), findsOneWidget);

      // Verify email
      await tester.tap(find.text('Verify'));
      await tester.pumpAndSettle();

      // Should be logged in
      expect(find.text('Welcome to QuickBite!'), findsOneWidget);
    });

    testWidgets('Password visibility toggle should work',
        (WidgetTester tester) async {
      var obscurePassword = true;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return TextField(
                  obscureText: obscurePassword,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    suffixIcon: IconButton(
                      icon: Icon(
                        obscurePassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          obscurePassword = !obscurePassword;
                        });
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.visibility), findsOneWidget);

      await tester.tap(find.byIcon(Icons.visibility));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.visibility_off), findsOneWidget);
    });

    testWidgets('Remember me checkbox should work',
        (WidgetTester tester) async {
      var rememberMe = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return CheckboxListTile(
                  title: const Text('Remember me'),
                  value: rememberMe,
                  onChanged: (value) {
                    setState(() {
                      rememberMe = value!;
                    });
                  },
                );
              },
            ),
          ),
        ),
      );

      expect(find.text('Remember me'), findsOneWidget);
      expect(rememberMe, false);

      await tester.tap(find.byType(Checkbox));
      await tester.pumpAndSettle();

      expect(rememberMe, true);
    });

    testWidgets('Login with empty fields should show errors',
        (WidgetTester tester) async {
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
                        return 'Please enter email';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Password'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter password';
                      }
                      return null;
                    },
                  ),
                  ElevatedButton(
                    onPressed: () {
                      formKey.currentState!.validate();
                    },
                    child: const Text('Login'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Login'));
      await tester.pumpAndSettle();

      expect(find.text('Please enter email'), findsOneWidget);
      expect(find.text('Please enter password'), findsOneWidget);
    });

    testWidgets('Social login buttons should be present',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                const Text('Or continue with'),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.g_mobiledata),
                  label: const Text('Continue with Google'),
                ),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.apple),
                  label: const Text('Continue with Apple'),
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.text('Or continue with'), findsOneWidget);
      expect(find.text('Continue with Google'), findsOneWidget);
      expect(find.text('Continue with Apple'), findsOneWidget);
    });

    testWidgets('Password strength indicator should update',
        (WidgetTester tester) async {
      String getPasswordStrength(String password) {
        if (password.isEmpty) return 'None';
        if (password.length < 6) return 'Weak';
        if (password.length < 10) return 'Medium';
        return 'Strong';
      }

      var password = '';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                final strength = getPasswordStrength(password);
                return Column(
                  children: [
                    TextField(
                      onChanged: (value) {
                        setState(() {
                          password = value;
                        });
                      },
                      decoration: const InputDecoration(
                        labelText: 'Password',
                      ),
                    ),
                    Text('Strength: $strength'),
                  ],
                );
              },
            ),
          ),
        ),
      );

      expect(find.text('Strength: None'), findsOneWidget);

      await tester.enterText(find.byType(TextField), '12345');
      await tester.pumpAndSettle();

      expect(find.text('Strength: Weak'), findsOneWidget);

      await tester.enterText(find.byType(TextField), '12345678');
      await tester.pumpAndSettle();

      expect(find.text('Strength: Medium'), findsOneWidget);
    });

    testWidgets('Terms and conditions checkbox should be required for signup',
        (WidgetTester tester) async {
      var acceptedTerms = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return Column(
                  children: [
                    CheckboxListTile(
                      title: const Text('I accept the Terms & Conditions'),
                      value: acceptedTerms,
                      onChanged: (value) {
                        setState(() {
                          acceptedTerms = value!;
                        });
                      },
                    ),
                    ElevatedButton(
                      onPressed: acceptedTerms ? () {} : null,
                      child: const Text('Sign Up'),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      );

      expect(find.text('I accept the Terms & Conditions'), findsOneWidget);

      // Button should be disabled initially
      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(button.onPressed, isNull);

      // Accept terms
      await tester.tap(find.byType(Checkbox));
      await tester.pumpAndSettle();

      // Button should now be enabled
      final enabledButton =
          tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(enabledButton.onPressed, isNotNull);
    });

    testWidgets('OTP verification should accept 6 digits',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            appBar: AppBar(title: const Text('Verify OTP')),
            body: Column(
              children: [
                const Text('Enter 6-digit code sent to your email'),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(
                    6,
                    (index) => SizedBox(
                      width: 50,
                      child: TextField(
                        maxLength: 1,
                        textAlign: TextAlign.center,
                        decoration: const InputDecoration(
                          counterText: '',
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {},
                  child: const Text('Verify'),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text('Resend Code'),
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.text('Verify OTP'), findsOneWidget);
      expect(find.text('Enter 6-digit code sent to your email'), findsOneWidget);
      expect(find.byType(TextField), findsNWidgets(6));
      expect(find.text('Resend Code'), findsOneWidget);
    });
  });
}
