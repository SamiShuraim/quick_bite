/// Backend Loading Screen
/// Displays when backend is starting up (cold start)
library;

import 'package:flutter/material.dart';
import 'dart:async';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/services/backend_health_service.dart';
import '../../../../core/utils/app_logger.dart';

class BackendLoadingScreen extends StatefulWidget {
  final VoidCallback onBackendReady;
  
  const BackendLoadingScreen({
    super.key,
    required this.onBackendReady,
  });

  @override
  State<BackendLoadingScreen> createState() => _BackendLoadingScreenState();
}

class _BackendLoadingScreenState extends State<BackendLoadingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _pulseAnimation;
  final BackendHealthService _healthService = BackendHealthService();
  
  int _attemptCount = 0;
  String _statusMessage = 'Waking up the server...';
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    AppLogger.lifecycle('BackendLoadingScreen', 'initState');
    
    _initializeAnimations();
    _startBackendHealthCheck();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  Future<void> _startBackendHealthCheck() async {
    AppLogger.info('Starting backend health check');
    
    Timer.periodic(const Duration(seconds: 10), (timer) async {
      if (!mounted) {
        timer.cancel();
        return;
      }
      
      _attemptCount++;
      
      setState(() {
        if (_attemptCount <= 3) {
          _statusMessage = 'Starting the server... (attempt $_attemptCount)';
        } else if (_attemptCount <= 10) {
          _statusMessage = 'Server is starting, this may take a minute...';
        } else {
          _statusMessage = 'Almost there, just a few more seconds...';
        }
      });

      final isHealthy = await _healthService.checkHealth();
      
      if (isHealthy) {
        timer.cancel();
        AppLogger.info('Backend is ready, navigating to next screen');
        
        if (mounted) {
          // Small delay for smooth transition
          await Future.delayed(const Duration(milliseconds: 500));
          widget.onBackendReady();
        }
      } else if (_attemptCount >= 30) {
        // After 5 minutes (30 attempts), show error
        timer.cancel();
        if (mounted) {
          setState(() {
            _hasError = true;
            _statusMessage = 'Unable to connect to server';
          });
        }
      }
    });
  }

  void _retry() {
    setState(() {
      _hasError = false;
      _attemptCount = 0;
      _statusMessage = 'Waking up the server...';
    });
    _startBackendHealthCheck();
  }

  @override
  void dispose() {
    AppLogger.lifecycle('BackendLoadingScreen', 'dispose');
    _animationController.dispose();
    _healthService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.defaultPadding * 2),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              
              // Logo with pulse animation
              if (!_hasError)
                AnimatedBuilder(
                  animation: _pulseAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _pulseAnimation.value,
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.3),
                              blurRadius: 20,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Text(
                            '🍔',
                            style: TextStyle(fontSize: 60),
                          ),
                        ),
                      ),
                    );
                  },
                )
              else
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: AppColors.error.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Icon(
                    Icons.error_outline,
                    size: 60,
                    color: AppColors.error,
                  ),
                ),

              const SizedBox(height: AppConstants.largePadding * 2),

              // App Name
              Text(
                AppConstants.appName,
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      fontWeight: AppConstants.fontWeightBold,
                      color: AppColors.primary,
                    ),
              ),

              const SizedBox(height: AppConstants.defaultPadding),

              // Loading Indicator
              if (!_hasError)
                const SizedBox(
                  width: 40,
                  height: 40,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                  ),
                ),

              const SizedBox(height: AppConstants.defaultPadding),

              // Status Message
              Text(
                _statusMessage,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: _hasError 
                          ? AppColors.error 
                          : (isDarkMode 
                              ? AppColors.darkTextSecondary 
                              : AppColors.textSecondary),
                      fontWeight: FontWeight.w500,
                    ),
              ),

              const SizedBox(height: AppConstants.largePadding),

              // Explanation
              Container(
                padding: const EdgeInsets.all(AppConstants.defaultPadding),
                decoration: BoxDecoration(
                  color: isDarkMode
                      ? Colors.white.withValues(alpha: 0.05)
                      : Colors.black.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isDarkMode
                        ? Colors.white.withValues(alpha: 0.1)
                        : Colors.black.withValues(alpha: 0.1),
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: AppColors.primary,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Why the wait?',
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'This is a student project running on free cloud hosting (Render.com). '
                      'Free services spin down after inactivity and can take up to a minute to start. '
                      'Once the server is running, the app will work smoothly!',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: isDarkMode
                                ? AppColors.darkTextSecondary
                                : AppColors.textSecondary,
                            height: 1.5,
                          ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              // Retry button (only shown on error)
              if (_hasError) ...[
                const SizedBox(height: AppConstants.largePadding),
                ElevatedButton.icon(
                  onPressed: _retry,
                  icon: const Icon(Icons.refresh),
                  label: const Text('RETRY'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],

              const Spacer(),

              // Progress indicator
              if (!_hasError)
                Text(
                  'Attempt $_attemptCount',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: isDarkMode
                            ? AppColors.darkTextSecondary.withValues(alpha: 0.5)
                            : AppColors.textSecondary.withValues(alpha: 0.5),
                      ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

