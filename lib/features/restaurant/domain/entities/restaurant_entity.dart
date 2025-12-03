/// Restaurant entity for QuickBite application
library;

import 'package:equatable/equatable.dart';

class RestaurantEntity extends Equatable {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final double rating;
  final int reviewCount;
  final int deliveryTime; // in minutes
  final double deliveryFee;
  final List<String> categories;
  final bool isFreeDelivery;
  final bool isPopular;
  final bool hasVegetarianOptions;
  final String address;
  final double distance; // in km

  const RestaurantEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.rating,
    required this.reviewCount,
    required this.deliveryTime,
    required this.deliveryFee,
    required this.categories,
    this.isFreeDelivery = false,
    this.isPopular = false,
    this.hasVegetarianOptions = false,
    required this.address,
    required this.distance,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        imageUrl,
        rating,
        reviewCount,
        deliveryTime,
        deliveryFee,
        categories,
        isFreeDelivery,
        isPopular,
        hasVegetarianOptions,
        address,
        distance,
      ];
}

