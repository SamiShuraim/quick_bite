/// Register Use Case
/// Business logic for user registration
library;

import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository _repository;

  RegisterUseCase({required AuthRepository repository})
      : _repository = repository;

  Future<UserEntity> call({
    required String email,
    required String password,
    required String name,
    String? phone,
  }) async {
    // Input validation
    if (email.isEmpty) {
      throw ArgumentError('Email cannot be empty');
    }

    if (password.isEmpty) {
      throw ArgumentError('Password cannot be empty');
    }

    if (name.isEmpty) {
      throw ArgumentError('Name cannot be empty');
    }

    if (!_isValidEmail(email)) {
      throw ArgumentError('Invalid email format');
    }

    if (!_isValidPassword(password)) {
      throw ArgumentError(
        'Password must be at least 8 characters and contain uppercase, lowercase, and number',
      );
    }

    if (name.length < 2 || name.length > 50) {
      throw ArgumentError('Name must be between 2 and 50 characters');
    }

    if (phone != null && !_isValidPhone(phone)) {
      throw ArgumentError('Invalid phone number format');
    }

    // Call repository
    return await _repository.register(
      email: email,
      password: password,
      name: name,
      phone: phone,
    );
  }

  bool _isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }

  bool _isValidPassword(String password) {
    // At least 8 characters, 1 uppercase, 1 lowercase, 1 number
    if (password.length < 8) return false;
    if (!RegExp(r'[A-Z]').hasMatch(password)) return false;
    if (!RegExp(r'[a-z]').hasMatch(password)) return false;
    if (!RegExp(r'[0-9]').hasMatch(password)) return false;
    return true;
  }

  bool _isValidPhone(String phone) {
    final phoneRegex = RegExp(r'^\d{10,15}$');
    return phoneRegex.hasMatch(phone);
  }
}

