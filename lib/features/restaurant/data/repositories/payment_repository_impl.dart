/// Payment Repository Implementation for QuickBite application
library;

import '../../domain/entities/saved_card_entity.dart';
import '../../domain/repositories/payment_repository.dart';
import '../datasources/payment_remote_datasource.dart';

class PaymentRepositoryImpl implements PaymentRepository {
  final PaymentRemoteDataSource remoteDataSource;

  PaymentRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<SavedCardEntity>> getSavedCards() async {
    try {
      final cards = await remoteDataSource.getSavedCards();
      return cards.map((card) => card.toEntity()).toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<SavedCardEntity> addSavedCard({
    required String cardLast4,
    required String cardBrand,
    required String cardHolderName,
    required String expiryMonth,
    required String expiryYear,
    bool isDefault = false,
  }) async {
    try {
      final card = await remoteDataSource.addSavedCard(
        cardLast4: cardLast4,
        cardBrand: cardBrand,
        cardHolderName: cardHolderName,
        expiryMonth: expiryMonth,
        expiryYear: expiryYear,
        isDefault: isDefault,
      );
      return card.toEntity();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> deleteSavedCard(String cardId) async {
    try {
      await remoteDataSource.deleteSavedCard(cardId);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<SavedCardEntity> setDefaultCard(String cardId) async {
    try {
      final card = await remoteDataSource.setDefaultCard(cardId);
      return card.toEntity();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> processPayment({
    required double amount,
    required String method,
    String? cardId,
  }) async {
    try {
      return await remoteDataSource.processPayment(
        amount: amount,
        method: method,
        cardId: cardId,
      );
    } catch (e) {
      rethrow;
    }
  }
}

