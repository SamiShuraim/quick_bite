/// Order Provider for QuickBite application
/// Manages order state
library;

import 'package:flutter/foundation.dart';
import '../../domain/entities/order_entity.dart';
import '../../domain/repositories/order_repository.dart';
import '../../../../core/utils/app_logger.dart';

class OrderProvider with ChangeNotifier {
  final OrderRepository _orderRepository;

  OrderProvider({required OrderRepository orderRepository})
      : _orderRepository = orderRepository;

  List<OrderEntity> _orders = [];
  OrderEntity? _currentOrder;
  bool _isLoading = false;
  String? _error;

  List<OrderEntity> get orders => _orders;
  OrderEntity? get currentOrder => _currentOrder;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Create a new order
  Future<OrderEntity> createOrder({
    required String restaurantId,
    required List<Map<String, dynamic>> items,
    required Map<String, dynamic> deliveryAddress,
    required Map<String, dynamic> paymentDetails,
    required double subtotal,
    required double deliveryFee,
    required double tax,
    required double total,
    String? specialInstructions,
  }) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final order = await _orderRepository.createOrder(
        restaurantId: restaurantId,
        items: items,
        deliveryAddress: deliveryAddress,
        paymentDetails: paymentDetails,
        subtotal: subtotal,
        deliveryFee: deliveryFee,
        tax: tax,
        total: total,
        specialInstructions: specialInstructions,
      );

      _currentOrder = order;
      _orders.insert(0, order); // Add to beginning of list

      AppLogger.info('Order created: ${order.orderNumber}');

      _isLoading = false;
      notifyListeners();

      return order;
    } catch (e, stackTrace) {
      _isLoading = false;
      _error = e.toString();
      AppLogger.error('Error creating order', error: e, stackTrace: stackTrace);
      notifyListeners();
      rethrow;
    }
  }

  /// Fetch all user orders
  Future<void> fetchUserOrders({
    String? status,
    int page = 1,
    int limit = 10,
  }) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _orders = await _orderRepository.getUserOrders(
        status: status,
        page: page,
        limit: limit,
      );

      AppLogger.info('Fetched ${_orders.length} orders');

      _isLoading = false;
      notifyListeners();
    } catch (e, stackTrace) {
      _isLoading = false;
      _error = e.toString();
      AppLogger.error('Error fetching user orders', error: e, stackTrace: stackTrace);
      notifyListeners();
      rethrow;
    }
  }

  /// Fetch order by ID
  Future<OrderEntity> fetchOrderById(String orderId) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final order = await _orderRepository.getOrderById(orderId);
      _currentOrder = order;

      AppLogger.info('Fetched order: ${order.orderNumber}');

      _isLoading = false;
      notifyListeners();

      return order;
    } catch (e, stackTrace) {
      _isLoading = false;
      _error = e.toString();
      AppLogger.error('Error fetching order', error: e, stackTrace: stackTrace);
      notifyListeners();
      rethrow;
    }
  }

  /// Cancel an order
  Future<OrderEntity> cancelOrder(String orderId) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final order = await _orderRepository.cancelOrder(orderId);

      // Update local list
      final index = _orders.indexWhere((o) => o.id == orderId);
      if (index >= 0) {
        _orders[index] = order;
      }

      if (_currentOrder?.id == orderId) {
        _currentOrder = order;
      }

      AppLogger.info('Order cancelled: ${order.orderNumber}');

      _isLoading = false;
      notifyListeners();

      return order;
    } catch (e, stackTrace) {
      _isLoading = false;
      _error = e.toString();
      AppLogger.error('Error cancelling order', error: e, stackTrace: stackTrace);
      notifyListeners();
      rethrow;
    }
  }

  /// Clear current order
  void clearCurrentOrder() {
    _currentOrder = null;
    notifyListeners();
  }

  /// Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }
}

