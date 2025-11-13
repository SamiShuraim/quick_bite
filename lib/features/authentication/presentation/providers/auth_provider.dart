/// Authentication Provider
/// State management for authentication
library;

import 'package:flutter/foundation.dart';
import '../../../../core/utils/app_logger.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/usecases/check_login_status_usecase.dart';
import '../../domain/usecases/get_cached_user_usecase.dart';
import '../../domain/usecases/get_profile_usecase.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/register_usecase.dart';

enum AuthState {
  initial,
  loading,
  authenticated,
  unauthenticated,
  error,
}

class AuthProvider extends ChangeNotifier {
  // Use cases
  final LoginUseCase _loginUseCase;
  final RegisterUseCase _registerUseCase;
  final LogoutUseCase _logoutUseCase;
  final GetProfileUseCase _getProfileUseCase;
  final GetCachedUserUseCase _getCachedUserUseCase;
  final CheckLoginStatusUseCase _checkLoginStatusUseCase;

  // State
  AuthState _state = AuthState.initial;
  UserEntity? _user;
  String? _errorMessage;

  AuthProvider({
    required LoginUseCase loginUseCase,
    required RegisterUseCase registerUseCase,
    required LogoutUseCase logoutUseCase,
    required GetProfileUseCase getProfileUseCase,
    required GetCachedUserUseCase getCachedUserUseCase,
    required CheckLoginStatusUseCase checkLoginStatusUseCase,
  })  : _loginUseCase = loginUseCase,
        _registerUseCase = registerUseCase,
        _logoutUseCase = logoutUseCase,
        _getProfileUseCase = getProfileUseCase,
        _getCachedUserUseCase = getCachedUserUseCase,
        _checkLoginStatusUseCase = checkLoginStatusUseCase;

  // Getters
  AuthState get state => _state;
  UserEntity? get user => _user;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _state == AuthState.authenticated;
  bool get isLoading => _state == AuthState.loading;

  /// Set state
  void _setState(AuthState newState) {
    _state = newState;
    notifyListeners();
  }

  /// Set user
  void _setUser(UserEntity? user) {
    _user = user;
    notifyListeners();
  }

  /// Set error
  void _setError(String message) {
    _errorMessage = message;
    _setState(AuthState.error);
  }

  /// Clear error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  /// Check authentication status on app start
  Future<void> checkAuthStatus() async {
    try {
      AppLogger.info('Checking authentication status');
      _setState(AuthState.loading);

      final isLoggedIn = await _checkLoginStatusUseCase();

      if (isLoggedIn) {
        final cachedUser = await _getCachedUserUseCase();
        if (cachedUser != null) {
          _setUser(cachedUser);
          _setState(AuthState.authenticated);
          AppLogger.info('User is authenticated');
          return;
        }
      }

      _setState(AuthState.unauthenticated);
      AppLogger.info('User is not authenticated');
    } catch (e, stackTrace) {
      AppLogger.error('Failed to check auth status',
          error: e, stackTrace: stackTrace);
      _setState(AuthState.unauthenticated);
    }
  }

  /// Register user
  Future<bool> register({
    required String email,
    required String password,
    required String name,
    String? phone,
  }) async {
    try {
      AppLogger.userAction('Register attempt', details: {'email': email});
      _setState(AuthState.loading);
      clearError();

      final user = await _registerUseCase(
        email: email,
        password: password,
        name: name,
        phone: phone,
      );

      _setUser(user);
      _setState(AuthState.authenticated);
      AppLogger.info('Registration successful');
      return true;
    } catch (e, stackTrace) {
      AppLogger.error('Registration failed', error: e, stackTrace: stackTrace);
      _setError(e.toString());
      return false;
    }
  }

  /// Login user
  Future<bool> login({
    required String email,
    required String password,
  }) async {
    try {
      AppLogger.userAction('Login attempt', details: {'email': email});
      _setState(AuthState.loading);
      clearError();

      final user = await _loginUseCase(
        email: email,
        password: password,
      );

      _setUser(user);
      _setState(AuthState.authenticated);
      AppLogger.info('Login successful');
      return true;
    } catch (e, stackTrace) {
      AppLogger.error('Login failed', error: e, stackTrace: stackTrace);
      _setError(_extractErrorMessage(e));
      return false;
    }
  }

  /// Logout user
  Future<void> logout() async {
    try {
      AppLogger.userAction('Logout');
      _setState(AuthState.loading);

      await _logoutUseCase();

      _setUser(null);
      _setState(AuthState.unauthenticated);
      AppLogger.info('Logout successful');
    } catch (e, stackTrace) {
      AppLogger.error('Logout failed', error: e, stackTrace: stackTrace);
      // Still clear user data even if API call fails
      _setUser(null);
      _setState(AuthState.unauthenticated);
    }
  }

  /// Get user profile
  Future<void> getProfile() async {
    try {
      AppLogger.info('Fetching user profile');
      _setState(AuthState.loading);

      final user = await _getProfileUseCase();

      _setUser(user);
      _setState(AuthState.authenticated);
      AppLogger.info('Profile fetched successfully');
    } catch (e, stackTrace) {
      AppLogger.error('Failed to fetch profile',
          error: e, stackTrace: stackTrace);
      _setError(_extractErrorMessage(e));
    }
  }

  /// Extract user-friendly error message
  String _extractErrorMessage(dynamic error) {
    final errorString = error.toString();

    // Handle ArgumentError
    if (error is ArgumentError) {
      return error.message.toString();
    }

    // Handle API errors
    if (errorString.contains('ApiException')) {
      final parts = errorString.split(': ');
      if (parts.length > 1) {
        return parts[1].split(' (Status:')[0];
      }
    }

    // Handle network errors
    if (errorString.contains('SocketException') ||
        errorString.contains('NetworkException')) {
      return 'Network error. Please check your connection.';
    }

    // Handle timeout errors
    if (errorString.contains('TimeoutException')) {
      return 'Request timeout. Please try again.';
    }

    // Default error message
    return 'An error occurred. Please try again.';
  }
}

