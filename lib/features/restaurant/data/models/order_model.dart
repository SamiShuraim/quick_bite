/// Order Model for QuickBite application
library;

import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/order_entity.dart';

part 'order_model.g.dart';

@JsonSerializable(explicitToJson: true)
class OrderModel {
  @JsonKey(name: '_id')
  final String id;
  final String orderNumber;
  final String restaurantId;
  final String restaurantName;
  final List<OrderItemModel> items;
  final DeliveryAddressModel deliveryAddress;
  final PaymentDetailsModel paymentDetails;
  final double subtotal;
  final double deliveryFee;
  final double tax;
  final double total;
  final String status;
  final DateTime estimatedDeliveryTime;
  final String? specialInstructions;
  final DateTime createdAt;
  final DateTime updatedAt;

  const OrderModel({
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

  factory OrderModel.fromJson(Map<String, dynamic> json) =>
      _$OrderModelFromJson(json);

  Map<String, dynamic> toJson() => _$OrderModelToJson(this);

  OrderEntity toEntity() {
    return OrderEntity(
      id: id,
      orderNumber: orderNumber,
      restaurantId: restaurantId,
      restaurantName: restaurantName,
      items: items.map((item) => item.toEntity()).toList(),
      deliveryAddress: deliveryAddress.toEntity(),
      paymentDetails: paymentDetails.toEntity(),
      subtotal: subtotal,
      deliveryFee: deliveryFee,
      tax: tax,
      total: total,
      status: status,
      estimatedDeliveryTime: estimatedDeliveryTime,
      specialInstructions: specialInstructions,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}

@JsonSerializable(explicitToJson: true)
class OrderItemModel {
  final String menuItemId;
  final String name;
  final double price;
  final int quantity;
  final String imageUrl;
  final List<OrderCustomizationModel>? customizations;
  final double subtotal;

  const OrderItemModel({
    required this.menuItemId,
    required this.name,
    required this.price,
    required this.quantity,
    required this.imageUrl,
    this.customizations,
    required this.subtotal,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) =>
      _$OrderItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$OrderItemModelToJson(this);

  OrderItemEntity toEntity() {
    return OrderItemEntity(
      menuItemId: menuItemId,
      name: name,
      price: price,
      quantity: quantity,
      imageUrl: imageUrl,
      customizations: customizations?.map((c) => c.toEntity()).toList(),
      subtotal: subtotal,
    );
  }
}

@JsonSerializable()
class OrderCustomizationModel {
  final String optionName;
  final List<String> choices;

  const OrderCustomizationModel({
    required this.optionName,
    required this.choices,
  });

  factory OrderCustomizationModel.fromJson(Map<String, dynamic> json) =>
      _$OrderCustomizationModelFromJson(json);

  Map<String, dynamic> toJson() => _$OrderCustomizationModelToJson(this);

  OrderCustomizationEntity toEntity() {
    return OrderCustomizationEntity(
      optionName: optionName,
      choices: choices,
    );
  }
}

@JsonSerializable()
class DeliveryAddressModel {
  final String street;
  final String city;
  final String state;
  final String zipCode;
  final String country;
  final String fullAddress;
  final double? latitude;
  final double? longitude;

  const DeliveryAddressModel({
    required this.street,
    required this.city,
    required this.state,
    required this.zipCode,
    required this.country,
    required this.fullAddress,
    this.latitude,
    this.longitude,
  });

  factory DeliveryAddressModel.fromJson(Map<String, dynamic> json) =>
      _$DeliveryAddressModelFromJson(json);

  Map<String, dynamic> toJson() => _$DeliveryAddressModelToJson(this);

  DeliveryAddressEntity toEntity() {
    return DeliveryAddressEntity(
      street: street,
      city: city,
      state: state,
      zipCode: zipCode,
      country: country,
      fullAddress: fullAddress,
      latitude: latitude,
      longitude: longitude,
    );
  }
}

@JsonSerializable()
class PaymentDetailsModel {
  final String method;
  final String? cardLast4;
  final String? cardBrand;
  final String? transactionId;
  final String paymentStatus;
  final DateTime? paidAt;

  const PaymentDetailsModel({
    required this.method,
    this.cardLast4,
    this.cardBrand,
    this.transactionId,
    required this.paymentStatus,
    this.paidAt,
  });

  factory PaymentDetailsModel.fromJson(Map<String, dynamic> json) =>
      _$PaymentDetailsModelFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentDetailsModelToJson(this);

  PaymentDetailsEntity toEntity() {
    return PaymentDetailsEntity(
      method: method,
      cardLast4: cardLast4,
      cardBrand: cardBrand,
      transactionId: transactionId,
      paymentStatus: paymentStatus,
      paidAt: paidAt,
    );
  }
}

