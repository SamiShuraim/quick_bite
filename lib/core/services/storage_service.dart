/// Storage Service
/// Secure storage for tokens and user data
library;

import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/api_constants.dart';
import '../utils/app_logger.dart';

class StorageService {
  final FlutterSecureStorage _secureStorage;
  final SharedPreferences _preferences;

  StorageService({
    required FlutterSecureStorage secureStorage,
    required SharedPreferences preferences,
  })  : _secureStorage = secureStorage,
        _preferences = preferences;

  // ============== TOKEN MANAGEMENT ==============

  /// Save access token
  Future<void> saveAccessToken(String token) async {
    try {
      await _secureStorage.write(
        key: ApiConstants.accessTokenKey,
        value: token,
      );
      AppLogger.debug('Access token saved');
    } catch (e, stackTrace) {
      AppLogger.error('Failed to save access token',
          error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// Get access token
  Future<String?> getAccessToken() async {
    try {
      return await _secureStorage.read(key: ApiConstants.accessTokenKey);
    } catch (e, stackTrace) {
      AppLogger.error('Failed to read access token',
          error: e, stackTrace: stackTrace);
      return null;
    }
  }

  /// Save refresh token
  Future<void> saveRefreshToken(String token) async {
    try {
      await _secureStorage.write(
        key: ApiConstants.refreshTokenKey,
        value: token,
      );
      AppLogger.debug('Refresh token saved');
    } catch (e, stackTrace) {
      AppLogger.error('Failed to save refresh token',
          error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// Get refresh token
  Future<String?> getRefreshToken() async {
    try {
      return await _secureStorage.read(key: ApiConstants.refreshTokenKey);
    } catch (e, stackTrace) {
      AppLogger.error('Failed to read refresh token',
          error: e, stackTrace: stackTrace);
      return null;
    }
  }

  /// Delete tokens
  Future<void> deleteTokens() async {
    try {
      await _secureStorage.delete(key: ApiConstants.accessTokenKey);
      await _secureStorage.delete(key: ApiConstants.refreshTokenKey);
      AppLogger.debug('Tokens deleted');
    } catch (e, stackTrace) {
      AppLogger.error('Failed to delete tokens',
          error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  // ============== USER DATA MANAGEMENT ==============

  /// Save user data
  Future<void> saveUserData(Map<String, dynamic> userData) async {
    try {
      final userDataJson = jsonEncode(userData);
      await _preferences.setString(ApiConstants.userDataKey, userDataJson);
      AppLogger.debug('User data saved');
    } catch (e, stackTrace) {
      AppLogger.error('Failed to save user data',
          error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// Get user data
  Future<Map<String, dynamic>?> getUserData() async {
    try {
      final userDataJson = _preferences.getString(ApiConstants.userDataKey);
      if (userDataJson == null) return null;
      return jsonDecode(userDataJson) as Map<String, dynamic>;
    } catch (e, stackTrace) {
      AppLogger.error('Failed to read user data',
          error: e, stackTrace: stackTrace);
      return null;
    }
  }

  /// Delete user data
  Future<void> deleteUserData() async {
    try {
      await _preferences.remove(ApiConstants.userDataKey);
      AppLogger.debug('User data deleted');
    } catch (e, stackTrace) {
      AppLogger.error('Failed to delete user data',
          error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  // ============== LOGIN STATE ==============

  /// Set login state
  Future<void> setLoggedIn(bool isLoggedIn) async {
    try {
      await _preferences.setBool(ApiConstants.isLoggedInKey, isLoggedIn);
      AppLogger.debug('Login state set: $isLoggedIn');
    } catch (e, stackTrace) {
      AppLogger.error('Failed to set login state',
          error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// Check if user is logged in
  Future<bool> isLoggedIn() async {
    try {
      return _preferences.getBool(ApiConstants.isLoggedInKey) ?? false;
    } catch (e, stackTrace) {
      AppLogger.error('Failed to check login state',
          error: e, stackTrace: stackTrace);
      return false;
    }
  }

  // ============== CLEAR ALL ==============

  /// Clear all stored data
  Future<void> clearAll() async {
    try {
      await deleteTokens();
      await deleteUserData();
      await setLoggedIn(false);
      AppLogger.debug('All storage cleared');
    } catch (e, stackTrace) {
      AppLogger.error('Failed to clear all storage',
          error: e, stackTrace: stackTrace);
      rethrow;
    }
  }
}

