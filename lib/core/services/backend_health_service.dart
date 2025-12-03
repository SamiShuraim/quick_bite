/// Backend Health Check Service
/// Checks if the backend server is running and handles cold starts
library;

import 'package:http/http.dart' as http;
import '../constants/api_constants.dart';
import '../utils/app_logger.dart';

class BackendHealthService {
  final http.Client _client;
  
  BackendHealthService({http.Client? client}) 
      : _client = client ?? http.Client();

  /// Check if backend is healthy and responding
  /// Returns true if backend is up, false otherwise
  Future<bool> checkHealth() async {
    try {
      AppLogger.info('Checking backend health at: ${ApiConstants.baseUrl}/health');
      
      final url = Uri.parse('${ApiConstants.baseUrl}/health');
      
      final response = await _client
          .get(url)
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () {
              AppLogger.warning('Health check timed out after 10 seconds');
              return http.Response('{"error": "timeout"}', 408);
            },
          );

      AppLogger.debug('Health check response: ${response.statusCode} - ${response.body}');

      if (response.statusCode == 200) {
        AppLogger.info('Backend is healthy ✓');
        return true;
      } else {
        AppLogger.warning('Backend health check failed with status: ${response.statusCode}');
        return false;
      }
    } catch (e, stackTrace) {
      AppLogger.error('Backend health check error', error: e, stackTrace: stackTrace);
      return false;
    }
  }

  /// Wait for backend to be ready with retry logic
  /// This handles cold starts by polling until the server responds
  /// Returns true when backend is ready, false if max retries exceeded
  Future<bool> waitForBackend({
    int maxRetries = 30, // Will try for ~5 minutes (30 * 10 seconds)
    Duration retryDelay = const Duration(seconds: 10),
  }) async {
    AppLogger.info('Waiting for backend to be ready...');
    
    for (int attempt = 1; attempt <= maxRetries; attempt++) {
      AppLogger.info('Health check attempt $attempt of $maxRetries');
      
      final isHealthy = await checkHealth();
      
      if (isHealthy) {
        AppLogger.info('Backend is ready after $attempt attempt(s)');
        return true;
      }
      
      if (attempt < maxRetries) {
        AppLogger.info('Waiting ${retryDelay.inSeconds} seconds before retry...');
        await Future.delayed(retryDelay);
      }
    }
    
    AppLogger.error('Backend failed to respond after $maxRetries attempts');
    return false;
  }

  /// Quick health check with shorter timeout
  /// Used for initial checks
  Future<bool> quickHealthCheck() async {
    try {
      AppLogger.info('Quick health check starting...');
      final url = Uri.parse('${ApiConstants.baseUrl}/health');
      AppLogger.info('Health check URL: $url');
      
      final response = await _client
          .get(url)
          .timeout(const Duration(seconds: 5));

      AppLogger.info('Quick health check response: ${response.statusCode}');
      AppLogger.debug('Response body: ${response.body}');

      final isHealthy = response.statusCode == 200;
      AppLogger.info('Quick health check result: $isHealthy');
      return isHealthy;
    } catch (e, stackTrace) {
      AppLogger.error('Quick health check failed', error: e, stackTrace: stackTrace);
      return false;
    }
  }

  void dispose() {
    _client.close();
  }
}

