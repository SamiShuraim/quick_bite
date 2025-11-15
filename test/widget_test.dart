/// Widget tests for QuickBite app
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quick_bite/main.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:quick_bite/features/restaurant/data/datasources/restaurant_remote_datasource.dart';
import 'package:quick_bite/features/restaurant/data/datasources/restaurant_local_datasource.dart';
import 'package:quick_bite/features/restaurant/data/datasources/payment_remote_datasource.dart';
import 'package:quick_bite/features/restaurant/data/datasources/order_remote_datasource.dart';
import 'package:quick_bite/features/restaurant/data/repositories/restaurant_repository_impl.dart';
import 'package:quick_bite/features/restaurant/data/repositories/payment_repository_impl.dart';
import 'package:quick_bite/features/restaurant/data/repositories/order_repository_impl.dart';
import 'package:quick_bite/core/services/api_client.dart';
import 'package:quick_bite/core/services/storage_service.dart';

void main() {
  testWidgets('QuickBite app smoke test', (WidgetTester tester) async {
    // Initialize test dependencies
    SharedPreferences.setMockInitialValues({});
    final sharedPreferences = await SharedPreferences.getInstance();
    final httpClient = http.Client();
    const secureStorage = FlutterSecureStorage();

    // Core services
    final storageService = StorageService(
      secureStorage: secureStorage,
      preferences: sharedPreferences,
    );
    final apiClient = ApiClient(storageService: storageService);

    // Restaurant datasources and repository
    final restaurantRemoteDataSource = RestaurantRemoteDataSourceImpl(client: httpClient);
    final restaurantLocalDataSource = RestaurantLocalDataSourceImpl(
      sharedPreferences: sharedPreferences,
    );
    final restaurantRepository = RestaurantRepositoryImpl(
      remoteDataSource: restaurantRemoteDataSource,
      localDataSource: restaurantLocalDataSource,
    );

    // Payment datasource and repository
    final paymentRemoteDataSource = PaymentRemoteDataSourceImpl(apiClient: apiClient);
    final paymentRepository = PaymentRepositoryImpl(
      remoteDataSource: paymentRemoteDataSource,
    );

    // Order datasource and repository
    final orderRemoteDataSource = OrderRemoteDataSourceImpl(apiClient: apiClient);
    final orderRepository = OrderRepositoryImpl(
      remoteDataSource: orderRemoteDataSource,
    );

    // Build our app and trigger a frame.
    await tester.pumpWidget(QuickBiteApp(
      restaurantRepository: restaurantRepository,
      paymentRepository: paymentRepository,
      orderRepository: orderRepository,
    ));

    // Verify that MaterialApp is created
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
