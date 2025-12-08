# Theme-Based Colors Refactoring Status

## Overview
This document tracks the progress of refactoring the QuickBite Flutter app to use theme-based colors instead of manual dark mode checks.

## Completed Files ✅

### Core Files
- ✅ `lib/core/theme/app_theme.dart` - Enhanced with comprehensive ColorScheme properties
- ✅ `lib/core/constants/app_colors.dart` - Cleaned up helper methods
- ✅ `lib/core/widgets/custom_text_field.dart` - Fully refactored

### Restaurant Feature
- ✅ `lib/features/restaurant/presentation/screens/home_screen.dart`
- ✅ `lib/features/restaurant/presentation/screens/restaurant_detail_screen.dart`
- ✅ `lib/features/restaurant/presentation/screens/cart_screen_v2.dart`
- ✅ `lib/features/restaurant/presentation/screens/food_detail_screen.dart`
- ✅ `lib/features/restaurant/presentation/screens/payment_success_screen.dart`
- ✅ `lib/features/restaurant/presentation/screens/filter_screen.dart`
- ✅ `lib/features/restaurant/presentation/widgets/restaurant_card.dart`
- ✅ `lib/features/restaurant/presentation/widgets/menu_item_card.dart`
- ✅ `lib/features/restaurant/presentation/widgets/category_chip.dart`

### Authentication Feature
- ✅ `lib/features/authentication/presentation/screens/login_screen.dart`
- ✅ `lib/features/authentication/presentation/screens/signup_screen.dart`
- ✅ `lib/features/authentication/presentation/screens/forgot_password_screen.dart`
- ✅ `lib/features/authentication/presentation/screens/verification_screen.dart`

### Onboarding Feature
- ✅ `lib/features/onboarding/presentation/screens/backend_loading_screen.dart`

## Remaining Files 🔄

### High Priority (Main User-Facing Screens)
1. **Profile Screens** (12 occurrences)
   - `lib/features/profile/presentation/screens/profile_screen.dart`
   
2. **Edit Profile** (14 occurrences)
   - `lib/features/profile/presentation/screens/edit_profile_screen.dart`

3. **Order Management** (26 occurrences)
   - `lib/features/order/presentation/screens/my_orders_screen.dart`

4. **Order Tracking** (57 occurrences - Most Complex)
   - `lib/features/order/presentation/screens/order_tracking_screen.dart`

5. **Payment Screens**
   - `lib/features/restaurant/presentation/screens/unified_payment_screen.dart` (22 occurrences)
   - `lib/features/restaurant/presentation/screens/add_card_screen.dart` (19 occurrences)

6. **Old Cart Screen** (if still in use)
   - `lib/features/restaurant/presentation/screens/cart_screen.dart`

### Navigation
- `lib/core/navigation/main_navigation.dart`

### Core (Keep as is)
- `lib/core/providers/theme_provider.dart` - ✅ Should keep `isDarkMode` as it manages theme state

## Refactoring Pattern

### Before (Manual Dark Mode Check)
```dart
final isDarkMode = Theme.of(context).brightness == Brightness.dark;

Container(
  color: isDarkMode ? AppColors.darkCardBackground : AppColors.cardBackground,
  child: Text(
    'Hello',
    style: TextStyle(
      color: isDarkMode ? AppColors.darkTextPrimary : AppColors.textPrimary,
    ),
  ),
)
```

### After (Theme-Based Colors)
```dart
Container(
  color: Theme.of(context).colorScheme.surfaceContainerHighest,
  child: Text(
    'Hello',
    style: TextStyle(
      color: Theme.of(context).colorScheme.onSurface,
    ),
  ),
)
```

## Color Scheme Mapping

### Background Colors
- `isDarkMode ? AppColors.darkCardBackground : AppColors.cardBackground`
  → `Theme.of(context).colorScheme.surfaceContainerHighest`

- `isDarkMode ? AppColors.darkSurface : AppColors.surface`
  → `Theme.of(context).colorScheme.surface`

- Scaffold background
  → `Theme.of(context).scaffoldBackgroundColor`

### Text Colors
- Primary text: `isDarkMode ? AppColors.darkTextPrimary : AppColors.textPrimary`
  → `Theme.of(context).colorScheme.onSurface`

