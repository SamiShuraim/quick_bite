/// Cart entity for QuickBite application
library;

import 'package:equatable/equatable.dart';
import 'menu_item_entity.dart';

class CartEntity extends Equatable {
  final List<CartItem> items;
  final double subtotal;
  final double deliveryFee;
  final double tax;
  final double total;

  const CartEntity({
    required this.items,
    required this.subtotal,
    required this.deliveryFee,
    required this.tax,
    required this.total,
  });

  @override
  List<Object?> get props => [items, subtotal, deliveryFee, tax, total];

  CartEntity copyWith({
    List<CartItem>? items,
    double? subtotal,
    double? deliveryFee,
    double? tax,
    double? total,
  }) {
    return CartEntity(
      items: items ?? this.items,
      subtotal: subtotal ?? this.subtotal,
      deliveryFee: deliveryFee ?? this.deliveryFee,
      tax: tax ?? this.tax,
      total: total ?? this.total,
    );
  }
}

class CartItem extends Equatable {
  final MenuItemEntity menuItem;
  final int quantity;
  final List<SelectedCustomization> customizations;
  final double totalPrice;

  const CartItem({
    required this.menuItem,
    required this.quantity,
    this.customizations = const [],
    required this.totalPrice,
  });

  @override
  List<Object?> get props => [menuItem, quantity, customizations, totalPrice];

  CartItem copyWith({
    MenuItemEntity? menuItem,
    int? quantity,
    List<SelectedCustomization>? customizations,
    double? totalPrice,
  }) {
    return CartItem(
      menuItem: menuItem ?? this.menuItem,
      quantity: quantity ?? this.quantity,
      customizations: customizations ?? this.customizations,
      totalPrice: totalPrice ?? this.totalPrice,
    );
  }
}

class SelectedCustomization extends Equatable {
  final String optionId;
  final String optionName;
  final List<CustomizationChoice> selectedChoices;

  const SelectedCustomization({
    required this.optionId,
    required this.optionName,
    required this.selectedChoices,
  });

  @override
  List<Object?> get props => [optionId, optionName, selectedChoices];
}

