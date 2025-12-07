# QuickBite Testing Guide

## Overview

This guide explains how to run and maintain tests for the QuickBite food delivery application.

## Test Structure

```
test/
├── unit/                           # Unit tests for business logic
│   ├── cart_provider_test.dart     # Cart calculations and management
│   ├── entity_test.dart            # Domain entities
│   ├── validation_test.dart        # Form validation logic
│   └── currency_formatter_test.dart # Currency formatting
├── widget/                         # Widget tests for UI components
│   ├── restaurant_card_test.dart   # Restaurant card widget
│   ├── menu_item_card_test.dart    # Menu item card widget
│   ├── category_chip_test.dart     # Category filter chips
│   ├── cart_item_widget_test.dart  # Cart item display
│   ├── profile_screen_test.dart    # Profile screen
│   ├── login_form_test.dart        # Login form validation
│   ├── onboarding_button_test.dart # Button components
│   └── page_indicator_test.dart    # Page indicators
└── integration/                    # Integration tests for user flows
    ├── cart_flow_test.dart         # Cart operations
    ├── restaurant_selection_flow_test.dart  # Restaurant browsing
    ├── order_management_test.dart  # Order lifecycle
    ├── payment_flow_test.dart      # Payment processing
    ├── authentication_flow_test.dart # Login/signup flows
    ├── navigation_flow_test.dart   # Navigation patterns
    ├── onboarding_flow_test.dart   # Onboarding screens
    └── theme_switching_test.dart   # Theme switching
```

## Running Tests

### Run All Tests
```bash
flutter test
```

### Run Specific Test Suites

**Unit Tests Only:**
```bash
flutter test test/unit/
```

**Widget Tests Only:**
```bash
flutter test test/widget/
```

**Integration Tests Only:**
```bash
flutter test test/integration/
```

### Run Specific Test File
```bash
flutter test test/unit/cart_provider_test.dart
```

