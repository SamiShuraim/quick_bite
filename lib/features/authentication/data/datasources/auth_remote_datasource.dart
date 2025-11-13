/// Authentication Remote Data Source
/// Handles API calls for authentication
library;

import '../../../../core/constants/api_constants.dart';
import '../../../../core/services/api_client.dart';
import '../../../../core/utils/app_logger.dart';
import '../models/auth_response_model.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<AuthResponseModel> register({
    required String email,
    required String password,
    required String name,
    String? phone,
  });

  Future<AuthResponseModel> login({
    required String email,
    required String password,
  });

  Future<void> logout(String refreshToken);

  Future<TokensModel> refreshToken(String refreshToken);

  Future<UserModel> getProfile();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient _apiClient;

  AuthRemoteDataSourceImpl({required ApiClient apiClient})
      : _apiClient = apiClient;

  @override
  Future<AuthResponseModel> register({
    required String email,
    required String password,
    required String name,
    String? phone,
  }) async {
    try {
      AppLogger.info('Registering user: $email');

      final response = await _apiClient.post(
        ApiConstants.registerEndpoint,
        body: {
          'email': email,
          'password': password,
          'name': name,
          if (phone != null) 'phone': phone,
        },
        includeAuth: false,
      );

      final authResponse = AuthResponseModel.fromJson(response);
      AppLogger.info('User registered successfully');
      return authResponse;
    } catch (e, stackTrace) {
      AppLogger.error('Registration failed', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  @override
  Future<AuthResponseModel> login({
    required String email,
    required String password,
  }) async {
    try {
      AppLogger.info('Logging in user: $email');

      final response = await _apiClient.post(
        ApiConstants.loginEndpoint,
        body: {
          'email': email,
          'password': password,
        },
        includeAuth: false,
      );

      final authResponse = AuthResponseModel.fromJson(response);
      AppLogger.info('User logged in successfully');
      return authResponse;
    } catch (e, stackTrace) {
      AppLogger.error('Login failed', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  @override
  Future<void> logout(String refreshToken) async {
    try {
      AppLogger.info('Logging out user');

      await _apiClient.post(
        ApiConstants.logoutEndpoint,
        body: {
          'refreshToken': refreshToken,
        },
        includeAuth: false,
      );

      AppLogger.info('User logged out successfully');
    } catch (e, stackTrace) {
      AppLogger.error('Logout failed', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  @override
  Future<TokensModel> refreshToken(String refreshToken) async {
    try {
      AppLogger.info('Refreshing access token');

      final response = await _apiClient.post(
        ApiConstants.refreshTokenEndpoint,
        body: {
          'refreshToken': refreshToken,
        },
        includeAuth: false,
      );

      final tokens = TokensModel.fromJson(response['data'] as Map<String, dynamic>);
      AppLogger.info('Access token refreshed successfully');
      return tokens;
    } catch (e, stackTrace) {
      AppLogger.error('Token refresh failed', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  @override
  Future<UserModel> getProfile() async {
    try {
      AppLogger.info('Fetching user profile');

      final response = await _apiClient.get(
        ApiConstants.profileEndpoint,
        includeAuth: true,
      );

      final userData = response['data']['user'] as Map<String, dynamic>;
      final user = UserModel.fromJson(userData);
      AppLogger.info('User profile fetched successfully');
      return user;
    } catch (e, stackTrace) {
      AppLogger.error('Failed to fetch profile',
          error: e, stackTrace: stackTrace);
      rethrow;
    }
  }
}

