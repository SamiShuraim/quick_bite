# Quick Start Guide - Integration Tests

## Prerequisites

1. **NO Backend Server Required! ✅**
   - Tests use mocked services
   - No need to start the backend server
   - Tests run completely offline

2. **Device/Emulator**
   - Connect a physical device via USB, OR
   - Start an Android emulator, OR
   - Start an iOS simulator

3. **Dependencies Installed**
   ```bash
   flutter pub get
   ```

## Running Tests

### Option 1: Run All Tests (Recommended)
```bash
flutter test integration_test
```

### Option 2: Run Specific Test File
```bash
# Authentication tests (3 tests)
flutter test integration_test/authentication_flow_test.dart

# Restaurant and cart tests (3 tests)
flutter test integration_test/restaurant_and_cart_flow_test.dart

# Navigation tests (3 tests)
flutter test integration_test/navigation_flow_test.dart

# Complete order flow tests (5 tests) - NEW!
flutter test integration_test/complete_order_flow_test.dart

# Search and filter tests (7 tests) - NEW!
flutter test integration_test/search_and_filter_flow_test.dart

# Profile and settings tests (9 tests) - NEW!
flutter test integration_test/profile_and_settings_flow_test.dart
```

### Option 3: Run with Flutter Drive
```bash
flutter drive \
  --driver=test_driver/integration_test.dart \
  --target=integration_test/authentication_flow_test.dart
```

### Option 4: Run with Verbose Output
```bash
flutter test integration_test --verbose
```

## Expected Results

### ✅ Successful Test Run
```
00:01 +1: Authentication Flow Integration Tests Complete login journey from splash to home
00:15 +2: Authentication Flow Integration Tests Login with invalid credentials shows error
00:25 +3: Authentication Flow Integration Tests Navigate to signup screen from login
...
00:00 +21: All tests passed!
```

### ❌ Common Issues

#### Tests Failing
```
Error: Various test failures
Solution: Tests use mocked services - no backend needed!
```

#### No Device Connected
```
Error: No devices found
Solution: Connect device or start emulator
```

#### Timeout Errors
```
Error: Test timed out
Solution: Increase timeout in test or check network speed
```

## Test Accounts

**ANY credentials work!** The tests use mocked authentication:
- **Email**: Any valid email format (e.g., `test@example.com`)
- **Password**: Any password (e.g., `password123`)

Mock services always return success responses.

## What Gets Tested

### 🔐 Authentication (3 tests)
- Login flow from splash to home
- Navigation to signup
- Navigation to forgot password

### 🍔 Restaurant & Cart (3 tests)
- Browse restaurants
- View restaurant details
- Add items to cart

### 🧭 Navigation (3 tests)
- Tab navigation
- Profile viewing
- Theme toggle

### 🛒 Complete Order Flow (4 tests)
- End-to-end order placement
- Multiple items management
- Quantity updates
- Item removal

### 🔍 Search & Filter (7 tests)
- Restaurant search
- Category filtering
- Advanced filters
- Free delivery filter
- Sort by rating
- Sort by delivery time
- Clear filters

**Total: 18 integration tests** (covering implemented features only)

## Troubleshooting

### Tests are slow
- **Normal**: Integration tests take time (30s - 5min)
- **Reason**: Real backend calls, navigation, animations

### Tests fail randomly
- **Check**: Network stability
- **Check**: Backend response time
- **Solution**: Increase wait times in tests

### Can't find widgets
- **Check**: Is screen fully loaded?
- **Solution**: Add more `pumpAndSettle()` calls

### Mock service issues
- **Note**: All services are mocked
- **Note**: No real API calls are made
- **Note**: Data is simulated in memory

## Next Steps

After running tests successfully:
1. Review test output for any warnings
2. Check backend logs for any errors
3. Run tests on different devices/platforms
4. Integrate into CI/CD pipeline

## Need Help?

- See `README.md` for detailed documentation
- See `INTEGRATION_TESTS_SUMMARY.md` for implementation details
- Check Flutter integration testing docs: https://docs.flutter.dev/testing/integration-tests

