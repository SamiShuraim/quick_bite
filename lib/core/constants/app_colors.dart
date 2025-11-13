/// Color constants for QuickBite application
/// Defines the color palette used throughout the app
library;

import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary Colors
  static const Color primary = Color(0xFFFF7622); // Orange
  static const Color primaryLight = Color(0xFFFF9D5C);
  static const Color primaryDark = Color(0xFFE65100);

  // Background Colors
  static const Color background = Color(0xFFFFFFFF);
  static const Color backgroundLight = Color(0xFFF5F5F5);
  static const Color surface = Color(0xFFFFFFFF);

  // Text Colors
  static const Color textPrimary = Color(0xFF000000);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textTertiary = Color(0xFF9E9E9E);
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // Component Colors
  static const Color cardBackground = Color(0xFFF5F5F5);
  static const Color imagePlaceholder = Color(0xFF90A4AE);
  static const Color divider = Color(0xFFE0E0E0);

  // Interactive Colors
  static const Color buttonPrimary = primary;
  static const Color buttonSecondary = Color(0xFFEEEEEE);
  static const Color buttonDisabled = Color(0xFFBDBDBD);

  // Indicator Colors
  static const Color indicatorActive = primary;
  static const Color indicatorInactive = Color(0xFFFFCCAA);

  // Status Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFF44336);
  static const Color warning = Color(0xFFFFC107);
  static const Color info = Color(0xFF2196F3);

  // Shadow
  static const Color shadow = Color(0x1A000000);

  // Dark Mode Colors
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkBackgroundLight = Color(0xFF1E1E1E);
  static const Color darkSurface = Color(0xFF1E1E1E);
  static const Color darkCardBackground = Color(0xFF2C2C2C);
  
  // Dark Mode Text Colors
  static const Color darkTextPrimary = Color(0xFFFFFFFF);
  static const Color darkTextSecondary = Color(0xFFB3B3B3);
  static const Color darkTextTertiary = Color(0xFF808080);
  
  // Dark Mode Components
  static const Color darkImagePlaceholder = Color(0xFF455A64);
  static const Color darkDivider = Color(0xFF404040);
}

