/// Payment Remote Datasource for QuickBite application
/// Handles API calls for payment operations
library;

import '../../../../core/constants/api_constants.dart';
import '../../../../core/services/api_client.dart';
import '../../../../core/utils/app_logger.dart';
import '../models/saved_card_model.dart';

abstract class PaymentRemoteDataSource {
  Future<List<SavedCardModel>> getSavedCards();
  Future<SavedCardModel> addSavedCard({
    required String cardLast4,
    required String cardBrand,
    required String cardHolderName,
    required String expiryMonth,
    required String expiryYear,
    bool isDefault = false,
  });
  Future<void> deleteSavedCard(String cardId);
  Future<SavedCardModel> setDefaultCard(String cardId);
  Future<Map<String, dynamic>> processPayment({
    required double amount,
    required String method,
    String? cardId,
  });
}

class PaymentRemoteDataSourceImpl implements PaymentRemoteDataSource {
  final ApiClient apiClient;

  PaymentRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<SavedCardModel>> getSavedCards() async {
    try {
      AppLogger.debug('Fetching saved cards');
      final response = await apiClient.get(ApiConstants.savedCardsEndpoint);

      if (response['success'] == true && response['data'] != null) {
        final List<dynamic> cardsJson = response['data']['cards'] ?? [];
        return cardsJson
            .map((json) => SavedCardModel.fromJson(json as Map<String, dynamic>))
            .toList();
      }

      return [];
    } catch (e, stackTrace) {
      AppLogger.error('Error fetching saved cards', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  @override
  Future<SavedCardModel> addSavedCard({
    required String cardLast4,
    required String cardBrand,
    required String cardHolderName,
    required String expiryMonth,
    required String expiryYear,
    bool isDefault = false,
  }) async {
    try {
      AppLogger.debug('Adding saved card');
      final response = await apiClient.post(
        ApiConstants.savedCardsEndpoint,
        body: {
          'cardLast4': cardLast4,
          'cardBrand': cardBrand,
          'cardHolderName': cardHolderName,
          'expiryMonth': expiryMonth,
          'expiryYear': expiryYear,
          'isDefault': isDefault,
        },
      );

      if (response['success'] == true && response['data'] != null) {
        return SavedCardModel.fromJson(response['data']['card'] as Map<String, dynamic>);
      }

      throw Exception('Failed to add card: Invalid response');
    } catch (e, stackTrace) {
      AppLogger.error('Error adding saved card', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  @override
  Future<void> deleteSavedCard(String cardId) async {
    try {
      AppLogger.debug('Deleting saved card: $cardId');
      final response = await apiClient.delete(
        ApiConstants.savedCardByIdEndpoint(cardId),
      );

      if (response['success'] != true) {
        throw Exception('Failed to delete card');
      }
    } catch (e, stackTrace) {
      AppLogger.error('Error deleting saved card', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  @override
  Future<SavedCardModel> setDefaultCard(String cardId) async {
    try {
      AppLogger.debug('Setting default card: $cardId');
      final response = await apiClient.patch(
        ApiConstants.setDefaultCardEndpoint(cardId),
        body: {},
      );

      if (response['success'] == true && response['data'] != null) {
        return SavedCardModel.fromJson(response['data']['card'] as Map<String, dynamic>);
      }

      throw Exception('Failed to set default card');
    } catch (e, stackTrace) {
      AppLogger.error('Error setting default card', error: e, stackTrace: stackTrace);
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
      AppLogger.debug('Processing payment: \$$amount via $method');
      final response = await apiClient.post(
        ApiConstants.processPaymentEndpoint,
        body: {
          'amount': amount,
          'method': method,
          if (cardId != null) 'cardId': cardId,
        },
      );

      if (response['success'] == true && response['data'] != null) {
        return response['data'] as Map<String, dynamic>;
      }

      throw Exception('Payment processing failed');
    } catch (e, stackTrace) {
      AppLogger.error('Error processing payment', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }
}

