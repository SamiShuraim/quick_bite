/// App-wide constants for QuickBite application
/// Contains all string literals, routes, and configuration values
library;

import 'package:flutter/material.dart';

// App Information
class AppConstants {
  AppConstants._();

  // App Name
  static const String appName = 'QuickBite';
  static const String appTagline = 'Fast food, even faster';

  // Routes
  static const String splashRoute = '/';
  static const String onboardingRoute = '/onboarding';
  static const String loginRoute = '/login';
  static const String homeRoute = '/home';

  // Timing
  static const int splashDurationSeconds = 3;
  static const int pageTransitionMilliseconds = 250;
  static const int indicatorAnimationMilliseconds = 200;

  // Dimensions
  static const double defaultPadding = 24.0;
  static const double smallPadding = 12.0;
  static const double mediumPadding = 16.0;
  static const double largePadding = 40.0;
  
  static const double buttonHeight = 48.0;
  static const double buttonBorderRadius = 12.0;
  
  static const double onboardingImageHeight = 220.0;
  static const double pageIndicatorSize = 8.0;
  static const double pageIndicatorSpacing = 4.0;

  // Font Sizes
  static const double fontSizeLarge = 40.0;
  static const double fontSizeTitle = 22.0;
  static const double fontSizeBody = 16.0;
  static const double fontSizeButton = 14.0;

  // Font Weights
  static const fontWeightBold = FontWeight.bold;
  static const fontWeightMedium = FontWeight.w500;
  static const fontWeightRegular = FontWeight.normal;
}

// Authentication Constants
class AuthConstants {
  AuthConstants._();

  // Screen Titles
  static const String loginTitle = 'Sign In';
  static const String registerTitle = 'Sign Up';
  static const String forgotPasswordTitle = 'Forgot Password';
  static const String verificationTitle = 'Verification';

  // Form Labels
  static const String emailLabel = 'Email';
  static const String passwordLabel = 'Password';
  static const String nameLabel = 'Full Name';
  static const String phoneLabel = 'Phone Number';
  static const String confirmPasswordLabel = 'Confirm Password';

  // Form Placeholders
  static const String emailPlaceholder = 'Enter your email';
  static const String passwordPlaceholder = 'Enter your password';
  static const String namePlaceholder = 'Enter your full name';
  static const String phonePlaceholder = 'Enter your phone number';

  // Button Text
  static const String loginButton = 'SIGN IN';
  static const String registerButton = 'SIGN UP';
  static const String forgotPasswordButton = 'FORGOT PASSWORD?';
  static const String resetPasswordButton = 'RESET PASSWORD';
  static const String verifyButton = 'VERIFY';
  static const String resendCodeButton = 'Resend Code';

  // Links
  static const String dontHaveAccount = "Don't have an account?";
  static const String alreadyHaveAccount = 'Already have an account?';
  static const String signUpLink = 'Sign Up';
  static const String signInLink = 'Sign In';

  // Validation Messages
  static const String emailEmptyError = 'Email cannot be empty';
  static const String emailInvalidError = 'Please enter a valid email';
  static const String passwordEmptyError = 'Password cannot be empty';
  static const String passwordShortError = 'Password must be at least 8 characters';
  static const String passwordWeakError = 'Password must contain uppercase, lowercase, and number';
  static const String nameEmptyError = 'Name cannot be empty';
  static const String nameShortError = 'Name must be at least 2 characters';
  static const String phoneInvalidError = 'Please enter a valid phone number';
  static const String passwordMismatchError = 'Passwords do not match';

  // Success Messages
  static const String loginSuccess = 'Login successful!';
  static const String registerSuccess = 'Registration successful!';
  static const String passwordResetSuccess = 'Password reset email sent!';

  // Descriptions
  static const String forgotPasswordDescription = 'Enter your email address and we will send you a reset link';
  static const String verificationDescription = 'Enter the 4-digit code sent to your email';
}

// Onboarding Content
class OnboardingConstants {
  OnboardingConstants._();

  static const String title1 = 'All your favorites';
  static const String description1 = 'Get all your loved foods in one place, you just place the order we do the rest';

  static const String title2 = 'All your favorites';
  static const String description2 = 'Get all your loved foods in one place, you just place the order we do the rest';

  static const String title3 = 'Order from chosen chef';
  static const String description3 = 'Get all your loved foods in one place, you just place the order we do the rest';

  static const String title4 = 'Free delivery offers';
  static const String description4 = 'Get all your loved foods in one place, you just place the order we do the rest';

  // Button Text
  static const String buttonNext = 'NEXT';
  static const String buttonGetStarted = 'GET STARTED';
  static const String buttonSkip = 'Skip';

  static const int totalPages = 4;
}

// Logger Tags
class LogTags {
  LogTags._();

  static const String navigation = 'NAVIGATION';
  static const String lifecycle = 'LIFECYCLE';
  static const String userAction = 'USER_ACTION';
  static const String error = 'ERROR';
  static const String network = 'NETWORK';
  static const String database = 'DATABASE';
}

