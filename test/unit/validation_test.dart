/// Unit tests for form validation utilities
/// Tests email, password, phone number validation
library;

import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Email Validation Tests', () {
    String? validateEmail(String? value) {
      if (value == null || value.isEmpty) {
        return 'Please enter your email';
      }
      // Basic email validation
      final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
      if (!emailRegex.hasMatch(value)) {
        return 'Please enter a valid email';
      }
      return null;
    }

    test('Valid email should pass validation', () {
      expect(validateEmail('test@example.com'), isNull);
      expect(validateEmail('user.name@domain.co.uk'), isNull);
      expect(validateEmail('user123@test-domain.com'), isNull);
    });

    test('Invalid email should fail validation', () {
      expect(validateEmail('invalid'), isNotNull);
      expect(validateEmail('invalid@'), isNotNull);
      expect(validateEmail('@example.com'), isNotNull);
      expect(validateEmail('test@.com'), isNotNull);
      expect(validateEmail('test space@example.com'), isNotNull);
    });

    test('Empty email should fail validation', () {
      expect(validateEmail(''), equals('Please enter your email'));
      expect(validateEmail(null), equals('Please enter your email'));
    });
  });

  group('Password Validation Tests', () {
    String? validatePassword(String? value) {
      if (value == null || value.isEmpty) {
        return 'Please enter your password';
      }
      if (value.length < 6) {
        return 'Password must be at least 6 characters';
      }
      return null;
    }

    test('Valid password should pass validation', () {
      expect(validatePassword('password123'), isNull);
      expect(validatePassword('P@ssw0rd!'), isNull);
      expect(validatePassword('123456'), isNull);
    });

    test('Short password should fail validation', () {
      expect(validatePassword('12345'), equals('Password must be at least 6 characters'));
      expect(validatePassword('abc'), equals('Password must be at least 6 characters'));
    });

    test('Empty password should fail validation', () {
      expect(validatePassword(''), equals('Please enter your password'));
      expect(validatePassword(null), equals('Please enter your password'));
    });
  });

  group('Phone Number Validation Tests', () {
    String? validatePhone(String? value) {
      if (value == null || value.isEmpty) {
        return 'Please enter your phone number';
      }
      // Saudi Arabia phone format: +966 followed by 9 digits
      final phoneRegex = RegExp(r'^\+966[0-9]{9}$');
      if (!phoneRegex.hasMatch(value.replaceAll(' ', ''))) {
        return 'Please enter a valid Saudi phone number (+966xxxxxxxxx)';
      }
      return null;
    }

    test('Valid Saudi phone number should pass validation', () {
      expect(validatePhone('+966501234567'), isNull);
      expect(validatePhone('+966 50 123 4567'), isNull);
      expect(validatePhone('+966555555555'), isNull);
    });

    test('Invalid phone number should fail validation', () {
      expect(validatePhone('+965501234567'), isNotNull); // Wrong country code
      expect(validatePhone('+96650123456'), isNotNull); // Too short
      expect(validatePhone('0501234567'), isNotNull); // Missing country code
      expect(validatePhone('+966abc123456'), isNotNull); // Contains letters
    });

    test('Empty phone number should fail validation', () {
      expect(validatePhone(''), equals('Please enter your phone number'));
      expect(validatePhone(null), equals('Please enter your phone number'));
    });
  });

  group('Name Validation Tests', () {
    String? validateName(String? value) {
      if (value == null || value.isEmpty) {
        return 'Please enter your name';
      }
      if (value.length < 2) {
        return 'Name must be at least 2 characters';
      }
      if (value.length > 50) {
        return 'Name must be less than 50 characters';
      }
      return null;
    }

    test('Valid name should pass validation', () {
      expect(validateName('John Doe'), isNull);
      expect(validateName('Ali'), isNull);
      expect(validateName('Mohammad Al-Faisal'), isNull);
    });

    test('Short name should fail validation', () {
      expect(validateName('A'), equals('Name must be at least 2 characters'));
    });

    test('Long name should fail validation', () {
      final longName = 'A' * 51;
      expect(validateName(longName), equals('Name must be less than 50 characters'));
    });

    test('Empty name should fail validation', () {
      expect(validateName(''), equals('Please enter your name'));
      expect(validateName(null), equals('Please enter your name'));
    });
  });

  group('Price Validation Tests', () {
    String? validatePrice(String? value) {
      if (value == null || value.isEmpty) {
        return 'Please enter a price';
      }
      final price = double.tryParse(value);
      if (price == null) {
        return 'Please enter a valid number';
      }
      if (price < 0) {
        return 'Price cannot be negative';
      }
      if (price > 10000) {
        return 'Price cannot exceed 10,000 SAR';
      }
      return null;
    }

    test('Valid price should pass validation', () {
      expect(validatePrice('25.50'), isNull);
      expect(validatePrice('100'), isNull);
      expect(validatePrice('0'), isNull);
      expect(validatePrice('9999.99'), isNull);
    });

    test('Invalid price should fail validation', () {
      expect(validatePrice('abc'), equals('Please enter a valid number'));
      expect(validatePrice('-10'), equals('Price cannot be negative'));
      expect(validatePrice('10001'), equals('Price cannot exceed 10,000 SAR'));
    });

    test('Empty price should fail validation', () {
      expect(validatePrice(''), equals('Please enter a price'));
      expect(validatePrice(null), equals('Please enter a price'));
    });
  });

  group('Order Quantity Validation Tests', () {
    String? validateQuantity(String? value) {
      if (value == null || value.isEmpty) {
        return 'Please enter quantity';
      }
      final quantity = int.tryParse(value);
      if (quantity == null) {
        return 'Please enter a valid number';
      }
      if (quantity < 1) {
        return 'Quantity must be at least 1';
      }
      if (quantity > 50) {
        return 'Quantity cannot exceed 50';
      }
      return null;
    }

    test('Valid quantity should pass validation', () {
      expect(validateQuantity('1'), isNull);
      expect(validateQuantity('10'), isNull);
      expect(validateQuantity('50'), isNull);
    });

    test('Invalid quantity should fail validation', () {
      expect(validateQuantity('0'), equals('Quantity must be at least 1'));
      expect(validateQuantity('-5'), equals('Quantity must be at least 1'));
      expect(validateQuantity('51'), equals('Quantity cannot exceed 50'));
      expect(validateQuantity('abc'), equals('Please enter a valid number'));
    });

    test('Empty quantity should fail validation', () {
      expect(validateQuantity(''), equals('Please enter quantity'));
      expect(validateQuantity(null), equals('Please enter quantity'));
    });
  });
}
