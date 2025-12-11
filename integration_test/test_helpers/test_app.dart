/// Test app setup with mocked services
/// This allows integration tests to run without a backend
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:quick_bite/core/constants/app_constants.dart';
import 'package:quick_bite/core/theme/app_theme.dart';
import 'package:quick_bite/core/providers/theme_provider.dart';
import 'package:quick_bite/core/navigation/main_navigation.dart';
import 'package:quick_bite/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:quick_bite/features/restaurant/presentation/providers/restaurant_provider.dart';
import 'package:quick_bite/features/restaurant/presentation/providers/cart_provider.dart';
import 'package:quick_bite/features/restaurant/presentation/providers/payment_provider.dart';
import 'package:quick_bite/features/restaurant/presentation/providers/order_provider.dart';
import 'package:quick_bite/features/restaurant/data/datasources/restaurant_local_datasource.dart';
import 'package:quick_bite/features/restaurant/data/repositories/restaurant_repository_impl.dart';
import 'package:quick_bite/features/restaurant/data/repositories/payment_repository_impl.dart';
import 'package:quick_bite/features/restaurant/data/repositories/order_repository_impl.dart';
import 'package:quick_bite/core/services/storage_service.dart';
import 'package:quick_bite/core/utils/app_logger.dart';
import 'package:quick_bite/features/authentication/presentation/providers/auth_provider.dart';
import 'package:quick_bite/features/authentication/data/datasources/auth_local_datasource.dart';
import 'package:quick_bite/features/authentication/data/repositories/auth_repository_impl.dart';
import 'package:quick_bite/features/authentication/domain/usecases/login_usecase.dart';
import 'package:quick_bite/features/authentication/domain/usecases/register_usecase.dart';
import 'package:quick_bite/features/authentication/domain/usecases/logout_usecase.dart';
import 'package:quick_bite/features/authentication/domain/usecases/get_profile_usecase.dart';
import 'package:quick_bite/features/authentication/domain/usecases/get_cached_user_usecase.dart';
import 'package:quick_bite/features/authentication/domain/usecases/check_login_status_usecase.dart';
import 'package:quick_bite/features/profile/presentation/screens/edit_profile_screen.dart';
import 'package:quick_bite/features/restaurant/presentation/screens/unified_payment_screen.dart';
import 'mock_services.dart';

/// Main entry point for integration tests with mocked services
Future<void> main() async {
  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Set preferred orientations
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  AppLogger.section('QuickBite Integration Test Started');

  // Initialize dependencies with mocks
  SharedPreferences.setMockInitialValues({});
  final sharedPreferences = await SharedPreferences.getInstance();

  // Core services
  const secureStorage = FlutterSecureStorage(
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

  // Create MOCK data sources
  final restaurantRemoteDataSource = MockRestaurantRemoteDataSource();
  final restaurantLocalDataSource = RestaurantLocalDataSourceImpl(
    sharedPreferences: sharedPreferences,
  );

  final paymentRemoteDataSource = MockPaymentRemoteDataSource();
  final orderRemoteDataSource = MockOrderRemoteDataSource();

  final authRemoteDataSource = MockAuthRemoteDataSource();
  final authLocalDataSource = AuthLocalDataSourceImpl(storageService: storageService);

  // Create repositories with mocked data sources
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

  runApp(TestQuickBiteApp(
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

class TestQuickBiteApp extends StatefulWidget {
  final RestaurantRepositoryImpl restaurantRepository;
  final PaymentRepositoryImpl paymentRepository;
  final OrderRepositoryImpl orderRepository;
  final LoginUseCase loginUseCase;
  final RegisterUseCase registerUseCase;
  final LogoutUseCase logoutUseCase;
  final GetProfileUseCase getProfileUseCase;
  final GetCachedUserUseCase getCachedUserUseCase;
  final CheckLoginStatusUseCase checkLoginStatusUseCase;

  const TestQuickBiteApp({
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
  State<TestQuickBiteApp> createState() => _TestQuickBiteAppState();
}

class _TestQuickBiteAppState extends State<TestQuickBiteApp> {
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
          AppLogger.info('Building TestQuickBiteApp with theme: ${themeProvider.themeMode.name}');
          
          return MaterialApp(
            title: AppConstants.appName,
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.themeMode,
            home: const TestSplashScreen(),
            routes: {
              '/home': (context) => const MainNavigation(),
              '/edit-profile': (context) => const EditProfileScreen(),
              '/payment-methods': (context) => const UnifiedPaymentScreen(),
            },
            builder: (context, child) {
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

/// Test-specific splash screen that skips backend health check
/// Goes directly to onboarding after a short delay
class TestSplashScreen extends StatefulWidget {
  const TestSplashScreen({super.key});

  @override
  State<TestSplashScreen> createState() => _TestSplashScreenState();
}

class _TestSplashScreenState extends State<TestSplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    AppLogger.lifecycle('TestSplashScreen', 'initState');

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOutBack),
      ),
    );

    _animationController.forward();
    
    // Navigate after short delay - NO BACKEND CHECK
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        AppLogger.info('Test mode: Navigating to onboarding (no backend check)');
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => const OnboardingScreen(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
            transitionDuration: const Duration(milliseconds: 300),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    AppLogger.lifecycle('TestSplashScreen', 'dispose');
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return FadeTransition(
              opacity: _fadeAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: child,
              ),
            );
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: const Color(0xFFFF7622),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Center(
                  child: Text('🍔', style: TextStyle(fontSize: 60)),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'QuickBite',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFFF7622),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

