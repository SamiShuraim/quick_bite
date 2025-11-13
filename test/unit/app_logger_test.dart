/// Unit tests for AppLogger utility
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:quick_bite/core/utils/app_logger.dart';

void main() {
  group('AppLogger Unit Tests', () {
    test('Should log debug message without error', () {
      // This test verifies that logger methods can be called without errors
      expect(
        () => AppLogger.debug('Test debug message'),
        returnsNormally,
      );
    });

    test('Should log info message without error', () {
      expect(
        () => AppLogger.info('Test info message', tag: 'TEST'),
        returnsNormally,
      );
    });

    test('Should log warning message without error', () {
      expect(
        () => AppLogger.warning('Test warning message'),
        returnsNormally,
      );
    });

    test('Should log error message without error', () {
      expect(
        () => AppLogger.error('Test error message', error: 'Test exception'),
        returnsNormally,
      );
    });

    test('Should log navigation event without error', () {
      expect(
        () => AppLogger.navigation('ScreenA', 'ScreenB'),
        returnsNormally,
      );
    });

    test('Should log user action without error', () {
      expect(
        () => AppLogger.userAction('Button Pressed', details: {'id': '123'}),
        returnsNormally,
      );
    });

    test('Should log lifecycle event without error', () {
      expect(
        () => AppLogger.lifecycle('TestScreen', 'initState'),
        returnsNormally,
      );
    });
  });
}

