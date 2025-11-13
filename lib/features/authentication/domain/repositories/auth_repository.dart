/// Authentication Repository Interface
/// Defines authentication operations
library;

import '../../data/models/user_model.dart';
import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<UserEntity> register({
    required String email,
    required String password,
    required String name,
    String? phone,
  });

  Future<UserEntity> login({
    required String email,
    required String password,
  });

  Future<void> logout();

  Future<UserEntity> getProfile();

  Future<UserEntity?> getCachedUser();

  Future<bool> isLoggedIn();

  Future<void> refreshToken();
}