### Run Tests with Coverage
```bash
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

### Run Tests in Watch Mode (for development)
```bash
flutter test --watch
```

## Test Categories Explained

### Unit Tests
Unit tests verify individual functions and classes work correctly in isolation.

**What they test:**
- Business logic and calculations
- Data models and entities
- Utility functions
- Form validation rules

**Example:**
```dart
test('Tax should be calculated correctly (15%)', () {
  cartProvider.addItem(...);
  expect(cartProvider.tax, 15.0); // 15% of 100
});
```

### Widget Tests
Widget tests verify UI components render correctly and respond to user interactions.

**What they test:**
- Widget rendering
- User interactions (taps, scrolls)
- Visual states
- Theme application

**Example:**
```dart
testWidgets('RestaurantCard should display restaurant name', 
    (WidgetTester tester) async {
  await tester.pumpWidget(...);
  expect(find.text('Test Restaurant'), findsOneWidget);
});
```

### Integration Tests
Integration tests verify complete user flows work end-to-end.

**What they test:**
- Multi-screen workflows
- State management across screens
- Navigation flows
- Complex user interactions

**Example:**
```dart
testWidgets('Complete order flow from cart to confirmation',
    (WidgetTester tester) async {
  // Test cart -> payment -> confirmation flow
});
```

## Test Best Practices

### 1. Follow AAA Pattern
```dart
test('Description', () {
  // Arrange - Set up test data
  final cartProvider = CartProvider();
  
  // Act - Perform the action
  cartProvider.addItem(...);
  
  // Assert - Verify the result
  expect(cartProvider.itemCount, 1);
});
```

### 2. Use Descriptive Test Names
✅ Good: `'Adding item should update cart state'`  
❌ Bad: `'Test 1'`

### 3. Test One Thing Per Test
Each test should verify a single behavior or outcome.

### 4. Keep Tests Independent
Tests should not depend on other tests running first.

### 5. Use Test Helpers
Create helper functions for common setup:
```dart
MenuItemEntity createTestMenuItem({String id = '1', double price = 25.0}) {
  return MenuItemEntity(...);
}
```

## What to Test

### ✅ Do Test
- Business logic calculations
- User input validation
- State management
- Navigation flows
- Error handling
- Edge cases (empty states, max values, etc.)

### ❌ Don't Test
- Third-party library internals
- Flutter framework code
- Trivial getters/setters
- Private methods (test through public API)

## Common Test Patterns

### Testing Provider State Changes
```dart
testWidgets('Provider state updates', (tester) async {
  final provider = CartProvider();
  
  await tester.pumpWidget(
    ChangeNotifierProvider.value(
      value: provider,
      child: Consumer<CartProvider>(
        builder: (context, cart, _) {
          return Text('Items: ${cart.itemCount}');
        },
      ),
    ),
  );
  
  provider.addItem(...);
  await tester.pump();
  
  expect(find.text('Items: 1'), findsOneWidget);
});
```

### Testing Form Validation
```dart
testWidgets('Form validation', (tester) async {
  final formKey = GlobalKey<FormState>();
  
  await tester.pumpWidget(
    MaterialApp(
      home: Form(
        key: formKey,
        child: TextFormField(
          validator: (value) => value!.isEmpty ? 'Required' : null,
        ),
      ),
    ),
  );
  
  formKey.currentState!.validate();
  await tester.pump();
  
  expect(find.text('Required'), findsOneWidget);
});
```

### Testing Navigation
```dart
testWidgets('Navigation flow', (tester) async {
  await tester.pumpWidget(
    MaterialApp(
      home: ScreenA(),
      routes: {'/screenB': (_) => ScreenB()},
    ),
  );
  
  await tester.tap(find.text('Go to Screen B'));
  await tester.pumpAndSettle();
  
  expect(find.byType(ScreenB), findsOneWidget);
});
```

## Debugging Tests

### View Widget Tree
```dart
debugDumpApp(); // Print widget tree
```

### Print Rendered Widgets
```dart
print(tester.allWidgets.toList());
```

### Take Screenshots (for debugging)
```dart
await expectLater(
  find.byType(MyWidget),
  matchesGoldenFile('my_widget.png'),
);
```

## Continuous Integration

Add to your CI/CD pipeline:

```yaml
# .github/workflows/test.yml
name: Tests
on: [push, pull_request]
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - uses: subosito/flutter-action@v2
      - run: flutter test --coverage
      - uses: codecov/codecov-action@v2
```

## Coverage Goals

| Category | Target Coverage |
|----------|----------------|
| Unit Tests | 80%+ |
| Widget Tests | 70%+ |
| Integration Tests | Key flows covered |

## Maintaining Tests

### When Adding New Features
1. Write tests first (TDD approach) or alongside feature
2. Ensure all business logic has unit tests
3. Test UI components with widget tests
4. Add integration tests for new user flows

### When Fixing Bugs
1. Write a failing test that reproduces the bug
2. Fix the bug
3. Verify test passes
4. Keep the test to prevent regression

### When Refactoring
1. Run existing tests to ensure behavior unchanged
2. Update tests if API changes
3. Maintain test coverage levels

## Getting Help

- **Flutter Testing Docs**: https://docs.flutter.dev/testing
- **Testing Best Practices**: https://docs.flutter.dev/cookbook/testing
- **Widget Testing**: https://docs.flutter.dev/cookbook/testing/widget
- **Integration Testing**: https://docs.flutter.dev/cookbook/testing/integration

## Test Statistics

- **Total Test Files**: 20
- **Total Tests**: 130+
- **Unit Tests**: 67 tests across 4 files
- **Widget Tests**: 50+ tests across 8 files
- **Integration Tests**: 33+ tests across 8 files

## Quick Commands Reference

```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage

# Run specific file
flutter test test/unit/cart_provider_test.dart

# Run tests matching pattern
flutter test --name "cart"

# Run with verbose output
flutter test --verbose

# Update golden files (for widget screenshots)
flutter test --update-goldens
```
