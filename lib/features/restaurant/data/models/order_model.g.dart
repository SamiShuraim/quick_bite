// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderModel _$OrderModelFromJson(Map<String, dynamic> json) => OrderModel(
  id: json['_id'] as String,
  orderNumber: json['orderNumber'] as String,
  restaurantId: json['restaurantId'] as String,
  restaurantName: json['restaurantName'] as String,
  items: (json['items'] as List<dynamic>)
      .map((e) => OrderItemModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  deliveryAddress: DeliveryAddressModel.fromJson(
    json['deliveryAddress'] as Map<String, dynamic>,
  ),
  paymentDetails: PaymentDetailsModel.fromJson(
    json['paymentDetails'] as Map<String, dynamic>,
  ),
  subtotal: (json['subtotal'] as num).toDouble(),
  deliveryFee: (json['deliveryFee'] as num).toDouble(),
  tax: (json['tax'] as num).toDouble(),
  total: (json['total'] as num).toDouble(),
  status: json['status'] as String,
  estimatedDeliveryTime: DateTime.parse(
    json['estimatedDeliveryTime'] as String,
  ),
  specialInstructions: json['specialInstructions'] as String?,
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$OrderModelToJson(OrderModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'orderNumber': instance.orderNumber,
      'restaurantId': instance.restaurantId,
      'restaurantName': instance.restaurantName,
      'items': instance.items.map((e) => e.toJson()).toList(),
      'deliveryAddress': instance.deliveryAddress.toJson(),
      'paymentDetails': instance.paymentDetails.toJson(),
      'subtotal': instance.subtotal,
      'deliveryFee': instance.deliveryFee,
      'tax': instance.tax,
      'total': instance.total,
      'status': instance.status,
      'estimatedDeliveryTime': instance.estimatedDeliveryTime.toIso8601String(),
      'specialInstructions': instance.specialInstructions,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

OrderItemModel _$OrderItemModelFromJson(Map<String, dynamic> json) =>
    OrderItemModel(
      menuItemId: json['menuItemId'] as String,
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(),
      quantity: (json['quantity'] as num).toInt(),
      imageUrl: json['imageUrl'] as String,
      customizations: (json['customizations'] as List<dynamic>?)
          ?.map(
            (e) => OrderCustomizationModel.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
      subtotal: (json['subtotal'] as num).toDouble(),
    );

Map<String, dynamic> _$OrderItemModelToJson(
  OrderItemModel instance,
) => <String, dynamic>{
  'menuItemId': instance.menuItemId,
  'name': instance.name,
  'price': instance.price,
  'quantity': instance.quantity,
  'imageUrl': instance.imageUrl,
  'customizations': instance.customizations?.map((e) => e.toJson()).toList(),
  'subtotal': instance.subtotal,
};

OrderCustomizationModel _$OrderCustomizationModelFromJson(
  Map<String, dynamic> json,
) => OrderCustomizationModel(
  optionName: json['optionName'] as String,
  choices: (json['choices'] as List<dynamic>).map((e) => e as String).toList(),
);

Map<String, dynamic> _$OrderCustomizationModelToJson(
  OrderCustomizationModel instance,
) => <String, dynamic>{
  'optionName': instance.optionName,
  'choices': instance.choices,
};

DeliveryAddressModel _$DeliveryAddressModelFromJson(
  Map<String, dynamic> json,
) => DeliveryAddressModel(
  street: json['street'] as String,
  city: json['city'] as String,
  state: json['state'] as String,
  zipCode: json['zipCode'] as String,
  country: json['country'] as String,
  fullAddress: json['fullAddress'] as String,
  latitude: (json['latitude'] as num?)?.toDouble(),
  longitude: (json['longitude'] as num?)?.toDouble(),
);

Map<String, dynamic> _$DeliveryAddressModelToJson(
  DeliveryAddressModel instance,
) => <String, dynamic>{
  'street': instance.street,
  'city': instance.city,
  'state': instance.state,
  'zipCode': instance.zipCode,
  'country': instance.country,
  'fullAddress': instance.fullAddress,
  'latitude': instance.latitude,
  'longitude': instance.longitude,
};

PaymentDetailsModel _$PaymentDetailsModelFromJson(Map<String, dynamic> json) =>
    PaymentDetailsModel(
      method: json['method'] as String,
      cardLast4: json['cardLast4'] as String?,
      cardBrand: json['cardBrand'] as String?,
      transactionId: json['transactionId'] as String?,
      paymentStatus: json['paymentStatus'] as String,
      paidAt: json['paidAt'] == null
          ? null
          : DateTime.parse(json['paidAt'] as String),
    );

Map<String, dynamic> _$PaymentDetailsModelToJson(
  PaymentDetailsModel instance,
) => <String, dynamic>{
  'method': instance.method,
  'cardLast4': instance.cardLast4,
  'cardBrand': instance.cardBrand,
  'transactionId': instance.transactionId,
  'paymentStatus': instance.paymentStatus,
  'paidAt': instance.paidAt?.toIso8601String(),
};
