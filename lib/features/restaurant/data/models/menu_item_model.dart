/// Menu item model for API communication
library;

import '../../domain/entities/menu_item_entity.dart';

class MenuItemModel extends MenuItemEntity {
  const MenuItemModel({
    required super.id,
    required super.restaurantId,
    required super.name,
    required super.description,
    required super.imageUrl,
    required super.price,
    required super.category,
    required super.rating,
    required super.reviewCount,
    super.isPopular,
    super.isVegetarian,
    required super.ingredients,
    super.customizations,
  });

  factory MenuItemModel.fromJson(Map<String, dynamic> json) {
    return MenuItemModel(
      id: json['_id'] as String? ?? json['id'] as String,
      restaurantId: json['restaurantId'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      imageUrl: json['imageUrl'] as String,
      price: (json['price'] as num).toDouble(),
      category: json['category'] as String,
      rating: (json['rating'] as num).toDouble(),
      reviewCount: json['reviewCount'] as int,
      isPopular: json['isPopular'] as bool? ?? false,
      isVegetarian: json['isVegetarian'] as bool? ?? false,
      ingredients: (json['ingredients'] as List<dynamic>).cast<String>(),
      customizations: (json['customizations'] as List<dynamic>?)
              ?.map((c) => CustomizationOption(
                    id: c['id'] as String,
                    name: c['name'] as String,
                    choices: (c['choices'] as List<dynamic>)
                        .map((choice) => CustomizationChoice(
                              id: choice['id'] as String,
                              name: choice['name'] as String,
                              additionalPrice:
                                  (choice['additionalPrice'] as num).toDouble(),
                            ))
                        .toList(),
                    isRequired: c['isRequired'] as bool? ?? false,
                    maxSelections: c['maxSelections'] as int? ?? 1,
                  ))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'restaurantId': restaurantId,
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'price': price,
      'category': category,
      'rating': rating,
      'reviewCount': reviewCount,
      'isPopular': isPopular,
      'isVegetarian': isVegetarian,
      'ingredients': ingredients,
      'customizations': customizations.map((c) => {
        'id': c.id,
        'name': c.name,
        'choices': c.choices.map((choice) => {
          'id': choice.id,
          'name': choice.name,
          'additionalPrice': choice.additionalPrice,
        }).toList(),
        'isRequired': c.isRequired,
        'maxSelections': c.maxSelections,
      }).toList(),
    };
  }

  MenuItemEntity toEntity() {
    return MenuItemEntity(
      id: id,
      restaurantId: restaurantId,
      name: name,
      description: description,
      imageUrl: imageUrl,
      price: price,
      category: category,
      rating: rating,
      reviewCount: reviewCount,
      isPopular: isPopular,
      isVegetarian: isVegetarian,
      ingredients: ingredients,
      customizations: customizations,
    );
  }
}

