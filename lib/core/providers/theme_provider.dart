/// Theme provider for managing app theme mode
library;

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/app_logger.dart';

class ThemeProvider extends ChangeNotifier {
  static const String _themePreferenceKey = 'theme_mode';
  
  ThemeMode _themeMode = ThemeMode.system;
  
  ThemeMode get themeMode => _themeMode;
  
  bool get isDarkMode {
    if (_themeMode == ThemeMode.dark) return true;
    if (_themeMode == ThemeMode.light) return false;
    // For system mode, this will be determined by the system
    return false;
  }
  
  ThemeProvider() {
    _loadThemePreference();
  }
  
  /// Load saved theme preference
  Future<void> _loadThemePreference() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final themeModeString = prefs.getString(_themePreferenceKey);
      
      if (themeModeString != null) {
        _themeMode = ThemeMode.values.firstWhere(
          (mode) => mode.toString() == themeModeString,
          orElse: () => ThemeMode.system,
        );
        notifyListeners();
        AppLogger.info('Loaded theme preference: $_themeMode');
      }
    } catch (e, stackTrace) {
      AppLogger.error('Failed to load theme preference', 
        error: e, stackTrace: stackTrace);
    }
  }
  
  /// Set theme mode
  Future<void> setThemeMode(ThemeMode mode) async {
    if (_themeMode == mode) return;
    
    _themeMode = mode;
    notifyListeners();
    
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_themePreferenceKey, mode.toString());
      AppLogger.userAction('Theme changed', details: {'mode': mode.toString()});
    } catch (e, stackTrace) {
      AppLogger.error('Failed to save theme preference', 
        error: e, stackTrace: stackTrace);
    }
  }
  
  /// Toggle between light and dark mode
  Future<void> toggleTheme() async {
    final newMode = _themeMode == ThemeMode.light 
      ? ThemeMode.dark 
      : ThemeMode.light;
    await setThemeMode(newMode);
  }
}

