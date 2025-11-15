/// Order Entity for QuickBite application
library;

import 'package:equatable/equatable.dart';

class OrderEntity extends Equatable {
  final String id;
  final String orderNumber;
  final String restaurantId;
  final String restaurantName;
  final List<OrderItemEntity> items;
  final DeliveryAddressEntity deliveryAddress;
  final PaymentDetailsEntity paymentDetails;
  final double subtotal;
  final double deliveryFee;
  final double tax;
  final double total;
  final String status;
  final DateTime estimatedDeliveryTime;
  final String? specialInstructions;
  final DateTime createdAt;
  final DateTime updatedAt;

  const OrderEntity({
    required this.id,
    required this.orderNumber,
    required this.restaurantId,
    required this.restaurantName,
    required this.items,
    required this.deliveryAddress,
    required this.paymentDetails,
    required this.subtotal,
    required this.deliveryFee,
    required this.tax,
    required this.total,
    required this.status,
    required this.estimatedDeliveryTime,
    this.specialInstructions,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        orderNumber,
        restaurantId,
        restaurantName,
        items,
        deliveryAddress,
        paymentDetails,
        subtotal,
        deliveryFee,
        tax,
        total,
        status,
        estimatedDeliveryTime,
        specialInstructions,
        createdAt,
        updatedAt,
      ];
}

class OrderItemEntity extends Equatable {
  final String menuItemId;
  final String name;
  final double price;
  final int quantity;
  final String imageUrl;
  final List<OrderCustomizationEntity>? customizations;
  final double subtotal;

  const OrderItemEntity({
    required this.menuItemId,
    required this.name,
    required this.price,
    required this.quantity,
    required this.imageUrl,
    this.customizations,
    required this.subtotal,
  });

  @override
  List<Object?> get props => [
        menuItemId,
        name,
        price,
        quantity,
        imageUrl,
        customizations,
        subtotal,
      ];
}

class OrderCustomizationEntity extends Equatable {
  final String optionName;
  final List<String> choices;

  const OrderCustomizationEntity({
    required this.optionName,
    required this.choices,
  });

  @override
  List<Object?> get props => [optionName, choices];
}

class DeliveryAddressEntity extends Equatable {
  final String street;
  final String city;
  final String state;
  final String zipCode;
  final String country;
  final String fullAddress;
  final double? latitude;
  final double? longitude;

  const DeliveryAddressEntity({
    required this.street,
    required this.city,
    required this.state,
    required this.zipCode,
    required this.country,
    required this.fullAddress,
    this.latitude,
    this.longitude,
  });

  @override
  List<Object?> get props => [
        street,
        city,
        state,
        zipCode,
        country,
        fullAddress,
        latitude,
        longitude,
      ];
}

class PaymentDetailsEntity extends Equatable {
  final String method;
  final String? cardLast4;
  final String? cardBrand;
  final String? transactionId;
  final String paymentStatus;
  final DateTime? paidAt;

  const PaymentDetailsEntity({
    required this.method,
    this.cardLast4,
    this.cardBrand,
    this.transactionId,
    required this.paymentStatus,
    this.paidAt,
  });

  @override
  List<Object?> get props => [
        method,
        cardLast4,
        cardBrand,
        transactionId,
        paymentStatus,
        paidAt,
      ];
}

