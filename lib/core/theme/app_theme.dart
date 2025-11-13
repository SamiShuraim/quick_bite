/// Theme configuration for QuickBite application
/// Provides consistent styling across the entire app with dark/light mode support
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/app_colors.dart';
import '../constants/app_constants.dart';

class AppTheme {
  AppTheme._();

  /// Light theme configuration
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      
      // Color Scheme
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        secondary: AppColors.primaryLight,
        surface: AppColors.surface,
        error: AppColors.error,
        onPrimary: AppColors.textOnPrimary,
        onSecondary: AppColors.textOnPrimary,
        onSurface: AppColors.textPrimary,
        onError: AppColors.textOnPrimary,
      ),
      
      // Scaffold
      scaffoldBackgroundColor: AppColors.background,
      
      // App Bar
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        titleTextStyle: TextStyle(
          color: AppColors.textPrimary,
          fontSize: AppConstants.fontSizeTitle,
          fontWeight: AppConstants.fontWeightBold,
        ),
      ),
      
      // Text Theme
      textTheme: _buildTextTheme(AppColors.textPrimary, AppColors.textSecondary),
      
      // Elevated Button
      elevatedButtonTheme: _buildElevatedButtonTheme(),
      
      // Text Button
      textButtonTheme: _buildTextButtonTheme(AppColors.textSecondary),
      
      // Outlined Button
      outlinedButtonTheme: _buildOutlinedButtonTheme(),
      
      // Card
      cardTheme: CardThemeData(
        color: AppColors.cardBackground,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.buttonBorderRadius),
        ),
      ),
      
      // Input Decoration
      inputDecorationTheme: _buildInputDecorationTheme(AppColors.backgroundLight),
      
      // Divider
      dividerTheme: const DividerThemeData(
        color: AppColors.divider,
        thickness: 1,
        space: 1,
      ),
    );
  }

  /// Dark theme configuration
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      
      // Color Scheme
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,
        secondary: AppColors.primaryLight,
        surface: AppColors.darkSurface,
        error: AppColors.error,
        onPrimary: AppColors.textOnPrimary,
        onSecondary: AppColors.textOnPrimary,
        onSurface: AppColors.darkTextPrimary,
        onError: AppColors.textOnPrimary,
      ),
      
      // Scaffold
      scaffoldBackgroundColor: AppColors.darkBackground,
      
      // App Bar
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.darkBackground,
        foregroundColor: AppColors.darkTextPrimary,
        elevation: 0,
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        titleTextStyle: TextStyle(
          color: AppColors.darkTextPrimary,
          fontSize: AppConstants.fontSizeTitle,
          fontWeight: AppConstants.fontWeightBold,
        ),
      ),
      
      // Text Theme
      textTheme: _buildTextTheme(AppColors.darkTextPrimary, AppColors.darkTextSecondary),
      
      // Elevated Button
      elevatedButtonTheme: _buildElevatedButtonTheme(),
      
      // Text Button
      textButtonTheme: _buildTextButtonTheme(AppColors.darkTextSecondary),
      
      // Outlined Button
      outlinedButtonTheme: _buildOutlinedButtonTheme(),
      
      // Card
      cardTheme: CardThemeData(
        color: AppColors.darkCardBackground,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.buttonBorderRadius),
        ),
      ),
      
      // Input Decoration
      inputDecorationTheme: _buildInputDecorationTheme(AppColors.darkCardBackground),
      
      // Divider
      dividerTheme: const DividerThemeData(
        color: AppColors.darkDivider,
        thickness: 1,
        space: 1,
      ),
    );
  }

  /// Build text theme
  static TextTheme _buildTextTheme(Color primaryColor, Color secondaryColor) {
    return TextTheme(
      displayLarge: TextStyle(
        fontSize: AppConstants.fontSizeLarge,
        fontWeight: AppConstants.fontWeightBold,
        color: primaryColor,
      ),
      headlineLarge: TextStyle(
        fontSize: 32.0,
        fontWeight: AppConstants.fontWeightBold,
        color: primaryColor,
      ),
      headlineMedium: TextStyle(
        fontSize: 28.0,
        fontWeight: AppConstants.fontWeightBold,
        color: primaryColor,
      ),
      titleLarge: TextStyle(
        fontSize: AppConstants.fontSizeTitle,
        fontWeight: AppConstants.fontWeightBold,
        color: primaryColor,
      ),
      titleMedium: TextStyle(
        fontSize: 18.0,
        fontWeight: AppConstants.fontWeightMedium,
        color: primaryColor,
      ),
      bodyLarge: TextStyle(
        fontSize: AppConstants.fontSizeBody,
        fontWeight: AppConstants.fontWeightRegular,
        color: primaryColor,
        height: 1.5,
      ),
      bodyMedium: TextStyle(
        fontSize: 14.0,
        fontWeight: AppConstants.fontWeightRegular,
        color: secondaryColor,
        height: 1.4,
      ),
      labelLarge: const TextStyle(
        fontSize: AppConstants.fontSizeButton,
        fontWeight: AppConstants.fontWeightBold,
        color: AppColors.textOnPrimary,
      ),
    );
  }

  /// Build elevated button theme
  static ElevatedButtonThemeData _buildElevatedButtonTheme() {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.buttonPrimary,
        foregroundColor: AppColors.textOnPrimary,
        disabledBackgroundColor: AppColors.buttonDisabled,
        elevation: 0,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.buttonBorderRadius),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.defaultPadding,
          vertical: AppConstants.mediumPadding,
        ),
        textStyle: const TextStyle(
          fontSize: AppConstants.fontSizeButton,
          fontWeight: AppConstants.fontWeightBold,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  /// Build text button theme
  static TextButtonThemeData _buildTextButtonTheme(Color foregroundColor) {
    return TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: foregroundColor,
        textStyle: const TextStyle(
          fontSize: AppConstants.fontSizeBody,
          fontWeight: AppConstants.fontWeightMedium,
        ),
      ),
    );
  }

  /// Build outlined button theme
  static OutlinedButtonThemeData _buildOutlinedButtonTheme() {
    return OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primary,
        side: const BorderSide(color: AppColors.primary, width: 2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.buttonBorderRadius),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.defaultPadding,
          vertical: AppConstants.mediumPadding,
        ),
      ),
    );
  }


  /// Build input decoration theme
  static InputDecorationTheme _buildInputDecorationTheme(Color fillColor) {
    return InputDecorationTheme(
      filled: true,
      fillColor: fillColor,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppConstants.buttonBorderRadius),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppConstants.buttonBorderRadius),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppConstants.buttonBorderRadius),
        borderSide: const BorderSide(color: AppColors.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppConstants.buttonBorderRadius),
        borderSide: const BorderSide(color: AppColors.error, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppConstants.mediumPadding,
        vertical: AppConstants.mediumPadding,
      ),
    );
  }

  /// System UI overlay style for light mode status bar
  static const SystemUiOverlayStyle lightSystemUiOverlayStyle = SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
    statusBarBrightness: Brightness.light,
    systemNavigationBarColor: AppColors.background,
    systemNavigationBarIconBrightness: Brightness.dark,
  );

  /// System UI overlay style for dark mode status bar
  static const SystemUiOverlayStyle darkSystemUiOverlayStyle = SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    statusBarBrightness: Brightness.dark,
    systemNavigationBarColor: AppColors.darkBackground,
    systemNavigationBarIconBrightness: Brightness.light,
  );
}

