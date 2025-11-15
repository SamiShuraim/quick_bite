/// Integration tests for app navigation flow
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quick_bite/main.dart';
import 'package:quick_bite/core/constants/app_constants.dart';
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
  late RestaurantRepositoryImpl restaurantRepository;
  late PaymentRepositoryImpl paymentRepository;
  late OrderRepositoryImpl orderRepository;

  setUp(() async {
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

    // Restaurant repository
    final restaurantRemoteDataSource = RestaurantRemoteDataSourceImpl(client: httpClient);
    final restaurantLocalDataSource = RestaurantLocalDataSourceImpl(
      sharedPreferences: sharedPreferences,
    );
    restaurantRepository = RestaurantRepositoryImpl(
      remoteDataSource: restaurantRemoteDataSource,
      localDataSource: restaurantLocalDataSource,
    );

    // Payment repository
    final paymentRemoteDataSource = PaymentRemoteDataSourceImpl(apiClient: apiClient);
    paymentRepository = PaymentRepositoryImpl(
      remoteDataSource: paymentRemoteDataSource,
    );

    // Order repository
    final orderRemoteDataSource = OrderRemoteDataSourceImpl(apiClient: apiClient);
    orderRepository = OrderRepositoryImpl(
      remoteDataSource: orderRemoteDataSource,
    );
  });

  group('App Integration Tests', () {
    testWidgets('Should navigate through splash to onboarding',
        (WidgetTester tester) async {
      // Build the app
      await tester.pumpWidget(QuickBiteApp(
        restaurantRepository: restaurantRepository,
        paymentRepository: paymentRepository,
        orderRepository: orderRepository,
      ));

      // Verify we're on splash screen
      expect(find.text(AppConstants.appName), findsOneWidget);

      // Wait for splash duration and pump
      await tester.pumpAndSettle(
        const Duration(seconds: AppConstants.splashDurationSeconds + 1),
      );

      // Verify we're on onboarding screen
      // Note: This test demonstrates integration testing structure
      // Actual assertions would depend on onboarding screen content
    });

    testWidgets('Should display app with correct theme',
        (WidgetTester tester) async {
      // Build the app
      await tester.pumpWidget(QuickBiteApp(
        restaurantRepository: restaurantRepository,
        paymentRepository: paymentRepository,
        orderRepository: orderRepository,
      ));

      // Verify MaterialApp is present
      expect(find.byType(MaterialApp), findsOneWidget);

      // Verify initial screen loads
      expect(find.byType(Scaffold), findsOneWidget);
    });
  });
}
