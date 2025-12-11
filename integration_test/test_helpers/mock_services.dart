/// Mock services for integration tests
/// Provides fake implementations that don't require a running backend
library;

import 'package:http/http.dart' as http;
import 'package:quick_bite/features/authentication/data/datasources/auth_remote_datasource.dart';
import 'package:quick_bite/features/authentication/data/models/auth_response_model.dart';
import 'package:quick_bite/features/authentication/data/models/user_model.dart';
import 'package:quick_bite/features/restaurant/data/datasources/restaurant_remote_datasource.dart';
import 'package:quick_bite/features/restaurant/data/datasources/payment_remote_datasource.dart';
import 'package:quick_bite/features/restaurant/data/datasources/order_remote_datasource.dart';
import 'package:quick_bite/features/restaurant/data/models/restaurant_model.dart';
import 'package:quick_bite/features/restaurant/data/models/menu_item_model.dart';
import 'package:quick_bite/features/restaurant/data/models/order_model.dart';
import 'package:quick_bite/features/restaurant/data/models/saved_card_model.dart';

/// Mock HTTP Client that always returns success
class MockHttpClient extends http.BaseClient {
  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    await Future.delayed(const Duration(milliseconds: 500));

    if (request.url.path.contains('/health')) {
      return http.StreamedResponse(
        Stream.value([]),
        200,
        headers: {'content-type': 'application/json'},
      );
    }

    return http.StreamedResponse(
      Stream.value([]),
      200,
      headers: {'content-type': 'application/json'},
    );
  }
}

/// Mock Auth Remote Data Source
class MockAuthRemoteDataSource implements AuthRemoteDataSource {
  @override
  Future<AuthResponseModel> login({
    required String email,
    required String password,
  }) async {
    await Future.delayed(const Duration(seconds: 1));

    return AuthResponseModel(
      success: true,
      message: 'Login successful',
      data: AuthDataModel(
        user: UserModel(
          id: 'test-user-id',
          email: email,
          name: 'Test User',
          phone: '+1234567890',
          role: 'user',
          isEmailVerified: true,
          createdAt: DateTime.now(),
        ),
        tokens: const TokensModel(
          accessToken: 'mock-access-token',
          refreshToken: 'mock-refresh-token',
        ),
      ),
    );
  }

  @override
  Future<AuthResponseModel> register({
    required String email,
    required String password,
    required String name,
    String? phone,
  }) async {
    await Future.delayed(const Duration(seconds: 1));

    return AuthResponseModel(
      success: true,
      message: 'Registration successful',
      data: AuthDataModel(
        user: UserModel(
          id: 'test-user-id',
          email: email,
          name: name,
          phone: phone,
          role: 'user',
          isEmailVerified: true,
          createdAt: DateTime.now(),
        ),
        tokens: const TokensModel(
          accessToken: 'mock-access-token',
          refreshToken: 'mock-refresh-token',
        ),
      ),
    );
  }

  @override
  Future<void> logout(String refreshToken) async {
    await Future.delayed(const Duration(milliseconds: 500));
  }

  @override
  Future<TokensModel> refreshToken(String refreshToken) async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    return const TokensModel(
      accessToken: 'mock-access-token-refreshed',
      refreshToken: 'mock-refresh-token-refreshed',
    );
  }

  @override
  Future<UserModel> getProfile() async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    return UserModel(
      id: 'test-user-id',
      email: 'test@example.com',
      name: 'Test User',
      phone: '+1234567890',
      role: 'user',
      isEmailVerified: true,
      createdAt: DateTime.now(),
    );
  }
}

