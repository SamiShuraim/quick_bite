/// Check Login Status Use Case
/// Business logic for checking if user is logged in
library;

import '../repositories/auth_repository.dart';

class CheckLoginStatusUseCase {
  final AuthRepository _repository;

  CheckLoginStatusUseCase({required AuthRepository repository})
      : _repository = repository;

  Future<bool> call() async {
    return await _repository.isLoggedIn();
  }
}

