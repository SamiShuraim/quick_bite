/// Authentication Repository Implementation
/// Implements authentication business logic
library;

import '../../../../core/utils/app_logger.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_datasource.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final AuthLocalDataSource _localDataSource;

  AuthRepositoryImpl({
    required AuthRemoteDataSource remoteDataSource,
    required AuthLocalDataSource localDataSource,
  })  : _remoteDataSource = remoteDataSource,
        _localDataSource = localDataSource;

  @override
  Future<UserEntity> register({
    required String email,
    required String password,
    required String name,
    String? phone,
  }) async {
    try {
      AppLogger.info('Registering user through repository');

      // Call API
      final response = await _remoteDataSource.register(
        email: email,
        password: password,
        name: name,
        phone: phone,
      );

      // Save auth data locally
      if (response.data != null) {
        await _localDataSource.saveAuthData(
          accessToken: response.data!.tokens.accessToken,
          refreshToken: response.data!.tokens.refreshToken,
          user: response.data!.user,
        );
      }

      AppLogger.info('User registered and auth data saved');
      return response.data!.user.toEntity();
    } catch (e, stackTrace) {
      AppLogger.error('Registration failed in repository',
          error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  @override
  Future<UserEntity> login({
    required String email,
    required String password,
  }) async {
    try {
      AppLogger.info('Logging in user through repository');

      // Call API
      final response = await _remoteDataSource.login(
        email: email,
        password: password,
      );

      // Save auth data locally
      if (response.data != null) {
        await _localDataSource.saveAuthData(
          accessToken: response.data!.tokens.accessToken,
          refreshToken: response.data!.tokens.refreshToken,
          user: response.data!.user,
        );
      }

      AppLogger.info('User logged in and auth data saved');
      return response.data!.user.toEntity();
    } catch (e, stackTrace) {
      AppLogger.error('Login failed in repository',
          error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  @override
  Future<void> logout() async {
    try {
      AppLogger.info('Logging out user through repository');

      // Get refresh token
      final refreshToken = await _localDataSource.getRefreshToken();

      // Call API if refresh token exists
      if (refreshToken != null) {
        await _remoteDataSource.logout(refreshToken);
      }

      // Clear local data
      await _localDataSource.clearAuthData();

      AppLogger.info('User logged out and local data cleared');
    } catch (e, stackTrace) {
      AppLogger.error('Logout failed in repository',
          error: e, stackTrace: stackTrace);
      // Clear local data even if API call fails
      await _localDataSource.clearAuthData();
      rethrow;
    }
  }

  @override
  Future<UserEntity> getProfile() async {
    try {
      AppLogger.info('Fetching user profile through repository');

      final userModel = await _remoteDataSource.getProfile();

      // Update cached user
      final accessToken = await _localDataSource.getAccessToken();
      final refreshToken = await _localDataSource.getRefreshToken();

      if (accessToken != null && refreshToken != null) {
        await _localDataSource.saveAuthData(
          accessToken: accessToken,
          refreshToken: refreshToken,
          user: userModel,
        );
      }

      AppLogger.info('User profile fetched and cached');
      return userModel.toEntity();
    } catch (e, stackTrace) {
      AppLogger.error('Failed to fetch profile in repository',
          error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  @override
  Future<UserEntity?> getCachedUser() async {
    try {
      final userModel = await _localDataSource.getCachedUser();
      return userModel?.toEntity();
    } catch (e, stackTrace) {
      AppLogger.error('Failed to get cached user in repository',
          error: e, stackTrace: stackTrace);
      return null;
    }
  }

  @override
  Future<bool> isLoggedIn() async {
    try {
      return await _localDataSource.isLoggedIn();
    } catch (e, stackTrace) {
      AppLogger.error('Failed to check login status in repository',
          error: e, stackTrace: stackTrace);
      return false;
    }
  }

  @override
  Future<void> refreshToken() async {
    try {
      AppLogger.info('Refreshing token through repository');

      // Get refresh token
      final refreshToken = await _localDataSource.getRefreshToken();
      if (refreshToken == null) {
        throw Exception('No refresh token available');
      }

      // Call API
      final tokens = await _remoteDataSource.refreshToken(refreshToken);

      // Update tokens
      final cachedUser = await _localDataSource.getCachedUser();
      if (cachedUser != null) {
        await _localDataSource.saveAuthData(
          accessToken: tokens.accessToken,
          refreshToken: tokens.refreshToken,
          user: cachedUser,
        );
      }

      AppLogger.info('Token refreshed successfully');
    } catch (e, stackTrace) {
      AppLogger.error('Token refresh failed in repository',
          error: e, stackTrace: stackTrace);
      rethrow;
    }
  }
}

