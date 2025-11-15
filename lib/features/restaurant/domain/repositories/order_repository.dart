/// Order Repository Interface for QuickBite application
library;

import '../entities/order_entity.dart';

abstract class OrderRepository {
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
  });
  Future<List<OrderEntity>> getUserOrders({
    String? status,
    int page = 1,
    int limit = 10,
  });
  Future<OrderEntity> getOrderById(String orderId);
  Future<OrderEntity> cancelOrder(String orderId);
}

