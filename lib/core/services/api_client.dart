/// API Client
/// HTTP client for making API requests
library;

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/api_constants.dart';
import '../utils/app_logger.dart';
import 'storage_service.dart';

class ApiClient {
  final StorageService _storageService;
  final http.Client _httpClient;

  ApiClient({
    required StorageService storageService,
    http.Client? httpClient,
  })  : _storageService = storageService,
        _httpClient = httpClient ?? http.Client();

  /// Get headers with authorization token
  Future<Map<String, String>> _getHeaders({bool includeAuth = true}) async {
    final headers = <String, String>{
      'Content-Type': ApiConstants.contentTypeJson,
      'Accept': ApiConstants.contentTypeJson,
    };

    if (includeAuth) {
      final token = await _storageService.getAccessToken();
      if (token != null) {
        headers[ApiConstants.authorizationHeader] =
            '${ApiConstants.bearerPrefix} $token';
      }
    }

    return headers;
  }

  /// GET request
  Future<Map<String, dynamic>> get(
    String endpoint, {
    bool includeAuth = true,
  }) async {
    try {
      final url = Uri.parse('${ApiConstants.baseUrl}$endpoint');
      final headers = await _getHeaders(includeAuth: includeAuth);

      AppLogger.debug('GET Request: $url');

      final response = await _httpClient
          .get(url, headers: headers)
          .timeout(ApiConstants.receiveTimeout);

      return _handleResponse(response);
    } catch (e, stackTrace) {
      AppLogger.error('GET Request Error', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// POST request
  Future<Map<String, dynamic>> post(
    String endpoint, {
    required Map<String, dynamic> body,
    bool includeAuth = true,
  }) async {
    try {
      final url = Uri.parse('${ApiConstants.baseUrl}$endpoint');
      final headers = await _getHeaders(includeAuth: includeAuth);

      AppLogger.debug('POST Request: $url', data: body);

      final response = await _httpClient
          .post(
            url,
            headers: headers,
            body: jsonEncode(body),
          )
          .timeout(ApiConstants.sendTimeout);

      return _handleResponse(response);
    } catch (e, stackTrace) {
      AppLogger.error('POST Request Error', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// PUT request
  Future<Map<String, dynamic>> put(
    String endpoint, {
    required Map<String, dynamic> body,
    bool includeAuth = true,
  }) async {
    try {
      final url = Uri.parse('${ApiConstants.baseUrl}$endpoint');
      final headers = await _getHeaders(includeAuth: includeAuth);

      AppLogger.debug('PUT Request: $url', data: body);

      final response = await _httpClient
          .put(
            url,
            headers: headers,
            body: jsonEncode(body),
          )
          .timeout(ApiConstants.sendTimeout);

      return _handleResponse(response);
    } catch (e, stackTrace) {
      AppLogger.error('PUT Request Error', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// PATCH request
  Future<Map<String, dynamic>> patch(
    String endpoint, {
    required Map<String, dynamic> body,
    bool includeAuth = true,
  }) async {
    try {
      final url = Uri.parse('${ApiConstants.baseUrl}$endpoint');
      final headers = await _getHeaders(includeAuth: includeAuth);

      AppLogger.debug('PATCH Request: $url', data: body);

      final response = await _httpClient
          .patch(
            url,
            headers: headers,
            body: jsonEncode(body),
          )
          .timeout(ApiConstants.sendTimeout);

      return _handleResponse(response);
    } catch (e, stackTrace) {
      AppLogger.error('PATCH Request Error', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// DELETE request
  Future<Map<String, dynamic>> delete(
    String endpoint, {
    bool includeAuth = true,
  }) async {
    try {
      final url = Uri.parse('${ApiConstants.baseUrl}$endpoint');
      final headers = await _getHeaders(includeAuth: includeAuth);

      AppLogger.debug('DELETE Request: $url');

      final response = await _httpClient
          .delete(url, headers: headers)
          .timeout(ApiConstants.receiveTimeout);

      return _handleResponse(response);
    } catch (e, stackTrace) {
      AppLogger.error('DELETE Request Error', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// Handle HTTP response
  Map<String, dynamic> _handleResponse(http.Response response) {
    AppLogger.debug(
      'Response: ${response.statusCode}',
      data: response.body.length > 500
          ? '${response.body.substring(0, 500)}...'
          : response.body,
    );

    final Map<String, dynamic> jsonResponse;

    try {
      jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
    } catch (e) {
      throw Exception('Invalid JSON response from server');
    }

    // Handle successful responses (2xx)
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonResponse;
    }

    // Handle error responses
    final errorMessage = jsonResponse['message'] as String? ??
        _getErrorMessageForStatusCode(response.statusCode);

    throw ApiException(
      message: errorMessage,
      statusCode: response.statusCode,
      errors: jsonResponse['errors'] as Map<String, dynamic>?,
    );
  }

  /// Get error message for HTTP status code
  String _getErrorMessageForStatusCode(int statusCode) {
    switch (statusCode) {
      case 400:
        return 'Bad request';
      case 401:
        return ApiConstants.unauthorizedError;
      case 403:
        return 'Access forbidden';
      case 404:
        return 'Resource not found';
      case 409:
        return 'Resource already exists';
      case 422:
        return 'Validation failed';
      case 429:
        return 'Too many requests. Please try again later.';
      case 500:
      case 502:
      case 503:
        return ApiConstants.serverError;
      default:
        return ApiConstants.unknownError;
    }
  }

  /// Dispose resources
  void dispose() {
    _httpClient.close();
  }
}

/// API Exception
class ApiException implements Exception {
  final String message;
  final int statusCode;
  final Map<String, dynamic>? errors;

  ApiException({
    required this.message,
    required this.statusCode,
    this.errors,
  });

  @override
  String toString() => 'ApiException: $message (Status: $statusCode)';
}