/// Mock Restaurant Remote Data Source
class MockRestaurantRemoteDataSource implements RestaurantRemoteDataSource {
  @override
  Future<List<RestaurantModel>> getRestaurants({
    String? category,
    String? search,
    double? minRating,
    double? maxDistance,
  }) async {
    await Future.delayed(const Duration(seconds: 1));

    return [
      RestaurantModel(
        id: 'rest-1',
        name: 'Burger Palace',
        description: 'Best burgers in town',
        imageUrl: 'https://via.placeholder.com/300',
        rating: 4.5,
        reviewCount: 100,
        deliveryTime: 30,
        deliveryFee: 5.0,
        categories: const ['Fast Food', 'Burgers'],
        address: '123 Main St',
        distance: 2.5,
        isFreeDelivery: false,
      ),
      RestaurantModel(
        id: 'rest-2',
        name: 'Pizza House',
        description: 'Authentic Italian pizza',
        imageUrl: 'https://via.placeholder.com/300',
        rating: 4.8,
        reviewCount: 200,
        deliveryTime: 40,
        deliveryFee: 7.0,
        categories: const ['Italian', 'Pizza'],
        address: '456 Oak Ave',
        distance: 3.2,
        isFreeDelivery: false,
      ),
    ];
  }

  @override
  Future<RestaurantModel> getRestaurantById(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));

    return RestaurantModel(
      id: id,
      name: 'Burger Palace',
      description: 'Best burgers in town',
      imageUrl: 'https://via.placeholder.com/300',
      rating: 4.5,
      reviewCount: 100,
      deliveryTime: 30,
      deliveryFee: 5.0,
      categories: const ['Fast Food', 'Burgers'],
      address: '123 Main St',
      distance: 2.5,
      isFreeDelivery: false,
    );
  }

  @override
  Future<List<MenuItemModel>> getMenuItems({
    required String restaurantId,
    String? category,
  }) async {
    await Future.delayed(const Duration(seconds: 1));

    return [
      MenuItemModel(
        id: 'item-1',
        restaurantId: restaurantId,
        name: 'Classic Burger',
        description: 'Juicy beef patty with cheese',
        imageUrl: 'https://via.placeholder.com/200',
        price: 25.0,
        category: 'Burgers',
        rating: 4.5,
        reviewCount: 50,
        ingredients: const ['beef', 'cheese', 'lettuce', 'tomato'],
      ),
      MenuItemModel(
        id: 'item-2',
        restaurantId: restaurantId,
        name: 'Chicken Burger',
        description: 'Grilled chicken with special sauce',
        imageUrl: 'https://via.placeholder.com/200',
        price: 22.0,
        category: 'Burgers',
        rating: 4.3,
        reviewCount: 30,
        ingredients: const ['chicken', 'lettuce', 'mayo'],
      ),
    ];
  }

  @override
  Future<MenuItemModel> getMenuItemById(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));

    return MenuItemModel(
      id: id,
      restaurantId: 'rest-1',
      name: 'Classic Burger',
      description: 'Juicy beef patty with cheese',
      imageUrl: 'https://via.placeholder.com/200',
      price: 25.0,
      category: 'Burgers',
      rating: 4.5,
      reviewCount: 50,
      ingredients: const ['beef', 'cheese', 'lettuce', 'tomato'],
    );
  }
}

