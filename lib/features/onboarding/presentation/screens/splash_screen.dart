/// Splash screen for QuickBite application
/// Displays app branding with animation and navigates to onboarding
library;

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/app_logger.dart';
import '../../../../core/services/backend_health_service.dart';
import 'backend_loading_screen.dart';
import 'onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late BackendHealthService _healthService;
  bool _isDisposed = false;
  bool _hasNavigated = false;

  @override
  void initState() {
    super.initState();
    AppLogger.lifecycle('SplashScreen', 'initState');

    _healthService = BackendHealthService();
    _initializeAnimations();
    
    // Defer navigation until after the first frame to ensure context is available
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_isDisposed) {
        _navigateToOnboarding();
      }
    });
  }

  /// Preload onboarding images during splash screen
  Future<void> _preloadOnboardingImages() async {
    try {
      AppLogger.info('Preloading onboarding images');
      
      final imageUrls = [
        'https://images.unsplash.com/photo-1504674900247-0877df9cc836?w=800',
        'https://images.unsplash.com/photo-1526367790999-0150786686a2?w=800',
        'https://images.unsplash.com/photo-1600565193348-f74bd3c7ccdf?w=800',
        'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?w=800',
      ];

      // Preload all images in parallel using CachedNetworkImage
      await Future.wait(
        imageUrls.map((url) async {
          try {
            await precacheImage(CachedNetworkImageProvider(url), context);
          } catch (e) {
            AppLogger.error('Failed to preload image: $url', error: e);
            // Continue even if one image fails (e.g., in test environment)
          }
        }),
      );

      AppLogger.info('Onboarding images preloaded successfully');
    } catch (e) {
      AppLogger.error('Failed to preload onboarding images', error: e);
      // Continue even if preloading fails (e.g., in test environment)
    }
  }

  void _initializeAnimations() {
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
  }

  Future<void> _navigateToOnboarding() async {
    try {
      // Wait for minimum splash duration and image preloading in parallel
      final splashFuture = Future.delayed(const Duration(seconds: AppConstants.splashDurationSeconds));
      final imagesFuture = _preloadOnboardingImages();
      
      await Future.wait([splashFuture, imagesFuture]);

      if (!mounted || _isDisposed || _hasNavigated) return;

      // Check backend health
      AppLogger.info('Performing backend health check...');
      final isHealthy = await _healthService.quickHealthCheck();
      AppLogger.info('Backend health check result: $isHealthy');

      if (!mounted || _isDisposed || _hasNavigated) return;

      _hasNavigated = true;

      if (isHealthy) {
        // Backend is ready, proceed to onboarding
        AppLogger.info('Backend is healthy, navigating to onboarding');
        _navigateToScreen(const OnboardingScreen());
      } else {
        // Backend is starting (cold start), show loading screen
        AppLogger.warning('Backend is not responding, showing loading screen');
        _navigateToScreen(
          BackendLoadingScreen(
            onBackendReady: () {
              if (mounted && !_isDisposed && !_hasNavigated) {
                Navigator.pushReplacement(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        const OnboardingScreen(),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      return FadeTransition(
                        opacity: animation,
                        child: child,
                      );
                    },
                    transitionDuration: const Duration(
                      milliseconds: AppConstants.pageTransitionMilliseconds,
                    ),
                  ),
                );
              }
            },
          ),
        );
      }
    } catch (e, stackTrace) {
      AppLogger.error('Error during navigation', error: e, stackTrace: stackTrace);
      // On error, just proceed to onboarding
      if (mounted && !_isDisposed && !_hasNavigated) {
        _hasNavigated = true;
        _navigateToScreen(const OnboardingScreen());
      }
    }
  }

  void _navigateToScreen(Widget screen) {
    AppLogger.navigation('SplashScreen', screen.runtimeType.toString());
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => screen,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
        transitionDuration: const Duration(
          milliseconds: AppConstants.pageTransitionMilliseconds,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _isDisposed = true;
    AppLogger.lifecycle('SplashScreen', 'dispose');
    _animationController.dispose();
    _healthService.dispose();
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
              // App Logo/Icon
              _buildLogo(),
              
              const SizedBox(height: AppConstants.defaultPadding),
              
              // App Name
              Text(
                AppConstants.appName,
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      color: AppColors.primary,
                      fontWeight: AppConstants.fontWeightBold,
                      letterSpacing: 1.2,
                    ),
              ),
              
              const SizedBox(height: AppConstants.smallPadding),
              
              // Tagline
              Text(
                AppConstants.appTagline,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                      letterSpacing: 0.5,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Food emoji or icon representation
          const Text(
            '🍔',
            style: TextStyle(fontSize: 60),
          ),
          // Small overlay text
          Positioned(
            bottom: 10,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'QB',
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

