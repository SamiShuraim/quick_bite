/// API Constants for QuickBite application
/// Contains all API endpoints and configuration
library;

class ApiConstants {
  ApiConstants._();

  // Base URL - Using deployed backend on Render
  static const String baseUrl = 'https://quick-bite-fxch.onrender.com'; // Production backend
  // static const String baseUrl = 'http://10.0.2.2:3000'; // For Android Emulator (local)
  // static const String baseUrl = 'http://localhost:3000'; // For iOS Simulator (local)
  // static const String baseUrl = 'http://192.168.x.x:3000'; // For physical device (use your computer's IP)
  
  static const String apiVersion = 'v1';
  static const String apiBasePath = '/api/$apiVersion';

  // Health Check Endpoint
  static const String healthEndpoint = '/health';

  // Authentication Endpoints
  static const String authBasePath = '$apiBasePath/auth';
  static const String loginEndpoint = '$authBasePath/login';
  static const String registerEndpoint = '$authBasePath/register';
  static const String logoutEndpoint = '$authBasePath/logout';
  static const String refreshTokenEndpoint = '$authBasePath/refresh';
  static const String profileEndpoint = '$authBasePath/profile';

  // Restaurant Endpoints
  static const String restaurantsEndpoint = '$apiBasePath/restaurants';
  
  static String restaurantByIdEndpoint(String id) => '$restaurantsEndpoint/$id';
  
  static String restaurantMenuEndpoint(String restaurantId) =>
      '$restaurantsEndpoint/$restaurantId/menu';
  
  static String menuItemByIdEndpoint(String id) => '$apiBasePath/menu-items/$id';

  // Payment Endpoints
  static const String paymentBasePath = '$apiBasePath/payment';
  static const String savedCardsEndpoint = '$paymentBasePath/cards';
  static String savedCardByIdEndpoint(String id) => '$savedCardsEndpoint/$id';
  static String setDefaultCardEndpoint(String id) => '$savedCardsEndpoint/$id/default';
  static const String processPaymentEndpoint = '$paymentBasePath/process';

  // Order Endpoints
  static const String ordersEndpoint = '$apiBasePath/orders';
  static String orderByIdEndpoint(String id) => '$ordersEndpoint/$id';
  static String cancelOrderEndpoint(String id) => '$ordersEndpoint/$id/cancel';
  static String updateOrderStatusEndpoint(String id) => '$ordersEndpoint/$id/status';

  // Request Timeouts
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  // Cache Duration
  static const Duration restaurantsCacheDuration = Duration(minutes: 15);
  static const Duration menuItemsCacheDuration = Duration(minutes: 30);

  // Headers
  static const Map<String, String> defaultHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  static const String contentTypeJson = 'application/json';
  static const String authorizationHeader = 'Authorization';
  static const String bearerPrefix = 'Bearer ';

  // Storage Keys
  static const String accessTokenKey = 'access_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userDataKey = 'user_data';
  static const String isLoggedInKey = 'is_logged_in';

  // Query Parameters
  static const String categoryParam = 'category';
  static const String searchParam = 'search';
  static const String minRatingParam = 'minRating';
  static const String maxDistanceParam = 'maxDistance';

  // Timeouts
  static const Duration sendTimeout = Duration(seconds: 30);

  // Error Messages
  static const String unauthorizedError = 'Unauthorized. Please login again.';
  static const String serverError = 'Server error. Please try again later.';
  static const String unknownError = 'An unknown error occurred.';
}
