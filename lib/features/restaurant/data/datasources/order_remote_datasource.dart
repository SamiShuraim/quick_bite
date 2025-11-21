/// Order Remote Datasource for QuickBite application
/// Handles API calls for order operations
library;

import '../../../../core/constants/api_constants.dart';
import '../../../../core/services/api_client.dart';
import '../../../../core/utils/app_logger.dart';
import '../models/order_model.dart';

abstract class OrderRemoteDataSource {
  Future<OrderModel> createOrder({
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
  Future<List<OrderModel>> getUserOrders({
    String? status,
    int page = 1,
    int limit = 10,
  });
  Future<OrderModel> getOrderById(String orderId);
  Future<OrderModel> cancelOrder(String orderId);
}

class OrderRemoteDataSourceImpl implements OrderRemoteDataSource {
  final ApiClient apiClient;

  OrderRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<OrderModel> createOrder({
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
      AppLogger.debug('Creating order for restaurant: $restaurantId');
      final response = await apiClient.post(
        ApiConstants.ordersEndpoint,
        body: {
          'restaurantId': restaurantId,
          'items': items,
          'deliveryAddress': deliveryAddress,
          'paymentDetails': paymentDetails,
          'subtotal': subtotal,
          'deliveryFee': deliveryFee,
          'tax': tax,
          'total': total,
          if (specialInstructions != null) 'specialInstructions': specialInstructions,
        },
      );

      if (response['success'] == true && response['data'] != null) {
        final orderData = response['data']['order'] as Map<String, dynamic>;
        // The response might have partial order data, fetch full order
        return getOrderById(orderData['_id'] as String);
      }

      throw Exception('Failed to create order: Invalid response');
    } catch (e, stackTrace) {
      AppLogger.error('Error creating order', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  @override
  Future<List<OrderModel>> getUserOrders({
    String? status,
    int page = 1,
    int limit = 10,
  }) async {
    try {
      AppLogger.debug('Fetching user orders');
      final queryParams = <String, String>{
        'page': page.toString(),
        'limit': limit.toString(),
        if (status != null) 'status': status,
      };

      final endpoint = ApiConstants.ordersEndpoint +
          '?' +
          queryParams.entries.map((e) => '${e.key}=${e.value}').join('&');

      final response = await apiClient.get(endpoint);

      if (response['success'] == true && response['data'] != null) {
        final List<dynamic> ordersJson = response['data']['orders'] ?? [];
        return ordersJson
            .map((json) => OrderModel.fromJson(json as Map<String, dynamic>))
            .toList();
      }

      return [];
    } catch (e, stackTrace) {
      AppLogger.error('Error fetching user orders', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  @override
  Future<OrderModel> getOrderById(String orderId) async {
    try {
      AppLogger.debug('Fetching order: $orderId');
      final response = await apiClient.get(
        ApiConstants.orderByIdEndpoint(orderId),
      );

      if (response['success'] == true && response['data'] != null) {
        return OrderModel.fromJson(response['data']['order'] as Map<String, dynamic>);
      }

      throw Exception('Failed to fetch order');
    } catch (e, stackTrace) {
      AppLogger.error('Error fetching order', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  @override
  Future<OrderModel> cancelOrder(String orderId) async {
    try {
      AppLogger.debug('Cancelling order: $orderId');
      final response = await apiClient.patch(
        ApiConstants.cancelOrderEndpoint(orderId),
        body: {},
      );

      if (response['success'] == true && response['data'] != null) {
        return OrderModel.fromJson(response['data']['order'] as Map<String, dynamic>);
      }

      throw Exception('Failed to cancel order');
    } catch (e, stackTrace) {
      AppLogger.error('Error cancelling order', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }
}

