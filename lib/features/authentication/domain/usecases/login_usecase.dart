/// Login Use Case
/// Business logic for user login
library;

import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository _repository;

  LoginUseCase({required AuthRepository repository})
      : _repository = repository;

  Future<UserEntity> call({
    required String email,
    required String password,
  }) async {
    // Input validation
    if (email.isEmpty) {
      throw ArgumentError('Email cannot be empty');
    }

    if (password.isEmpty) {
      throw ArgumentError('Password cannot be empty');
    }

    if (!_isValidEmail(email)) {
      throw ArgumentError('Invalid email format');
    }

    // Call repository
    return await _repository.login(
      email: email,
      password: password,
    );
  }

  bool _isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }
}

