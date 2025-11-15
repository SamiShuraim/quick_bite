/// Restaurant model for API communication
library;

import '../../domain/entities/restaurant_entity.dart';

class RestaurantModel extends RestaurantEntity {
  const RestaurantModel({
    required super.id,
    required super.name,
    required super.description,
    required super.imageUrl,
    required super.rating,
    required super.reviewCount,
    required super.deliveryTime,
    required super.deliveryFee,
    required super.categories,
    super.isFreeDelivery,
    super.isPopular,
    required super.address,
    required super.distance,
  });

  factory RestaurantModel.fromJson(Map<String, dynamic> json) {
    return RestaurantModel(
      id: json['_id'] as String? ?? json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      imageUrl: json['imageUrl'] as String,
      rating: (json['rating'] as num).toDouble(),
      reviewCount: json['reviewCount'] as int,
      deliveryTime: json['deliveryTime'] as int,
      deliveryFee: (json['deliveryFee'] as num).toDouble(),
      categories: (json['categories'] as List<dynamic>).cast<String>(),
      isFreeDelivery: json['isFreeDelivery'] as bool? ?? false,
      isPopular: json['isPopular'] as bool? ?? false,
      address: json['address'] as String,
      distance: (json['distance'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'rating': rating,
      'reviewCount': reviewCount,
      'deliveryTime': deliveryTime,
      'deliveryFee': deliveryFee,
      'categories': categories,
      'isFreeDelivery': isFreeDelivery,
      'isPopular': isPopular,
      'address': address,
      'distance': distance,
    };
  }

  RestaurantEntity toEntity() {
    return RestaurantEntity(
      id: id,
      name: name,
      description: description,
      imageUrl: imageUrl,
      rating: rating,
      reviewCount: reviewCount,
      deliveryTime: deliveryTime,
      deliveryFee: deliveryFee,
      categories: categories,
      isFreeDelivery: isFreeDelivery,
      isPopular: isPopular,
      address: address,
      distance: distance,
    );
  }
}

