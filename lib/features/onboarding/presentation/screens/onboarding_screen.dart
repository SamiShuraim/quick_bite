/// Onboarding screen for QuickBite application
/// Shows multiple pages introducing app features with navigation controls
library;

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/custom_button.dart';
import '../widgets/page_indicator.dart';
import '../widgets/onboarding_content.dart';
import '../../../../core/utils/app_logger.dart';
import '../../../authentication/presentation/screens/login_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // Onboarding pages data
  final List<Map<String, String>> _pages = const [
    {
      'title': 'All your favorites',
      'description':
          'Get all your loved foods in one place, you just place the order we do the rest',
      'image': 'https://images.unsplash.com/photo-1504674900247-0877df9cc836?w=800',
    },
    {
      'title': 'Free delivery offers',
      'description':
          'Free delivery for new customers via Apple Pay and others payment methods',
      'image': 'https://images.unsplash.com/photo-1526367790999-0150786686a2?w=800',
    },
    {
      'title': 'Order from chosen chef',
      'description':
          'Get all your loved foods in one place, you just place the order we do the rest',
      'image': 'https://images.unsplash.com/photo-1600565193348-f74bd3c7ccdf?w=800',
    },
    {
      'title': 'Choose your favorites',
      'description':
          'Get all your loved foods in one place, you just place the order we do the rest',
      'image': 'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?w=800',
    },
  ];

  bool get _isLastPage => _currentPage == _pages.length - 1;

  @override
  void initState() {
    super.initState();
    AppLogger.lifecycle('OnboardingScreen', 'initState');
  }

  @override
  void dispose() {
    AppLogger.lifecycle('OnboardingScreen', 'dispose');
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
    AppLogger.userAction('Onboarding Page Changed', details: {
      'currentPage': index + 1,
      'totalPages': _pages.length,
    });
  }

  void _navigateToNextPage() {
    if (_isLastPage) {
      _navigateToLogin();
    } else {
      _pageController.nextPage(
        duration: const Duration(
          milliseconds: AppConstants.pageTransitionMilliseconds,
        ),
        curve: Curves.easeInOut,
      );
    }
  }

  void _navigateToLogin() {
    AppLogger.navigation('OnboardingScreen', 'LoginScreen');
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const LoginScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOut;
          var tween = Tween(begin: begin, end: end).chain(
            CurveTween(curve: curve),
          );
          var offsetAnimation = animation.drive(tween);
          return SlideTransition(
            position: offsetAnimation,
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.defaultPadding,
            vertical: AppConstants.mediumPadding,
          ),
          child: Column(
            children: [
              // Page View
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: _pages.length,
                  onPageChanged: _onPageChanged,
                  itemBuilder: (context, index) {
                    final page = _pages[index];
                    return OnboardingContent(
                      title: page['title']!,
                      description: page['description']!,
                      image: page['image'] != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: CachedNetworkImage(
                                imageUrl: page['image']!,
                                fit: BoxFit.cover,
                                fadeInDuration: const Duration(milliseconds: 300),
                                fadeOutDuration: const Duration(milliseconds: 100),
                                placeholder: (context, url) => Container(
                                  color: AppColors.imagePlaceholder,
                                  child: const Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        CircularProgressIndicator(
                                          valueColor: AlwaysStoppedAnimation<Color>(
                                            AppColors.primary,
                                          ),
                                        ),
                                        SizedBox(height: 16),
                                        Text(
                                          'Loading image...',
                                          style: TextStyle(
                                            color: Colors.white70,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                errorWidget: (context, url, error) {
                                  AppLogger.error('Failed to load image: $url', error: error);
                                  return Container(
                                    color: AppColors.imagePlaceholder,
                                    child: const Center(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.restaurant_menu,
                                            size: 60,
                                            color: Colors.white,
                                          ),
                                          SizedBox(height: 16),
                                          Text(
                                            'Image not available',
                                            style: TextStyle(
                                              color: Colors.white70,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            )
                          : null,
                    );
                  },
                ),
              ),

              // Page Indicator
              PageIndicator(
                currentPage: _currentPage,
                pageCount: _pages.length,
              ),

              const SizedBox(height: AppConstants.largePadding),

              // Next/Get Started Button
              CustomButton(
                text: _isLastPage
                    ? OnboardingConstants.buttonGetStarted
                    : OnboardingConstants.buttonNext,
                onPressed: _navigateToNextPage,
                isFullWidth: true,
              ),

              const SizedBox(height: AppConstants.smallPadding),

              // Skip Button (only show if not on last page)
              if (!_isLastPage)
                CustomButton(
                  text: OnboardingConstants.buttonSkip,
                  onPressed: _navigateToLogin,
                  type: ButtonType.text,
                  isFullWidth: true,
                ),

              // Add spacing when skip button is hidden to maintain layout
              if (_isLastPage)
                const SizedBox(height: AppConstants.buttonHeight),
            ],
          ),
        ),
      ),
    );
  }
}

