/// Currency formatter utility for QuickBite application
/// Formats prices in Saudi Riyal (SAR)
library;

class CurrencyFormatter {
  // Saudi Riyal currency code
  static const String currencyCode = 'SAR';

  /// Format a price value as Saudi Riyal
  /// Example: 18.99 -> "SAR 18.99"
  static String format(double price) {
    final formattedPrice = price.toStringAsFixed(2);
    return '$currencyCode $formattedPrice';
  }

  /// Format a price value with custom decimal places
  static String formatWithDecimals(double price, int decimals) {
    final formattedPrice = price.toStringAsFixed(decimals);
    return '$currencyCode $formattedPrice';
  }
}

