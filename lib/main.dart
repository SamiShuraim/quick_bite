/// Main entry point for QuickBite application
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'core/constants/app_constants.dart';
import 'core/theme/app_theme.dart';
import 'features/onboarding/presentation/screens/splash_screen.dart';
import 'features/restaurant/presentation/providers/restaurant_provider.dart';
import 'features/restaurant/presentation/providers/cart_provider.dart';
import 'features/restaurant/presentation/providers/payment_provider.dart';
import 'features/restaurant/presentation/providers/order_provider.dart';
import 'features/restaurant/presentation/screens/home_screen.dart';
import 'features/restaurant/data/datasources/restaurant_remote_datasource.dart';
import 'features/restaurant/data/datasources/restaurant_local_datasource.dart';
import 'features/restaurant/data/datasources/payment_remote_datasource.dart';
import 'features/restaurant/data/datasources/order_remote_datasource.dart';
import 'features/restaurant/data/repositories/restaurant_repository_impl.dart';
import 'features/restaurant/data/repositories/payment_repository_impl.dart';
import 'features/restaurant/data/repositories/order_repository_impl.dart';
import 'core/services/api_client.dart';
import 'core/services/storage_service.dart';
import 'core/utils/app_logger.dart';

void main() async {
  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Set preferred orientations (portrait only for mobile)
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  AppLogger.section('QuickBite Application Started');

  // Initialize dependencies
  final sharedPreferences = await SharedPreferences.getInstance();
  final httpClient = http.Client();

  // Core services
  final secureStorage = const FlutterSecureStorage();
  final storageService = StorageService(
    secureStorage: secureStorage,
    preferences: sharedPreferences,
  );
  final apiClient = ApiClient(storageService: storageService);

  // Create restaurant data sources
  final restaurantRemoteDataSource = RestaurantRemoteDataSourceImpl(client: httpClient);
  final restaurantLocalDataSource = RestaurantLocalDataSourceImpl(
    sharedPreferences: sharedPreferences,
  );

  // Create payment and order data sources
  final paymentRemoteDataSource = PaymentRemoteDataSourceImpl(apiClient: apiClient);
  final orderRemoteDataSource = OrderRemoteDataSourceImpl(apiClient: apiClient);

  // Create repositories
  final restaurantRepository = RestaurantRepositoryImpl(
    remoteDataSource: restaurantRemoteDataSource,
    localDataSource: restaurantLocalDataSource,
  );
  
  final paymentRepository = PaymentRepositoryImpl(
    remoteDataSource: paymentRemoteDataSource,
  );
  
  final orderRepository = OrderRepositoryImpl(
    remoteDataSource: orderRemoteDataSource,
  );

  runApp(QuickBiteApp(
    restaurantRepository: restaurantRepository,
    paymentRepository: paymentRepository,
    orderRepository: orderRepository,
  ));
}

class QuickBiteApp extends StatefulWidget {
  final RestaurantRepositoryImpl restaurantRepository;
  final PaymentRepositoryImpl paymentRepository;
  final OrderRepositoryImpl orderRepository;

  const QuickBiteApp({
    super.key,
    required this.restaurantRepository,
    required this.paymentRepository,
    required this.orderRepository,
  });

  @override
  State<QuickBiteApp> createState() => _QuickBiteAppState();
}

class _QuickBiteAppState extends State<QuickBiteApp> {
  // Theme mode state (can be toggled in future implementations)
  final ThemeMode _themeMode = ThemeMode.system;

  @override
  Widget build(BuildContext context) {
    AppLogger.info('Building QuickBiteApp with theme: ${_themeMode.name}');

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => RestaurantProvider(repository: widget.restaurantRepository),
        ),
        ChangeNotifierProvider(
          create: (_) => CartProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => PaymentProvider(paymentRepository: widget.paymentRepository),
        ),
        ChangeNotifierProvider(
          create: (_) => OrderProvider(orderRepository: widget.orderRepository),
        ),
      ],
      child: MaterialApp(
        // App Configuration
        title: AppConstants.appName,
        debugShowCheckedModeBanner: false,

        // Theme Configuration
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: _themeMode,

        // Initial Route
        home: const SplashScreen(),

        // Named Routes
        routes: {
          '/home': (context) => const HomeScreen(),
        },

        // Builder for additional app-level configurations
        builder: (context, child) {
          // Prevent font scaling based on system settings for consistent UI
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(
              textScaler: TextScaler.noScaling,
            ),
            child: child!,
          );
        },
      ),
    );
  }
}
