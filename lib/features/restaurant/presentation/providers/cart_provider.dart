/// Cart provider for QuickBite application
/// Manages shopping cart state
library;

import 'package:flutter/foundation.dart';
import '../../domain/entities/cart_entity.dart';
import '../../domain/entities/menu_item_entity.dart';
import '../../../../core/utils/app_logger.dart';

class CartProvider with ChangeNotifier {
  final List<CartItem> _items = [];
  String? _restaurantId;
  String? _restaurantName;
  double? _restaurantDeliveryFee;
  bool _isFreeDelivery = false;
  static const double taxRate = 0.15; // 15% VAT (Saudi Arabia)

  List<CartItem> get items => _items;
  int get itemCount => _items.fold(0, (sum, item) => sum + item.quantity);
  bool get isEmpty => _items.isEmpty;
  String? get restaurantId => _restaurantId;
  String? get restaurantName => _restaurantName;

  double get subtotal {
    return _items.fold(0.0, (sum, item) => sum + item.totalPrice);
  }

  double get deliveryFee {
    // Use restaurant's delivery fee if available
    if (_isFreeDelivery) return 0.0;
    return _restaurantDeliveryFee ?? 0.0;
  }

  double get tax {
    return subtotal * taxRate;
  }

  double get total {
    return subtotal + deliveryFee + tax;
  }

  CartEntity get cart {
    return CartEntity(
      items: _items,
      subtotal: subtotal,
      deliveryFee: deliveryFee,
      tax: tax,
      total: total,
    );
  }

  /// Check if cart has items from a different restaurant
  bool hasDifferentRestaurant(String restaurantId) {
    return _items.isNotEmpty && _restaurantId != null && _restaurantId != restaurantId;
  }

  void addItem({
    required MenuItemEntity menuItem,
    required String restaurantId,
    required String restaurantName,
    required double restaurantDeliveryFee,
    required bool isFreeDelivery,
    List<SelectedCustomization> customizations = const [],
    bool clearExisting = false,
  }) {
    // If clearing existing items from different restaurant
    if (clearExisting) {
      _items.clear();
      _restaurantId = null;
      _restaurantName = null;
      _restaurantDeliveryFee = null;
      _isFreeDelivery = false;
    }

    // Set restaurant info if cart is empty
    if (_items.isEmpty) {
      _restaurantId = restaurantId;
      _restaurantName = restaurantName;
      _restaurantDeliveryFee = restaurantDeliveryFee;
      _isFreeDelivery = isFreeDelivery;
    }

    final customizationPrice = customizations.fold<double>(
      0.0,
      (sum, custom) => sum + custom.selectedChoices.fold<double>(
            0.0,
            (sum2, choice) => sum2 + choice.additionalPrice,
          ),
    );

    final totalPrice = (menuItem.price + customizationPrice);

    // Check if item with same customizations exists
    final existingIndex = _items.indexWhere((item) =>
        item.menuItem.id == menuItem.id &&
        _customizationsMatch(item.customizations, customizations));

    if (existingIndex >= 0) {
      // Update quantity
      final existingItem = _items[existingIndex];
      _items[existingIndex] = existingItem.copyWith(
        quantity: existingItem.quantity + 1,
        totalPrice: totalPrice * (existingItem.quantity + 1),
      );
    } else {
      // Add new item
      _items.add(CartItem(
        menuItem: menuItem,
        quantity: 1,
        customizations: customizations,
        totalPrice: totalPrice,
      ));
    }

    AppLogger.userAction('Item Added to Cart', details: {
      'itemName': menuItem.name,
      'price': menuItem.price,
      'cartSize': _items.length,
      'restaurantId': restaurantId,
      'restaurantName': restaurantName,
    });

    notifyListeners();
  }

  bool _customizationsMatch(
    List<SelectedCustomization> c1,
    List<SelectedCustomization> c2,
  ) {
    if (c1.length != c2.length) return false;
    for (var i = 0; i < c1.length; i++) {
      if (c1[i].optionId != c2[i].optionId) return false;
      if (c1[i].selectedChoices.length != c2[i].selectedChoices.length) {
        return false;
      }
      for (var j = 0; j < c1[i].selectedChoices.length; j++) {
        if (c1[i].selectedChoices[j].id != c2[i].selectedChoices[j].id) {
          return false;
        }
      }
    }
    return true;
  }

  void removeItem(int index) {
    if (index >= 0 && index < _items.length) {
      final item = _items[index];
      AppLogger.userAction('Item Removed from Cart', details: {
        'itemName': item.menuItem.name,
      });
      _items.removeAt(index);
      notifyListeners();
    }
  }

  void updateQuantity(int index, int quantity) {
    if (index >= 0 && index < _items.length) {
      if (quantity <= 0) {
        removeItem(index);
      } else {
        final item = _items[index];
        final pricePerItem = item.totalPrice / item.quantity;
        _items[index] = item.copyWith(
          quantity: quantity,
          totalPrice: pricePerItem * quantity,
        );
        notifyListeners();
      }
    }
  }

  void clearCart() {
    AppLogger.userAction('Cart Cleared');
    _items.clear();
    _restaurantId = null;
    _restaurantName = null;
    _restaurantDeliveryFee = null;
    _isFreeDelivery = false;
    notifyListeners();
  }
}