/// Mock Payment Remote Data Source
class MockPaymentRemoteDataSource implements PaymentRemoteDataSource {
  @override
  Future<List<SavedCardModel>> getSavedCards() async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    return [
      SavedCardModel(
        modelId: 'card-1',
        cardLast4: '1234',
        cardBrand: 'Visa',
        cardHolderName: 'Test User',
        expiryMonth: '12',
        expiryYear: '2025',
        isDefault: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    ];
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
    await Future.delayed(const Duration(seconds: 1));
    
    return SavedCardModel(
      modelId: 'card-new',
      cardLast4: cardLast4,
      cardBrand: cardBrand,
      cardHolderName: cardHolderName,
      expiryMonth: expiryMonth,
      expiryYear: expiryYear,
      isDefault: isDefault,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  @override
  Future<void> deleteSavedCard(String cardId) async {
    await Future.delayed(const Duration(milliseconds: 500));
  }

  @override
  Future<SavedCardModel> setDefaultCard(String cardId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    return SavedCardModel(
      modelId: cardId,
      cardLast4: '1234',
      cardBrand: 'Visa',
      cardHolderName: 'Test User',
      expiryMonth: '12',
      expiryYear: '2025',
      isDefault: true,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  @override
  Future<Map<String, dynamic>> processPayment({
    required double amount,
    required String method,
    String? cardId,
  }) async {
    await Future.delayed(const Duration(seconds: 2));
    
    return {
      'success': true,
      'transactionId': 'txn-${DateTime.now().millisecondsSinceEpoch}',
      'message': 'Payment processed successfully',
    };
  }
}

/// Mock Order Remote Data Source
class MockOrderRemoteDataSource implements OrderRemoteDataSource {
  final List<OrderModel> _orders = [];

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
    await Future.delayed(const Duration(seconds: 1));

    final order = OrderModel(
      id: 'order-${DateTime.now().millisecondsSinceEpoch}',
      orderNumber: 'ORD-${DateTime.now().millisecondsSinceEpoch}',
      restaurantId: restaurantId,
      restaurantName: 'Burger Palace',
      items: items.map((item) => OrderItemModel.fromJson(item)).toList(),
      deliveryAddress: DeliveryAddressModel.fromJson(deliveryAddress),
      paymentDetails: PaymentDetailsModel.fromJson(paymentDetails),
      subtotal: subtotal,
      deliveryFee: deliveryFee,
      tax: tax,
      total: total,
      status: 'pending',
      estimatedDeliveryTime: DateTime.now().add(const Duration(minutes: 30)),
      specialInstructions: specialInstructions,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    _orders.add(order);
    return order;
  }

  @override
  Future<List<OrderModel>> getUserOrders({
    String? status,
    int page = 1,
    int limit = 10,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    var filteredOrders = List<OrderModel>.from(_orders);
    
    if (status != null) {
      filteredOrders = filteredOrders.where((order) => order.status == status).toList();
    }
    
    return filteredOrders;
  }

  @override
  Future<OrderModel> getOrderById(String orderId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    try {
      return _orders.firstWhere((order) => order.id == orderId);
    } catch (e) {
      // Return a mock order if not found
      return OrderModel(
        id: orderId,
        orderNumber: 'ORD-${DateTime.now().millisecondsSinceEpoch}',
        restaurantId: 'rest-1',
        restaurantName: 'Burger Palace',
        items: const [],
        deliveryAddress: const DeliveryAddressModel(
          street: '123 Test St',
          city: 'Test City',
          state: 'TS',
          zipCode: '12345',
          country: 'Test Country',
          fullAddress: '123 Test St, Test City, TS 12345, Test Country',
        ),
        paymentDetails: const PaymentDetailsModel(
          method: 'card',
          paymentStatus: 'completed',
        ),
        subtotal: 0,
        deliveryFee: 0,
        tax: 0,
        total: 0,
        status: 'pending',
        estimatedDeliveryTime: DateTime.now().add(const Duration(minutes: 30)),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
    }
  }

  @override
  Future<OrderModel> cancelOrder(String orderId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    final orderIndex = _orders.indexWhere((order) => order.id == orderId);
    if (orderIndex != -1) {
      final cancelledOrder = OrderModel(
        id: _orders[orderIndex].id,
        orderNumber: _orders[orderIndex].orderNumber,
        restaurantId: _orders[orderIndex].restaurantId,
        restaurantName: _orders[orderIndex].restaurantName,
        items: _orders[orderIndex].items,
        deliveryAddress: _orders[orderIndex].deliveryAddress,
        paymentDetails: _orders[orderIndex].paymentDetails,
        subtotal: _orders[orderIndex].subtotal,
        deliveryFee: _orders[orderIndex].deliveryFee,
        tax: _orders[orderIndex].tax,
        total: _orders[orderIndex].total,
        status: 'cancelled',
        estimatedDeliveryTime: _orders[orderIndex].estimatedDeliveryTime,
        specialInstructions: _orders[orderIndex].specialInstructions,
        driverName: _orders[orderIndex].driverName,
        createdAt: _orders[orderIndex].createdAt,
        updatedAt: DateTime.now(),
      );
      
      _orders[orderIndex] = cancelledOrder;
      return cancelledOrder;
    }
    
    throw Exception('Order not found');
  }
}
