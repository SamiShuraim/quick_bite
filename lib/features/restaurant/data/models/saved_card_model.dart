/// Saved Card Model for QuickBite application
library;

import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/saved_card_entity.dart';

part 'saved_card_model.g.dart';

@JsonSerializable()
class SavedCardModel extends SavedCardEntity {
  @JsonKey(name: '_id')
  final String modelId;

  const SavedCardModel({
    required this.modelId,
    required super.cardLast4,
    required super.cardBrand,
    required super.cardHolderName,
    required super.expiryMonth,
    required super.expiryYear,
    required super.isDefault,
    required super.createdAt,
    required super.updatedAt,
  }) : super(id: modelId);

  factory SavedCardModel.fromJson(Map<String, dynamic> json) =>
      _$SavedCardModelFromJson(json);

  Map<String, dynamic> toJson() => _$SavedCardModelToJson(this);

  factory SavedCardModel.fromEntity(SavedCardEntity entity) {
    return SavedCardModel(
      modelId: entity.id,
      cardLast4: entity.cardLast4,
      cardBrand: entity.cardBrand,
      cardHolderName: entity.cardHolderName,
      expiryMonth: entity.expiryMonth,
      expiryYear: entity.expiryYear,
      isDefault: entity.isDefault,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  SavedCardEntity toEntity() {
    return SavedCardEntity(
      id: modelId,
      cardLast4: cardLast4,
      cardBrand: cardBrand,
      cardHolderName: cardHolderName,
      expiryMonth: expiryMonth,
      expiryYear: expiryYear,
      isDefault: isDefault,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}

