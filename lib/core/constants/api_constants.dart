/// API Constants
/// All API-related constants and endpoints
library;

class ApiConstants {
  ApiConstants._();

  // Base Configuration
  static const String baseUrl = 'http://localhost:3000';
  static const String apiVersion = 'v1';
  static const String apiPrefix = '/api/$apiVersion';

  // Timeouts
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 30);

  // Headers
  static const String contentTypeJson = 'application/json';
  static const String authorizationHeader = 'Authorization';
  static const String bearerPrefix = 'Bearer';

  // Storage Keys
  static const String accessTokenKey = 'access_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userDataKey = 'user_data';
  static const String isLoggedInKey = 'is_logged_in';

  // Auth Endpoints
  static const String authBasePath = '/auth';
  static const String registerEndpoint = '$apiPrefix$authBasePath/register';
  static const String loginEndpoint = '$apiPrefix$authBasePath/login';
  static const String logoutEndpoint = '$apiPrefix$authBasePath/logout';
  static const String refreshTokenEndpoint = '$apiPrefix$authBasePath/refresh';
  static const String profileEndpoint = '$apiPrefix$authBasePath/profile';
  static const String forgotPasswordEndpoint =
      '$apiPrefix$authBasePath/forgot-password';
  static const String resetPasswordEndpoint =
      '$apiPrefix$authBasePath/reset-password';
  static const String verifyEmailEndpoint = '$apiPrefix$authBasePath/verify-email';

  // Health Check
  static const String healthEndpoint = '/health';

  // Error Messages
  static const String networkError = 'Network error. Please check your connection.';
  static const String serverError = 'Server error. Please try again later.';
  static const String timeoutError = 'Request timeout. Please try again.';
  static const String unauthorizedError = 'Session expired. Please login again.';
  static const String unknownError = 'An unexpected error occurred.';
}

