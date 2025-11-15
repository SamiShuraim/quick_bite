// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'saved_card_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SavedCardModel _$SavedCardModelFromJson(Map<String, dynamic> json) =>
    SavedCardModel(
      modelId: json['_id'] as String,
      cardLast4: json['cardLast4'] as String,
      cardBrand: json['cardBrand'] as String,
      cardHolderName: json['cardHolderName'] as String,
      expiryMonth: json['expiryMonth'] as String,
      expiryYear: json['expiryYear'] as String,
      isDefault: json['isDefault'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$SavedCardModelToJson(SavedCardModel instance) =>
    <String, dynamic>{
      'cardLast4': instance.cardLast4,
      'cardBrand': instance.cardBrand,
      'cardHolderName': instance.cardHolderName,
      'expiryMonth': instance.expiryMonth,
      'expiryYear': instance.expiryYear,
      'isDefault': instance.isDefault,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      '_id': instance.modelId,
    };
