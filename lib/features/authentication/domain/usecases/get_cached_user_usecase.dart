/// Get Cached User Use Case
/// Business logic for retrieving cached user data
library;

import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class GetCachedUserUseCase {
  final AuthRepository _repository;

  GetCachedUserUseCase({required AuthRepository repository})
      : _repository = repository;

  Future<UserEntity?> call() async {
    return await _repository.getCachedUser();
  }
}

