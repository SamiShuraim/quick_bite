# Backend Cold Start Handling Feature

## Overview

This feature automatically handles backend server cold starts, providing a smooth user experience when the free hosting service (Render.com) needs to wake up the server.

## Implementation Details

### 1. Backend Health Service
**File**: `lib/core/services/backend_health_service.dart`

A service class that checks if the backend is running and healthy:
- `checkHealth()` - Performs a health check with 10-second timeout
- `quickHealthCheck()` - Fast check with 3-second timeout
- `waitForBackend()` - Polls backend until it responds (up to 30 attempts = 5 minutes)

### 2. Backend Loading Screen
**File**: `lib/features/onboarding/presentation/screens/backend_loading_screen.dart`

A beautiful loading screen shown when the backend is starting up:
- **Animated logo** with pulse effect
- **Status messages** that update based on attempt count
- **Informative explanation** about why the wait is necessary
- **Retry button** if connection fails after 5 minutes
- **Automatic navigation** once backend is ready

#### UI Features:
- Clean, modern design matching app theme
- Pulsing animation on the logo
- Progress counter showing attempt number
- Educational info box explaining the free hosting limitation
- Dark/Light theme support

### 3. Integration with Splash Screen
**File**: `lib/features/onboarding/presentation/screens/splash_screen.dart`

Updated splash screen to:
1. Perform quick health check during splash animation
2. If backend is healthy → Navigate to onboarding normally
3. If backend is down → Show backend loading screen
4. Backend loading screen handles retries and eventual navigation

## User Experience Flow

### Scenario 1: Backend Already Running
```
App Launch
    ↓
Splash Screen (3 seconds)
    ↓
Quick Health Check (✓ Success)
    ↓
Onboarding Screen
    ↓
Login Screen
```

### Scenario 2: Backend Cold Start
```
App Launch
    ↓
Splash Screen (3 seconds)
    ↓
Quick Health Check (✗ Failed)
    ↓
Backend Loading Screen
    ↓
"Waking up the server..." (with explanation)
    ↓
Periodic health checks (every 10 seconds)
    ↓
Backend responds (✓)
    ↓
Onboarding Screen
    ↓
Login Screen
```

## Technical Implementation

### Health Check Endpoint
- **URL**: `${baseUrl}/health`
- **Method**: GET
- **Expected Response**: 200 OK
- **Timeout**: 10 seconds (with fallback to 408)

### Retry Logic
- **Interval**: 10 seconds between attempts
- **Max Attempts**: 30 (total wait time: ~5 minutes)
- **Failure Action**: Show retry button

### Status Messages
The loading screen displays contextual messages based on attempt count:
- Attempts 1-3: "Starting the server... (attempt X)"
- Attempts 4-10: "Server is starting, this may take a minute..."
- Attempts 11+: "Almost there, just a few more seconds..."
- After 30 attempts: "Unable to connect to server" + Retry button

## Why This Is Needed

### Free Hosting Limitations
- **Service**: Render.com (free tier)
- **Behavior**: Spins down after 15 minutes of inactivity
- **Wake-up Time**: 30-60 seconds on average
- **Solution**: Automatic handling with user-friendly UI

### Benefits
1. **Better UX**: Users understand why they're waiting
2. **Professional**: No crashes or error messages
3. **Automatic**: No manual intervention required
4. **Educational**: Explains the technical constraint
5. **Reliable**: Handles edge cases with retry logic

## Configuration

### Adjust Retry Parameters
Edit `backend_loading_screen.dart`:
```dart
Timer.periodic(const Duration(seconds: 10), (timer) async {
  // Change interval here
});

if (_attemptCount >= 30) {
  // Change max attempts here
}
```

### Change Timeout
Edit `backend_health_service.dart`:
```dart
.timeout(const Duration(seconds: 10))  // Adjust timeout
```

## Testing

### Test Cold Start Manually
1. Wait for Render.com to spin down (15 min inactivity)
2. Launch the app
3. Observe backend loading screen
4. Wait for server to wake up
5. App proceeds automatically

### Test Quick Start
1. Ensure backend is already running
2. Launch the app
3. Should skip loading screen and go straight to onboarding

## Error Handling

### Network Issues
- Shows retry button after max attempts
- User can manually retry the connection
- Clear error message displayed

### Timeout Scenarios
- Each health check has its own timeout
- Won't block indefinitely
- Gracefully degrades to error state

## Future Improvements

Potential enhancements:
1. WebSocket connection for instant notification when server is ready
2. Estimated wait time based on historical data
3. Offline mode with cached data
4. Option to get notified when server is ready (push notification)

## Code Quality

### Features:
- ✅ Clean Architecture principles
- ✅ Proper error handling
- ✅ Logging for debugging
- ✅ Dark/Light theme support
- ✅ Accessibility considerations
- ✅ Smooth animations
- ✅ Resource cleanup (dispose methods)

## Related Files

- `lib/core/constants/api_constants.dart` - Health endpoint constant
- `lib/core/services/backend_health_service.dart` - Health check logic
- `lib/features/onboarding/presentation/screens/backend_loading_screen.dart` - Loading UI
- `lib/features/onboarding/presentation/screens/splash_screen.dart` - Integration point

---

**Last Updated**: December 3, 2024
**Status**: ✅ Fully Implemented and Tested

