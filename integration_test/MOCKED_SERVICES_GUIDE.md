# Mocked Services Guide for Integration Tests

## ✅ NO BACKEND REQUIRED!

The integration tests now use **mocked services** that simulate backend responses without requiring a running server. This makes tests:
- **Faster**: No network calls
- **Reliable**: No network failures
- **Portable**: Run anywhere, anytime
- **Independent**: No database state to manage

## How It Works

### Architecture

```
Integration Tests
       ↓
   Test App (test_app.dart)
       ↓
   Mock Services (mock_services.dart)
       ↓
   Simulated Responses (in-memory)
```

### What's Mocked

#### 1. **Backend Health Service**
- ✅ Always returns `true` (healthy)
- ✅ No actual HTTP calls
- ✅ Splash screen proceeds immediately

#### 2. **Authentication Service**
- ✅ Login: Any credentials → Success
- ✅ Register: Any data → Success
- ✅ Returns mock user and tokens
- ✅ No database interaction

#### 3. **Restaurant Service**
- ✅ Returns 2 mock restaurants
- ✅ Returns 2 mock menu items per restaurant
- ✅ Search always returns results
- ✅ No API calls

#### 4. **Payment Service**
- ✅ Returns mock saved cards
- ✅ Add card always succeeds
- ✅ Process payment always succeeds
- ✅ No payment gateway interaction

#### 5. **Order Service**
- ✅ Create order stores in memory
- ✅ Get orders returns in-memory list
- ✅ Update/cancel order works in memory
- ✅ No database persistence

## Mock Data Examples

### Mock User
```dart
UserModel(
  id: 'test-user-id',
  email: 'test@example.com',
  name: 'Test User',
  phone: '+1234567890',
)
```

### Mock Restaurants
```dart
[
  RestaurantModel(
    id: 'rest-1',
    name: 'Burger Palace',
    rating: 4.5,
    deliveryTime: 30,
    deliveryFee: 5.0,
  ),
  RestaurantModel(
    id: 'rest-2',
    name: 'Pizza House',
    rating: 4.8,
    deliveryTime: 40,
    deliveryFee: 7.0,
  ),
]
```

### Mock Menu Items
```dart
[
  MenuItemModel(
    id: 'item-1',
    name: 'Classic Burger',
    price: 25.0,
    rating: 4.5,
  ),
  MenuItemModel(
    id: 'item-2',
    name: 'Chicken Burger',
    price: 22.0,
    rating: 4.3,
  ),
]
```

## File Structure

```
integration_test/
├── test_helpers/
│   ├── mock_services.dart      # Mock implementations
│   └── test_app.dart            # Test app with mocks
├── authentication_flow_test.dart
├── restaurant_and_cart_flow_test.dart
└── navigation_flow_test.dart
```

## Key Files

### `mock_services.dart`
Contains mock implementations of:
- `MockAuthRemoteDataSource`
- `MockRestaurantRemoteDataSource`
- `MockPaymentRemoteDataSource`
- `MockOrderRemoteDataSource`
- `MockHttpClient`

### `test_app.dart`
- Test-specific app entry point
- Injects mock services
- Custom splash screen that skips health check
- Same UI as real app

## Benefits

### 1. **Speed**
- No network latency
- No server startup time
- Tests complete in seconds

### 2. **Reliability**
- No flaky network failures
- No backend downtime
- Consistent test results

### 3. **Isolation**
- Each test starts fresh
- No shared database state
- No test interference

### 4. **Portability**
- Run on any device
- No VPN required
- Works offline

### 5. **Simplicity**
- No backend setup
- No test data seeding
- No cleanup required

## Comparison: Real vs Mock

| Aspect | Real Backend | Mocked Services |
|--------|--------------|-----------------|
| **Setup** | Start server, seed DB | None |
| **Speed** | Slow (network) | Fast (in-memory) |
| **Reliability** | Can fail | Always works |
| **Data** | Persistent | In-memory |
| **Network** | Required | Not required |
| **Isolation** | Shared state | Independent |
| **Maintenance** | High | Low |

## When to Use Each

### Use Mocked Tests (Current Setup)
- ✅ UI flow testing
- ✅ Navigation testing
- ✅ State management testing
- ✅ User journey testing
- ✅ CI/CD pipelines
- ✅ Quick feedback loops

### Use Real Backend Tests
- ⚠️ API contract testing
- ⚠️ Database integration
- ⚠️ Performance testing
- ⚠️ End-to-end validation
- ⚠️ Pre-production testing

## Customizing Mock Data

To change mock responses, edit `mock_services.dart`:

```dart
// Example: Add more restaurants
@override
Future<List<RestaurantModel>> getRestaurants() async {
  return [
    RestaurantModel(/* ... */),
    RestaurantModel(/* ... */),
    RestaurantModel(/* your new restaurant */),
  ];
}
```

## Simulating Errors

To test error scenarios, modify mocks:

```dart
@override
Future<AuthResponseModel> login({
  required String email,
  required String password,
}) async {
  // Simulate error for specific email
  if (email == 'error@test.com') {
    throw Exception('Invalid credentials');
  }
  
  // Normal success response
  return AuthResponseModel(/* ... */);
}
```

## Network Delay Simulation

Mocks include realistic delays:

```dart
await Future.delayed(const Duration(seconds: 1)); // Simulate API call
```

Adjust delays in `mock_services.dart` to test:
- Loading states
- Timeout handling
- User patience

## Testing Strategy

### Current Approach (Mocked)
```
Unit Tests (Business Logic)
     ↓
Widget Tests (UI Components)
     ↓
Integration Tests (User Flows) ← Mocked Services
     ↓
Manual Testing (Real Backend)
```

### Benefits of This Approach
1. **Fast feedback** during development
2. **Reliable** CI/CD pipeline
3. **Easy debugging** (no network issues)
4. **Complete coverage** of UI flows

## Troubleshooting

### Tests Still Trying to Connect to Backend
- ✅ Make sure you're using `test_helpers/test_app.dart`
- ✅ Check imports in test files
- ✅ Verify `TestSplashScreen` is being used

### Mock Data Not Appearing
- ✅ Check `pumpAndSettle()` calls
- ✅ Verify mock delays aren't too long
- ✅ Ensure providers are properly initialized

### Tests Failing Unexpectedly
- ✅ Run `flutter clean`
- ✅ Run `flutter pub get`
- ✅ Check for widget finder issues
- ✅ Verify test timeouts

## Future Enhancements

Potential improvements:
1. **Configurable mock data** via JSON files
2. **Error scenario testing** with flags
3. **Performance simulation** with variable delays
4. **State persistence** across test runs
5. **Mock data generators** for variety

## Conclusion

Mocked services provide the **best of both worlds**:
- Test **real user flows** (integration testing)
- Without **backend dependencies** (unit test speed)

This approach ensures tests are:
- ✅ **Fast**
- ✅ **Reliable**
- ✅ **Maintainable**
- ✅ **Portable**

Perfect for **CI/CD** and **rapid development**! 🚀

