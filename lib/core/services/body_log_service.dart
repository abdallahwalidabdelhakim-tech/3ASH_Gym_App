/// Body log management service
///
/// Handles operations for managing user's body measurement logs (weight, measurements).
/// Provides CRUD operations for body log data.
library;
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/app_config.dart';
import '../models/body_log.dart';
import '../errors/exceptions.dart';

class BodyLogService {
  /// API base URL from configuration
  static final String baseUrl = AppConfig.baseUrl;

  /// Normalizes base URL by removing trailing slash
  static String get _normalizedBaseUrl {
    if (baseUrl.endsWith('/')) {
      return baseUrl.substring(0, baseUrl.length - 1);
    }
    return baseUrl;
  }

  /// Creates URI from path and base URL
  static Uri _uri(String path) {
    return Uri.parse('$_normalizedBaseUrl$path');
  }

  /// Generic GET request helper
  /// 
  /// Sends a GET request to the backend API.
  /// 
  /// Parameters:
  /// - path: API endpoint path
  /// - headers: Optional request headers
  /// Returns: Future with response data
  Future<Map<String, dynamic>> _getJson(String path, {Map<String, String>? headers}) async {
    try {
      final response = await http
          .get(
            _uri(path),
            headers: headers,
          )
          .timeout(const Duration(seconds: 15));

      Map<String, dynamic> data = {};
      if (response.body.isNotEmpty) {
        final decoded = jsonDecode(response.body);
        if (decoded is Map<String, dynamic>) {
          data = decoded;
        }
      }

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return data;
      }

      if (response.statusCode == 401) {
        throw const AuthorizationException('Unauthorized');
      } else if (response.statusCode == 400) {
        throw ValidationException(
          data['message'] as String? ?? 'Invalid request',
        );
      } else if (response.statusCode == 404) {
        throw ApiException('Endpoint not found', response.statusCode);
      } else if (response.statusCode >= 500) {
        throw ApiException('Server error', response.statusCode);
      } else {
        throw ApiException(
          data['message'] as String? ?? 'Request failed',
          response.statusCode,
        );
      }
    } catch (e) {
      if (e is ApiException || e is ValidationException || e is AuthorizationException) {
        rethrow;
      } else if (e is TimeoutException) {
        throw const TimeoutException('Request timed out');
      } else {
        throw const NetworkException();
      }
    }
  }

  /// Generic POST request helper
  /// 
  /// Sends a POST request to the backend API.
  /// 
  /// Parameters:
  /// - path: API endpoint path
  /// - body: Request body as Map
  /// - headers: Optional request headers
  /// Returns: Future with response data
  Future<Map<String, dynamic>> _postJson(String path, Map<String, dynamic> body, {Map<String, String>? headers}) async {
    try {
      final response = await http
          .post(
            _uri(path),
            headers: {
              'Content-Type': 'application/json',
              ...?headers,
            },
            body: jsonEncode(body),
          )
          .timeout(const Duration(seconds: 15));

      Map<String, dynamic> data = {};
      if (response.body.isNotEmpty) {
        final decoded = jsonDecode(response.body);
        if (decoded is Map<String, dynamic>) {
          data = decoded;
        }
      }

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return data;
      }

      if (response.statusCode == 401) {
        throw const AuthorizationException('Unauthorized');
      } else if (response.statusCode == 400) {
        throw ValidationException(
          data['message'] as String? ?? 'Invalid request',
        );
      } else if (response.statusCode == 404) {
        throw ApiException('Endpoint not found', response.statusCode);
      } else if (response.statusCode >= 500) {
        throw ApiException('Server error', response.statusCode);
      } else {
        throw ApiException(
          data['message'] as String? ?? 'Request failed',
          response.statusCode,
        );
      }
    } catch (e) {
      if (e is ApiException || e is ValidationException || e is AuthorizationException) {
        rethrow;
      } else if (e is TimeoutException) {
        throw const TimeoutException('Request timed out');
      } else {
        throw const NetworkException();
      }
    }
  }

  /// Generic PATCH request helper
  /// 
  /// Sends a PATCH request to the backend API.
  /// 
  /// Parameters:
  /// - path: API endpoint path
  /// - body: Request body as Map
  /// - headers: Optional request headers
  /// Returns: Future with response data
  Future<Map<String, dynamic>> _patchJson(String path, Map<String, dynamic> body, {Map<String, String>? headers}) async {
    try {
      final response = await http
          .patch(
            _uri(path),
            headers: {
              'Content-Type': 'application/json',
              ...?headers,
            },
            body: jsonEncode(body),
          )
          .timeout(const Duration(seconds: 15));

      Map<String, dynamic> data = {};
      if (response.body.isNotEmpty) {
        final decoded = jsonDecode(response.body);
        if (decoded is Map<String, dynamic>) {
          data = decoded;
        }
      }

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return data;
      }

      if (response.statusCode == 401) {
        throw const AuthorizationException('Unauthorized');
      } else if (response.statusCode == 400) {
        throw ValidationException(
          data['message'] as String? ?? 'Invalid request',
        );
      } else if (response.statusCode == 404) {
        throw ApiException('Endpoint not found', response.statusCode);
      } else if (response.statusCode >= 500) {
        throw ApiException('Server error', response.statusCode);
      } else {
        throw ApiException(
          data['message'] as String? ?? 'Request failed',
          response.statusCode,
        );
      }
    } catch (e) {
      if (e is ApiException || e is ValidationException || e is AuthorizationException) {
        rethrow;
      } else if (e is TimeoutException) {
        throw const TimeoutException('Request timed out');
      } else {
        throw const NetworkException();
      }
    }
  }

  /// Generic DELETE request helper
  /// 
  /// Sends a DELETE request to the backend API.
  /// 
  /// Parameters:
  /// - path: API endpoint path
  /// - headers: Optional request headers
  /// Returns: Future with response data
  Future<Map<String, dynamic>> _deleteJson(String path, {Map<String, String>? headers}) async {
    try {
      final response = await http
          .delete(
            _uri(path),
            headers: headers,
          )
          .timeout(const Duration(seconds: 15));

      Map<String, dynamic> data = {};
      if (response.body.isNotEmpty) {
        final decoded = jsonDecode(response.body);
        if (decoded is Map<String, dynamic>) {
          data = decoded;
        }
      }

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return data;
      }

      return {
        'success': false,
        'message': (data['message'] as String?) ?? 'Request failed',
      };
    } catch (e) {
      return {
        'success': false,
        'message': e.toString(),
      };
    }
  }

  /// Gets all body logs for authenticated user
  /// 
  /// Retrieves the complete history of body measurement logs.
  /// 
  /// Parameters:
  /// - token: Authentication token
  /// Returns: Future with list of BodyLog objects
  Future<List<BodyLog>> getBodyLogs(String token) async {
    final data = await _getJson(
      '/metrics/history',
      headers: {'Authorization': 'Bearer $token'},
    );

    if (data['success'] == true) {
      final logsData = data['bodyLogs'] as List?;
      if (logsData != null) {
        return logsData.map((json) => BodyLog.fromJson(json)).toList();
      }
    }

    return [];
  }

  /// Gets body log by ID
  /// 
  /// Retrieves a specific body log entry by its unique identifier.
  /// 
  /// Parameters:
  /// - id: Body log ID
  /// - token: Authentication token
  /// Returns: Future with BodyLog or null if not found
  Future<BodyLog?> getBodyLogById(String id, String token) async {
    final data = await _getJson(
      '/metrics/history/$id',
      headers: {'Authorization': 'Bearer $token'},
    );

    if (data['success'] == true) {
      final logData = data['bodyLog'] as Map<String, dynamic>?;
      if (logData != null) {
        return BodyLog.fromJson(logData);
      }
    }

    return null;
  }

  /// Creates a new body log
  /// 
  /// Saves a new body measurement log.
  /// 
  /// Parameters:
  /// - log: BodyLog object to create
  /// - token: Authentication token
  /// Returns: Future with created BodyLog or null if failed
  Future<BodyLog?> createBodyLog(BodyLog log, String token) async {
    final data = await _postJson(
      '/metrics/weight',
      log.toJson(),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (data['success'] == true) {
      final logData = data['bodyLog'] as Map<String, dynamic>?;
      if (logData != null) {
        return BodyLog.fromJson(logData);
      }
    }

    return null;
  }

  /// Updates an existing body log
  /// 
  /// Modifies an existing body measurement log.
  /// 
  /// Parameters:
  /// - id: Body log ID to update
  /// - log: Updated BodyLog object
  /// - token: Authentication token
  /// Returns: Future with updated BodyLog or null if failed
  Future<BodyLog?> updateBodyLog(String id, BodyLog log, String token) async {
    final data = await _patchJson(
      '/metrics/history/$id',
      log.toJson(),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (data['success'] == true) {
      final logData = data['bodyLog'] as Map<String, dynamic>?;
      if (logData != null) {
        return BodyLog.fromJson(logData);
      }
    }

    return null;
  }

  /// Deletes a body log
  /// 
  /// Removes a body measurement log from the database.
  /// 
  /// Parameters:
  /// - id: Body log ID to delete
  /// - token: Authentication token
  /// Returns: Future with boolean indicating success
  Future<bool> deleteBodyLog(String id, String token) async {
    final data = await _deleteJson(
      '/metrics/history/$id',
      headers: {'Authorization': 'Bearer $token'},
    );

    return data['success'] == true;
  }

  /// Gets body log for a specific date
  /// 
  /// Retrieves the body log entry for a specific date.
  /// 
  /// Parameters:
  /// - date: Date string (YYYY-MM-DD format)
  /// - token: Authentication token
  /// Returns: Future with BodyLog or null if not found
  Future<BodyLog?> getBodyLogByDate(String date, String token) async {
    final data = await _getJson(
      '/metrics/history/date/$date',
      headers: {'Authorization': 'Bearer $token'},
    );

    if (data['success'] == true) {
      final logData = data['bodyLog'] as Map<String, dynamic>?;
      if (logData != null) {
        return BodyLog.fromJson(logData);
      }
    }

    return null;
  }
}
