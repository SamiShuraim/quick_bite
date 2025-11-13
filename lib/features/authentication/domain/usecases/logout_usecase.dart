/// Logout Use Case
/// Business logic for user logout
library;

import '../repositories/auth_repository.dart';

class LogoutUseCase {
  final AuthRepository _repository;

  LogoutUseCase({required AuthRepository repository})
      : _repository = repository;

  Future<void> call() async {
    await _repository.logout();
  }
}

