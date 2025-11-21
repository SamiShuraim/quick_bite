/// Payment Provider for QuickBite application
/// Manages payment and saved card state
library;

import 'package:flutter/foundation.dart';
import '../../domain/entities/saved_card_entity.dart';
import '../../domain/repositories/payment_repository.dart';
import '../../../../core/utils/app_logger.dart';

class PaymentProvider with ChangeNotifier {
  final PaymentRepository _paymentRepository;

  PaymentProvider({required PaymentRepository paymentRepository})
      : _paymentRepository = paymentRepository;

  List<SavedCardEntity> _savedCards = [];
  bool _isLoading = false;
  String? _error;
  Map<String, dynamic>? _lastPaymentResult;

  List<SavedCardEntity> get savedCards => _savedCards;
  bool get isLoading => _isLoading;
  String? get error => _error;
  Map<String, dynamic>? get lastPaymentResult => _lastPaymentResult;

  SavedCardEntity? get defaultCard {
    try {
      return _savedCards.firstWhere((card) => card.isDefault);
    } catch (e) {
      return _savedCards.isNotEmpty ? _savedCards.first : null;
    }
  }

  bool get hasCards => _savedCards.isNotEmpty;

  /// Fetch all saved cards
  Future<void> fetchSavedCards() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _savedCards = await _paymentRepository.getSavedCards();
      
      AppLogger.info('Fetched ${_savedCards.length} saved cards');
      
      _isLoading = false;
      notifyListeners();
    } catch (e, stackTrace) {
      _isLoading = false;
      _error = e.toString();
      AppLogger.error('Error fetching saved cards', error: e, stackTrace: stackTrace);
      notifyListeners();
      rethrow;
    }
  }

  /// Add a new saved card
  Future<SavedCardEntity> addSavedCard({
    required String cardNumber,
    required String cardBrand,
    required String cardHolderName,
    required String expiryDate,
    required String cvv,
    bool isDefault = false,
  }) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      // Extract last 4 digits
      final cleanedCardNumber = cardNumber.replaceAll(' ', '');
      final cardLast4 = cleanedCardNumber.substring(cleanedCardNumber.length - 4);

      // Parse expiry date (format: MM/YY)
      final expiryParts = expiryDate.split('/');
      final expiryMonth = expiryParts[0].padLeft(2, '0');
      final expiryYear = '20${expiryParts[1]}';

      final card = await _paymentRepository.addSavedCard(
        cardLast4: cardLast4,
        cardBrand: cardBrand.toLowerCase(),
        cardHolderName: cardHolderName.toUpperCase(),
        expiryMonth: expiryMonth,
        expiryYear: expiryYear,
        isDefault: isDefault,
      );

      // Refresh cards list
      await fetchSavedCards();

      AppLogger.info('Card added successfully');

      _isLoading = false;
      notifyListeners();

      return card;
    } catch (e, stackTrace) {
      _isLoading = false;
      _error = e.toString();
      AppLogger.error('Error adding saved card', error: e, stackTrace: stackTrace);
      notifyListeners();
      rethrow;
    }
  }

  /// Delete a saved card
  Future<void> deleteSavedCard(String cardId) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _paymentRepository.deleteSavedCard(cardId);

      // Remove from local list
      _savedCards.removeWhere((card) => card.id == cardId);

      AppLogger.info('Card deleted successfully');

      _isLoading = false;
      notifyListeners();
    } catch (e, stackTrace) {
      _isLoading = false;
      _error = e.toString();
      AppLogger.error('Error deleting saved card', error: e, stackTrace: stackTrace);
      notifyListeners();
      rethrow;
    }
  }

  /// Set a card as default
  Future<void> setDefaultCard(String cardId) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _paymentRepository.setDefaultCard(cardId);

      // Refresh cards list
      await fetchSavedCards();

      AppLogger.info('Default card updated');

      _isLoading = false;
      notifyListeners();
    } catch (e, stackTrace) {
      _isLoading = false;
      _error = e.toString();
      AppLogger.error('Error setting default card', error: e, stackTrace: stackTrace);
      notifyListeners();
      rethrow;
    }
  }

  /// Process payment
  Future<Map<String, dynamic>> processPayment({
    required double amount,
    required String method,
    String? cardId,
  }) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final result = await _paymentRepository.processPayment(
        amount: amount,
        method: method,
        cardId: cardId,
      );

      _lastPaymentResult = result;

      AppLogger.info('Payment processed successfully: ${result['transactionId']}');

      _isLoading = false;
      notifyListeners();

      return result;
    } catch (e, stackTrace) {
      _isLoading = false;
      _error = e.toString();
      AppLogger.error('Error processing payment', error: e, stackTrace: stackTrace);
      notifyListeners();
      rethrow;
    }
  }

  /// Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }

  /// Clear last payment result
  void clearLastPaymentResult() {
    _lastPaymentResult = null;
    notifyListeners();
  }
}

