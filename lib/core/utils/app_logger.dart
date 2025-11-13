/// Logger utility for QuickBite application
/// Provides structured logging with tags and different log levels
/// for easy debugging and monitoring
library;

import 'package:flutter/foundation.dart';

enum LogLevel {
  debug,
  info,
  warning,
  error,
}

class AppLogger {
  AppLogger._();

  static const String _prefix = '🍔 QuickBite';
  static const bool _enableLogging = true; // Set to false in production

  /// Log debug information
  static void debug(String message, {String? tag, Object? data}) {
    _log(LogLevel.debug, message, tag: tag, data: data);
  }

  /// Log general information
  static void info(String message, {String? tag, Object? data}) {
    _log(LogLevel.info, message, tag: tag, data: data);
  }

  /// Log warnings
  static void warning(String message, {String? tag, Object? data}) {
    _log(LogLevel.warning, message, tag: tag, data: data);
  }

  /// Log errors with optional stack trace
  static void error(
    String message, {
    String? tag,
    Object? error,
    StackTrace? stackTrace,
  }) {
    _log(
      LogLevel.error,
      message,
      tag: tag,
      data: error,
      stackTrace: stackTrace,
    );
  }

  /// Log navigation events
  static void navigation(String from, String to) {
    info(
      'Navigation: $from → $to',
      tag: 'NAVIGATION',
    );
  }

  /// Log user actions
  static void userAction(String action, {Map<String, dynamic>? details}) {
    info(
      'User Action: $action',
      tag: 'USER_ACTION',
      data: details,
    );
  }

  /// Log lifecycle events
  static void lifecycle(String component, String event) {
    debug(
      'Lifecycle: $component - $event',
      tag: 'LIFECYCLE',
    );
  }

  /// Internal logging method
  static void _log(
    LogLevel level,
    String message, {
    String? tag,
    Object? data,
    StackTrace? stackTrace,
  }) {
    if (!_enableLogging) return;
    if (!kDebugMode && level == LogLevel.debug) return;

    final emoji = _getEmoji(level);
    final timestamp = DateTime.now().toIso8601String();
    final tagStr = tag != null ? '[$tag] ' : '';
    final levelStr = level.name.toUpperCase().padRight(7);
    
    final logMessage = '$emoji $_prefix | $timestamp | $levelStr | $tagStr$message';
    
    // Print the main message
    debugPrint(logMessage);
    
    // Print additional data if available
    if (data != null) {
      debugPrint('   └─ Data: $data');
    }
    
    // Print stack trace for errors
    if (stackTrace != null) {
      debugPrint('   └─ Stack Trace:\n$stackTrace');
    }
  }

  /// Get emoji based on log level
  static String _getEmoji(LogLevel level) {
    switch (level) {
      case LogLevel.debug:
        return '🔍';
      case LogLevel.info:
        return 'ℹ️';
      case LogLevel.warning:
        return '⚠️';
      case LogLevel.error:
        return '❌';
    }
  }

  /// Log a separator line for visual clarity
  static void separator() {
    if (_enableLogging) {
      debugPrint('=' * 80);
    }
  }

  /// Log a section header
  static void section(String title) {
    if (_enableLogging) {
      separator();
      info(title);
      separator();
    }
  }
}

