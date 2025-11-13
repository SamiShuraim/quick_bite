/// Onboarding screen for QuickBite application
/// Shows multiple pages introducing app features with navigation controls
library;

import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';
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
      'title': OnboardingConstants.title1,
      'description': OnboardingConstants.description1,
    },
    {
      'title': OnboardingConstants.title2,
      'description': OnboardingConstants.description2,
    },
    {
      'title': OnboardingConstants.title3,
      'description': OnboardingConstants.description3,
    },
    {
      'title': OnboardingConstants.title4,
      'description': OnboardingConstants.description4,
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

