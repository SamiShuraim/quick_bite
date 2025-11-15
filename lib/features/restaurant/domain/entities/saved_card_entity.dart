/// Saved Card Entity for QuickBite application
library;

import 'package:equatable/equatable.dart';

class SavedCardEntity extends Equatable {
  final String id;
  final String cardLast4;
  final String cardBrand;
  final String cardHolderName;
  final String expiryMonth;
  final String expiryYear;
  final bool isDefault;
  final DateTime createdAt;
  final DateTime updatedAt;

  const SavedCardEntity({
    required this.id,
    required this.cardLast4,
    required this.cardBrand,
    required this.cardHolderName,
    required this.expiryMonth,
    required this.expiryYear,
    required this.isDefault,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        cardLast4,
        cardBrand,
        cardHolderName,
        expiryMonth,
        expiryYear,
        isDefault,
        createdAt,
        updatedAt,
      ];

  SavedCardEntity copyWith({
    String? id,
    String? cardLast4,
    String? cardBrand,
    String? cardHolderName,
    String? expiryMonth,
    String? expiryYear,
    bool? isDefault,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return SavedCardEntity(
      id: id ?? this.id,
      cardLast4: cardLast4 ?? this.cardLast4,
      cardBrand: cardBrand ?? this.cardBrand,
      cardHolderName: cardHolderName ?? this.cardHolderName,
      expiryMonth: expiryMonth ?? this.expiryMonth,
      expiryYear: expiryYear ?? this.expiryYear,
      isDefault: isDefault ?? this.isDefault,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

