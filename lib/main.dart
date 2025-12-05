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
import 'core/providers/theme_provider.dart';
import 'core/navigation/main_navigation.dart';
import 'features/onboarding/presentation/screens/splash_screen.dart';
import 'features/restaurant/presentation/providers/restaurant_provider.dart';
import 'features/restaurant/presentation/providers/cart_provider.dart';
import 'features/restaurant/presentation/providers/payment_provider.dart';
import 'features/restaurant/presentation/providers/order_provider.dart';
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
// Authentication imports
import 'features/authentication/presentation/providers/auth_provider.dart';
import 'features/authentication/data/datasources/auth_remote_datasource.dart';
import 'features/authentication/data/datasources/auth_local_datasource.dart';
import 'features/authentication/data/repositories/auth_repository_impl.dart';
import 'features/authentication/domain/usecases/login_usecase.dart';
import 'features/authentication/domain/usecases/register_usecase.dart';
import 'features/authentication/domain/usecases/logout_usecase.dart';
import 'features/authentication/domain/usecases/get_profile_usecase.dart';
import 'features/authentication/domain/usecases/get_cached_user_usecase.dart';
import 'features/authentication/domain/usecases/check_login_status_usecase.dart';
import 'features/profile/presentation/screens/edit_profile_screen.dart';
import 'features/restaurant/presentation/screens/unified_payment_screen.dart';

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
  final secureStorage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock,
    ),
    webOptions: WebOptions(
      dbName: 'QuickBiteSecureStorage',
      publicKey: 'QuickBitePublicKey',
    ),
  );
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

  // Create authentication data sources
  final authRemoteDataSource = AuthRemoteDataSourceImpl(apiClient: apiClient);
  final authLocalDataSource = AuthLocalDataSourceImpl(storageService: storageService);

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

  final authRepository = AuthRepositoryImpl(
    remoteDataSource: authRemoteDataSource,
    localDataSource: authLocalDataSource,
  );

  // Create authentication use cases
  final loginUseCase = LoginUseCase(repository: authRepository);
  final registerUseCase = RegisterUseCase(repository: authRepository);
  final logoutUseCase = LogoutUseCase(repository: authRepository);
  final getProfileUseCase = GetProfileUseCase(repository: authRepository);
  final getCachedUserUseCase = GetCachedUserUseCase(repository: authRepository);
  final checkLoginStatusUseCase = CheckLoginStatusUseCase(repository: authRepository);

  runApp(QuickBiteApp(
    restaurantRepository: restaurantRepository,
    paymentRepository: paymentRepository,
    orderRepository: orderRepository,
    loginUseCase: loginUseCase,
    registerUseCase: registerUseCase,
    logoutUseCase: logoutUseCase,
    getProfileUseCase: getProfileUseCase,
    getCachedUserUseCase: getCachedUserUseCase,
    checkLoginStatusUseCase: checkLoginStatusUseCase,
  ));
}

class QuickBiteApp extends StatefulWidget {
  final RestaurantRepositoryImpl restaurantRepository;
  final PaymentRepositoryImpl paymentRepository;
  final OrderRepositoryImpl orderRepository;
  final LoginUseCase loginUseCase;
  final RegisterUseCase registerUseCase;
  final LogoutUseCase logoutUseCase;
  final GetProfileUseCase getProfileUseCase;
  final GetCachedUserUseCase getCachedUserUseCase;
  final CheckLoginStatusUseCase checkLoginStatusUseCase;

  const QuickBiteApp({
    super.key,
    required this.restaurantRepository,
    required this.paymentRepository,
    required this.orderRepository,
    required this.loginUseCase,
    required this.registerUseCase,
    required this.logoutUseCase,
    required this.getProfileUseCase,
    required this.getCachedUserUseCase,
    required this.checkLoginStatusUseCase,
  });

  @override
  State<QuickBiteApp> createState() => _QuickBiteAppState();
}

class _QuickBiteAppState extends State<QuickBiteApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ThemeProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => AuthProvider(
            loginUseCase: widget.loginUseCase,
            registerUseCase: widget.registerUseCase,
            logoutUseCase: widget.logoutUseCase,
            getProfileUseCase: widget.getProfileUseCase,
            getCachedUserUseCase: widget.getCachedUserUseCase,
            checkLoginStatusUseCase: widget.checkLoginStatusUseCase,
          ),
        ),
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
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          AppLogger.info('Building QuickBiteApp with theme: ${themeProvider.themeMode.name}');
          
          return MaterialApp(
            // App Configuration
            title: AppConstants.appName,
            debugShowCheckedModeBanner: false,

            // Theme Configuration
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.themeMode,

            // Initial Route
            home: const SplashScreen(),

            // Named Routes
            routes: {
              '/home': (context) => const MainNavigation(),
              '/edit-profile': (context) => const EditProfileScreen(),
              '/payment-methods': (context) => const UnifiedPaymentScreen(),
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
          );
        },
      ),
    );
  }
}
