/// Payment Repository Interface for QuickBite application
library;

import '../entities/saved_card_entity.dart';

abstract class PaymentRepository {
  Future<List<SavedCardEntity>> getSavedCards();
  Future<SavedCardEntity> addSavedCard({
    required String cardLast4,
    required String cardBrand,
    required String cardHolderName,
    required String expiryMonth,
    required String expiryYear,
    bool isDefault = false,
  });
  Future<void> deleteSavedCard(String cardId);
  Future<SavedCardEntity> setDefaultCard(String cardId);
  Future<Map<String, dynamic>> processPayment({
    required double amount,
    required String method,
    String? cardId,
  });
}

