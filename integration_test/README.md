# Integration Tests for QuickBite

This directory contains **proper integration tests** that follow Flutter's integration testing best practices as outlined in the course material.

## What Are Integration Tests?

Integration tests verify that multiple parts of an application (widgets, services, databases) work correctly together as an end-to-end flow.

### Key Characteristics:
- ✅ **Runs on real device or emulator**
- ✅ **Tests complete user journeys**
- ✅ **Uses `integration_test` package**
- ✅ **Interacts with actual backend services**
- ✅ **Spans multiple screens and features**
- ✅ **Slower than unit/widget tests**

## Test Files

### 1. `authentication_flow_test.dart`
Tests complete authentication flows:
- Login journey from splash → onboarding → login → home
- Invalid credentials error handling
- Navigation to signup screen
- Navigation to forgot password screen

### 2. `restaurant_and_cart_flow_test.dart`
Tests restaurant browsing and cart operations:
- Browse restaurants and view details
- Add items to cart from menu
- Update cart quantities
- Search and filter restaurants
- Remove items from cart

### 3. `checkout_and_order_flow_test.dart`
Tests checkout and order placement:
- Complete checkout flow from cart to confirmation
- View order history and track orders
- Select payment methods and add cards
- Apply promo codes
- Cancel orders

### 4. `navigation_and_profile_flow_test.dart`
Tests app navigation and profile management:
- Navigate between bottom navigation tabs
- View and edit profile information
- Toggle theme (light/dark mode)
- Logout functionality
- Settings and preferences
- Deep link navigation
- State persistence across navigation

## Setup

### 1. Add Dependencies

Ensure `pubspec.yaml` includes:

```yaml
dev_dependencies:
  flutter_test:
    sdk: flutter
  integration_test:
    sdk: flutter
```

### 2. Run Tests

#### On Connected Device/Emulator:

```bash
# Run all integration tests
flutter test integration_test

# Run specific test file
flutter test integration_test/authentication_flow_test.dart

# Run with verbose output
flutter test integration_test --verbose
```

#### Using Flutter Drive (Alternative):

```bash
flutter drive \
  --driver=test_driver/integration_test.dart \
  --target=integration_test/authentication_flow_test.dart
```

### 3. Create Test Driver (if using flutter drive)

Create `test_driver/integration_test.dart`:

```dart
import 'package:integration_test/integration_test_driver.dart';

Future<void> main() => integrationDriver();
```

## Test Structure

All tests follow the **Arrange-Act-Assert (AAA)** pattern:

```dart
testWidgets('Test description', (WidgetTester tester) async {
  // Arrange: Set up test state
  app.main();
  await tester.pumpAndSettle();
  
  // Act: Perform user actions
  await tester.tap(find.text('Login'));
  await tester.pumpAndSettle();
  
  // Assert: Verify expected outcomes
  expect(find.text('Home'), findsOneWidget);
});
```

## Key Differences from Widget Tests

| Aspect | Widget Tests | Integration Tests |
|--------|-------------|-------------------|
| **Scope** | Single widget/component | Multiple screens/features |
| **Environment** | Simulated | Real device/emulator |
| **Backend** | Mocked | Actual backend |
| **Speed** | Fast | Slower |
| **Purpose** | Test UI components | Test user journeys |
| **Package** | `flutter_test` | `integration_test` |

## Best Practices

1. **Test Real User Journeys**: Focus on complete workflows users actually perform
2. **Use Real Services**: Connect to actual backend APIs, not mocks
3. **Handle Timing**: Use `pumpAndSettle()` with appropriate durations for async operations
4. **Test Critical Paths**: Prioritize most important user flows
5. **Keep Tests Independent**: Each test should be able to run in isolation
6. **Clean Up**: Ensure tests don't leave data that affects other tests
7. **Use Keys**: Add keys to widgets for reliable finding in tests
8. **Wait for Backend**: Account for network delays and API response times

## Common Issues & Solutions

### Issue: Tests timeout
**Solution**: Increase timeout durations for network operations:
```dart
await tester.pumpAndSettle(const Duration(seconds: 10));
```

### Issue: Widgets not found
**Solution**: 
- Wait longer for screen to load
- Check if widget is in a scrollable view
- Use more specific finders (byKey, byType)

### Issue: Backend not responding
**Solution**: 
- Ensure backend server is running
- Check network connectivity
- Verify API endpoints are correct

### Issue: Flaky tests
**Solution**:
- Add proper wait times
- Handle conditional UI elements
- Check for dialogs/popups that may appear

## Running Tests in CI/CD

### GitHub Actions Example:

```yaml
name: Integration Tests
on: [push, pull_request]

jobs:
  integration_test:
    runs-on: macos-latest
    steps:
      - uses: actions/checkout@v2
      - uses: subosito/flutter-action@v2
      - run: flutter pub get
      - run: flutter test integration_test
```

## Test Coverage

Integration tests complement unit and widget tests:

```
Testing Pyramid:
    /\
   /  \  ← Few Integration Tests (E2E flows)
  /____\
 /      \ ← More Widget Tests (UI components)
/________\ ← Many Unit Tests (Business logic)
```

## Resources

- [Flutter Integration Testing Docs](https://docs.flutter.dev/testing/integration-tests)
- [Integration Test Package](https://pub.dev/packages/integration_test)
- Course Material: "Draft Handout Architectures and testing.htm"

## Notes

- These tests require a running backend instance
- Tests interact with real data - use test accounts
- Some tests may take several minutes to complete
- Run on physical devices for best results