- Secondary text: `isDarkMode ? AppColors.darkTextSecondary : AppColors.textSecondary`
  → `Theme.of(context).colorScheme.onSurfaceVariant`

### Border Colors
- `isDarkMode ? AppColors.darkBorder : AppColors.lightBorder`
  → `Theme.of(context).colorScheme.outline`

### Image Placeholders
- `isDarkMode ? AppColors.darkImagePlaceholder : AppColors.imagePlaceholder`
  → `Theme.of(context).colorScheme.surfaceContainerHighest` (background)
  → `Theme.of(context).colorScheme.onSurfaceVariant` (icon color)

### Primary & Accent Colors
- Primary color: `AppColors.primary`
  → `Theme.of(context).colorScheme.primary`

- On primary: `AppColors.textOnPrimary`
  → `Theme.of(context).colorScheme.onPrimary`

- Error: `AppColors.error`
  → `Theme.of(context).colorScheme.error`

### Shadows
- `Colors.black.withOpacity(0.1)` or `AppColors.shadow`
  → `Theme.of(context).colorScheme.shadow.withOpacity(0.1)`

## Steps to Refactor a File

1. **Remove isDarkMode declaration**
   ```dart
   // Remove this line
   final isDarkMode = Theme.of(context).brightness == Brightness.dark;
   ```

2. **Replace color conditionals with theme colors**
   - Use the mapping table above
   - Search for all `isDarkMode` references
   - Replace with appropriate `Theme.of(context).colorScheme.*` color

3. **Update method signatures**
   - Remove `isDarkMode` parameters from helper methods
   - Add `BuildContext context` if not already present

4. **Test both light and dark modes**
   - Verify the screen looks good in both modes
   - Check text contrast and readability

## Benefits of Theme-Based Approach

1. **Consistency**: All colors are defined in one place (`app_theme.dart`)
2. **Maintainability**: Easier to update colors across the entire app
3. **Flutter Best Practice**: Uses Material Design 3 color system
4. **Automatic**: Flutter handles theme switching automatically
5. **Type Safety**: Better IDE support and autocomplete
6. **Extensibility**: Easy to add more themes or custom colors

## Enhanced Theme Configuration

The theme configuration in `lib/core/theme/app_theme.dart` now includes:

### Light Theme ColorScheme
```dart
colorScheme: const ColorScheme.light(
  primary: AppColors.primary,
  secondary: AppColors.primaryLight,
  surface: AppColors.surface,
  surfaceContainerHighest: AppColors.cardBackground,
  error: AppColors.error,
  onPrimary: AppColors.textOnPrimary,
  onSecondary: AppColors.textOnPrimary,
  onSurface: AppColors.textPrimary,
  onSurfaceVariant: AppColors.textSecondary,
  onError: AppColors.textOnPrimary,
  outline: AppColors.divider,
  outlineVariant: AppColors.lightBorder,
  shadow: AppColors.shadow,
),
```

### Dark Theme ColorScheme
```dart
colorScheme: const ColorScheme.dark(
  primary: AppColors.primary,
  secondary: AppColors.primaryLight,
  surface: AppColors.darkSurface,
  surfaceContainerHighest: AppColors.darkCardBackground,
  error: AppColors.error,
  onPrimary: AppColors.textOnPrimary,
  onSecondary: AppColors.textOnPrimary,
  onSurface: AppColors.darkTextPrimary,
  onSurfaceVariant: AppColors.darkTextSecondary,
  onError: AppColors.textOnPrimary,
  outline: AppColors.darkDivider,
  outlineVariant: AppColors.darkBorder,
  shadow: AppColors.shadow,
),
```

## Next Steps

1. Continue refactoring the remaining files in order of priority
2. Run tests to ensure no regressions
3. Manually test all screens in both light and dark modes
4. Consider removing unused color constants from `AppColors` once refactoring is complete

## Notes

- The `theme_provider.dart` file should retain its `isDarkMode` getter as it's part of the theme management logic
- Test files may also reference `isDarkMode` for testing purposes - these are acceptable
- Focus on user-facing UI code for the refactoring
