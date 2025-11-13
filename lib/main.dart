/// Main entry point for QuickBite application
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'core/constants/app_constants.dart';
import 'core/theme/app_theme.dart';
import 'features/onboarding/presentation/screens/splash_screen.dart';
import 'core/utils/app_logger.dart';

void main() {
  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Set preferred orientations (portrait only for mobile)
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  AppLogger.section('QuickBite Application Started');

  runApp(const QuickBiteApp());
}

class QuickBiteApp extends StatefulWidget {
  const QuickBiteApp({super.key});

  @override
  State<QuickBiteApp> createState() => _QuickBiteAppState();
}

class _QuickBiteAppState extends State<QuickBiteApp> {
  // Theme mode state (can be toggled in future implementations)
  final ThemeMode _themeMode = ThemeMode.system;

  @override
  Widget build(BuildContext context) {
    AppLogger.info('Building QuickBiteApp with theme: ${_themeMode.name}');

    return MaterialApp(
      // App Configuration
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,

      // Theme Configuration
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: _themeMode,

      // Initial Route
      home: const SplashScreen(),

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
  }
}
