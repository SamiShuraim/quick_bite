# CRITICAL FIX - PageView Not Found Error

## ❌ Problem

After refactoring to use shared `performLogin()` helper, **17 out of 18 tests failed** with:

```
The finder "Found 0 widgets with type "PageView": []" (used in a call to "drag()") 
could not find any matching widgets.
```

## 🔍 Root Cause

The `performLogin()` helper was trying to swipe through onboarding `PageView` that **no longer existed** because:

1. Each test calls `app.main()` first
2. Then calls `performLogin(tester)`
3. By the time `performLogin()` runs, the app has already moved past the onboarding screen
4. The `PageView` only exists during onboarding
5. Trying to drag a non-existent widget causes the test to crash

## ✅ Solution

Added a **safety check** in `test_utils.dart`:

```dart
// Check if PageView exists before trying to swipe
final pageView = find.byType(PageView);
if (pageView.evaluate().isNotEmpty) {
  // Swipe through onboarding
  for (int i = 0; i < 4; i++) {
    await tester.drag(pageView, const Offset(-400, 0));
    await tester.pumpAndSettle();
  }
}
```

**Before:** Blindly tried to drag `PageView` → Crash if not found  
**After:** Check if `PageView` exists first → Only drag if present

## 📊 Expected Results

All **18 tests** should now pass:
- ✅ 2 authentication tests
- ✅ 3 restaurant & cart tests  
- ✅ 3 navigation tests
- ✅ 4 complete order flow tests
- ✅ 7 search & filter tests

## 🚀 Run Tests

```bash
flutter test integration_test
```

## 💡 Lesson Learned

**Always check if a widget exists before interacting with it in integration tests!**

Use `.evaluate().isNotEmpty` to verify widget presence:

```dart
final widget = find.byType(SomeWidget);
if (widget.evaluate().isNotEmpty) {
  // Safe to interact
  await tester.tap(widget);
}
```

This makes tests **resilient** to different app states and navigation paths.

