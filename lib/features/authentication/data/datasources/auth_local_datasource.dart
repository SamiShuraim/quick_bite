/// Authentication Local Data Source
/// Handles local storage for authentication data
library;

import '../../../../core/services/storage_service.dart';
import '../../../../core/utils/app_logger.dart';
import '../models/user_model.dart';

abstract class AuthLocalDataSource {
  Future<void> saveAuthData({
    required String accessToken,
    required String refreshToken,
    required UserModel user,
  });

  Future<String?> getAccessToken();
  Future<String?> getRefreshToken();
  Future<UserModel?> getCachedUser();
  Future<bool> isLoggedIn();
  Future<void> clearAuthData();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final StorageService _storageService;

  AuthLocalDataSourceImpl({required StorageService storageService})
      : _storageService = storageService;

  @override
  Future<void> saveAuthData({
    required String accessToken,
    required String refreshToken,
    required UserModel user,
  }) async {
    try {
      AppLogger.debug('Saving auth data locally');

      await _storageService.saveAccessToken(accessToken);
      await _storageService.saveRefreshToken(refreshToken);
      await _storageService.saveUserData(user.toJson());
      await _storageService.setLoggedIn(true);

      AppLogger.info('Auth data saved successfully');
    } catch (e, stackTrace) {
      AppLogger.error('Failed to save auth data',
          error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  @override
  Future<String?> getAccessToken() async {
    try {
      return await _storageService.getAccessToken();
    } catch (e, stackTrace) {
      AppLogger.error('Failed to get access token',
          error: e, stackTrace: stackTrace);
      return null;
    }
  }

  @override
  Future<String?> getRefreshToken() async {
    try {
      return await _storageService.getRefreshToken();
    } catch (e, stackTrace) {
      AppLogger.error('Failed to get refresh token',
          error: e, stackTrace: stackTrace);
      return null;
    }
  }

  @override
  Future<UserModel?> getCachedUser() async {
    try {
      final userData = await _storageService.getUserData();
      if (userData == null) return null;
      return UserModel.fromJson(userData);
    } catch (e, stackTrace) {
      AppLogger.error('Failed to get cached user',
          error: e, stackTrace: stackTrace);
      return null;
    }
  }

  @override
  Future<bool> isLoggedIn() async {
    try {
      return await _storageService.isLoggedIn();
    } catch (e, stackTrace) {
      AppLogger.error('Failed to check login status',
          error: e, stackTrace: stackTrace);
      return false;
    }
  }

  @override
  Future<void> clearAuthData() async {
    try {
      AppLogger.debug('Clearing auth data');
      await _storageService.clearAll();
      AppLogger.info('Auth data cleared successfully');
    } catch (e, stackTrace) {
      AppLogger.error('Failed to clear auth data',
          error: e, stackTrace: stackTrace);
      rethrow;
    }
  }
}

