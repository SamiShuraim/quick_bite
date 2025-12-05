# Cart Restaurant Validation Feature

## Overview
Implemented a feature to prevent users from adding items from different restaurants to the cart. When a user attempts to add an item from a different restaurant, they are prompted with a confirmation dialog to replace the existing cart items.

## Changes Made

### 1. CartProvider (`lib/features/restaurant/presentation/providers/cart_provider.dart`)

#### Added Properties:
- `String? _restaurantId` - Tracks the current restaurant ID in the cart
- `String? _restaurantName` - Tracks the current restaurant name in the cart
- `String? get restaurantId` - Getter for restaurant ID
- `String? get restaurantName` - Getter for restaurant name

#### Added Method:
```dart
bool hasDifferentRestaurant(String restaurantId)
```
Checks if the cart contains items from a different restaurant than the provided restaurant ID.

#### Updated Method:
```dart
void addItem({
  required MenuItemEntity menuItem,
  required String restaurantId,
  required String restaurantName,
  List<SelectedCustomization> customizations = const [],
  bool clearExisting = false,
})
```
- Added required parameters: `restaurantId` and `restaurantName`
- Added optional parameter: `clearExisting` (defaults to `false`)
- Sets restaurant information when adding the first item
- Clears existing items when `clearExisting` is `true`
- Logs restaurant information when items are added

#### Updated Method:
```dart
void clearCart()
```
- Now also clears `_restaurantId` and `_restaurantName` when cart is cleared

### 2. FoodDetailScreen (`lib/features/restaurant/presentation/screens/food_detail_screen.dart`)

#### Updated Method:
```dart
void _addToCart()
```
- Added validation to check if cart has items from a different restaurant
- Shows confirmation dialog if items from different restaurant exist
- Calls `_performAddToCart()` if no conflict or after confirmation

#### Added Method:
```dart
Future<void> _showDifferentRestaurantDialog(CartProvider cartProvider)
```
Shows a dialog with:
- Title: "Replace cart items?"
- Message: "You have items from {Restaurant A} in your cart. Do you want to clear those items and add {Item Name} from {Restaurant B} instead?"
- Actions: 
  - CANCEL button - Dismisses dialog without adding item
  - REPLACE button - Clears cart and adds the new item

#### Added Method:
```dart
void _performAddToCart(CartProvider cartProvider, {required bool clearExisting})
```
Handles the actual cart addition logic:
- Converts customizations to the proper format
- Adds items to cart with restaurant information
- Passes `clearExisting` flag to clear previous items when replacing
- Navigates back and shows success message

### 3. MyOrdersScreen (`lib/features/order/presentation/screens/my_orders_screen.dart`)

#### Updated Method:
```dart
Future<void> _handleReorder(BuildContext context, OrderEntity order)
```
Updated the reorder functionality to pass restaurant information when adding items:
```dart
cartProvider.addItem(
  menuItem: menuItem,
  restaurantId: order.restaurantId,
  restaurantName: order.restaurantName,
  customizations: customizations,
);
```

## User Flow

### Scenario 1: Adding items from the same restaurant
1. User adds items from Restaurant A
2. User adds more items from Restaurant A
3. Items are added normally without any prompt

### Scenario 2: Adding items from a different restaurant
1. User adds 2 items from Restaurant A (e.g., "Pasta" and "Pizza")
2. Cart now contains items from Restaurant A
3. User navigates to Restaurant B
4. User tries to add an item from Restaurant B (e.g., "Burger")
5. Dialog appears:
   - **Title**: "Replace cart items?"
   - **Message**: "You have items from Restaurant A in your cart. Do you want to clear those items and add Burger from Restaurant B instead?"
   - **CANCEL**: Dismisses dialog, cart remains unchanged
   - **REPLACE**: Clears all items from Restaurant A, adds Burger from Restaurant B

### Scenario 3: Reordering
1. User clicks "Reorder" on a previous order
2. Cart is cleared
3. All items from the previous order are added with proper restaurant information

## Benefits

1. **Data Integrity**: Ensures cart only contains items from one restaurant at a time
2. **Clear Communication**: Users are informed which restaurant's items will be removed
3. **Explicit Confirmation**: Users must explicitly confirm the replacement action
4. **Flexible**: Users can cancel and keep their existing cart if they change their mind
5. **Consistent Experience**: Works seamlessly with reorder functionality

## Testing Recommendations

1. Add items from Restaurant A, then try to add from Restaurant B
2. Verify dialog shows correct restaurant names and item names
3. Test CANCEL button keeps original cart
4. Test REPLACE button clears old items and adds new ones
5. Test reorder functionality with different restaurants
6. Test adding items from same restaurant works without prompts
7. Test with customized items
8. Test in both light and dark modes
