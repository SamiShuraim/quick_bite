/// Unit tests for CurrencyFormatter utility
/// Tests currency formatting for Saudi Riyal
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:quick_bite/core/utils/currency_formatter.dart';

void main() {
  group('CurrencyFormatter Tests', () {
    test('Should format price with 2 decimal places', () {
      expect(CurrencyFormatter.format(25.50), equals('SAR 25.50'));
      expect(CurrencyFormatter.format(100.99), equals('SAR 100.99'));
      expect(CurrencyFormatter.format(0.50), equals('SAR 0.50'));
    });

    test('Should format whole numbers with .00', () {
      expect(CurrencyFormatter.format(25), equals('SAR 25.00'));
      expect(CurrencyFormatter.format(100), equals('SAR 100.00'));
      expect(CurrencyFormatter.format(0), equals('SAR 0.00'));
    });

    test('Should format large amounts correctly', () {
      expect(CurrencyFormatter.format(1000.50), equals('SAR 1000.50'));
      expect(CurrencyFormatter.format(9999.99), equals('SAR 9999.99'));
    });

    test('Should format amounts with more than 2 decimal places', () {
      expect(CurrencyFormatter.format(25.555), equals('SAR 25.56')); // Rounds up
      expect(CurrencyFormatter.format(25.554), equals('SAR 25.55')); // Rounds down
    });

    test('Should format negative amounts', () {
      expect(CurrencyFormatter.format(-25.50), equals('SAR -25.50'));
      expect(CurrencyFormatter.format(-100), equals('SAR -100.00'));
    });

    test('Should format with custom decimal places', () {
      expect(CurrencyFormatter.formatWithDecimals(25.5, 0), equals('SAR 26'));
      expect(CurrencyFormatter.formatWithDecimals(25.5, 1), equals('SAR 25.5'));
      expect(CurrencyFormatter.formatWithDecimals(25.555, 3), equals('SAR 25.555'));
    });

    test('Currency code should be SAR', () {
      expect(CurrencyFormatter.currencyCode, equals('SAR'));
    });

    test('Should format small decimal amounts', () {
      expect(CurrencyFormatter.format(0.01), equals('SAR 0.01'));
      expect(CurrencyFormatter.format(0.99), equals('SAR 0.99'));
    });
  });
}
