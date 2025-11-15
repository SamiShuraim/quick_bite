/// Menu item entity for QuickBite application
library;

import 'package:equatable/equatable.dart';

class MenuItemEntity extends Equatable {
  final String id;
  final String restaurantId;
  final String name;
  final String description;
  final String imageUrl;
  final double price;
  final String category;
  final double rating;
  final int reviewCount;
  final bool isPopular;
  final bool isVegetarian;
  final List<String> ingredients;
  final List<CustomizationOption> customizations;

  const MenuItemEntity({
    required this.id,
    required this.restaurantId,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.price,
    required this.category,
    required this.rating,
    required this.reviewCount,
    this.isPopular = false,
    this.isVegetarian = false,
    required this.ingredients,
    this.customizations = const [],
  });

  @override
  List<Object?> get props => [
        id,
        restaurantId,
        name,
        description,
        imageUrl,
        price,
        category,
        rating,
        reviewCount,
        isPopular,
        isVegetarian,
        ingredients,
        customizations,
      ];
}

class CustomizationOption extends Equatable {
  final String id;
  final String name;
  final List<CustomizationChoice> choices;
  final bool isRequired;
  final int maxSelections;

  const CustomizationOption({
    required this.id,
    required this.name,
    required this.choices,
    this.isRequired = false,
    this.maxSelections = 1,
  });

  @override
  List<Object?> get props => [id, name, choices, isRequired, maxSelections];
}

class CustomizationChoice extends Equatable {
  final String id;
  final String name;
  final double additionalPrice;

  const CustomizationChoice({
    required this.id,
    required this.name,
    this.additionalPrice = 0.0,
  });

  @override
  List<Object?> get props => [id, name, additionalPrice];
}

