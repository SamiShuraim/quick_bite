/// Order Repository Implementation for QuickBite application
library;

import '../../domain/entities/order_entity.dart';
import '../../domain/repositories/order_repository.dart';
import '../datasources/order_remote_datasource.dart';

class OrderRepositoryImpl implements OrderRepository {
  final OrderRemoteDataSource remoteDataSource;

  OrderRepositoryImpl({required this.remoteDataSource});

  @override
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
      final order = await remoteDataSource.createOrder(
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
      return order.toEntity();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<OrderEntity>> getUserOrders({
    String? status,
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final orders = await remoteDataSource.getUserOrders(
        status: status,
        page: page,
        limit: limit,
      );
      return orders.map((order) => order.toEntity()).toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<OrderEntity> getOrderById(String orderId) async {
    try {
      final order = await remoteDataSource.getOrderById(orderId);
      return order.toEntity();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<OrderEntity> cancelOrder(String orderId) async {
    try {
      final order = await remoteDataSource.cancelOrder(orderId);
      return order.toEntity();
    } catch (e) {
      rethrow;
    }
  }
}

