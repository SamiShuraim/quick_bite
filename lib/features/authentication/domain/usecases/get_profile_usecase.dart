/// Get Profile Use Case
/// Business logic for fetching user profile
library;

import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class GetProfileUseCase {
  final AuthRepository _repository;

  GetProfileUseCase({required AuthRepository repository})
      : _repository = repository;

  Future<UserEntity> call() async {
    return await _repository.getProfile();
  }
}

