/// Workout log management service
///
/// Handles operations for managing user's workout logs (exercise history).
/// Provides CRUD operations for workout log data.
library;
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/app_config.dart';
import '../models/workout_log.dart';
import '../errors/exceptions.dart';

class WorkoutLogService {
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

  /// Gets all workout logs for authenticated user
  /// 
  /// Retrieves the complete history of workout logs.
  /// 
  /// Parameters:
  /// - token: Authentication token
  /// Returns: Future with list of WorkoutLog objects
  Future<List<WorkoutLog>> getWorkoutLogs(String token) async {
    final data = await _getJson(
      '/workouts/logs',
      headers: {'Authorization': 'Bearer $token'},
    );

    if (data['success'] == true) {
      final logsData = data['workoutLogs'] as List?;
      if (logsData != null) {
        return logsData.map((json) => WorkoutLog.fromJson(json)).toList();
      }
    }

    return [];
  }

  /// Gets workout log by ID
  /// 
  /// Retrieves a specific workout log entry by its unique identifier.
  /// 
  /// Parameters:
  /// - id: Workout log ID
  /// - token: Authentication token
  /// Returns: Future with WorkoutLog or null if not found
  Future<WorkoutLog?> getWorkoutLogById(String id, String token) async {
    final data = await _getJson(
      '/workouts/logs/$id',
      headers: {'Authorization': 'Bearer $token'},
    );

    if (data['success'] == true) {
      final logData = data['workoutLog'] as Map<String, dynamic>?;
      if (logData != null) {
        return WorkoutLog.fromJson(logData);
      }
    }

    return null;
  }

  /// Creates a new workout log
  /// 
  /// Saves a new workout log entry.
  /// 
  /// Parameters:
  /// - log: WorkoutLog object to create
  /// - token: Authentication token
  /// Returns: Future with created WorkoutLog or null if failed
  Future<WorkoutLog?> createWorkoutLog(WorkoutLog log, String token) async {
    final data = await _postJson(
      '/workouts/logs',
      log.toJson(),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (data['success'] == true) {
      final logData = data['workoutLog'] as Map<String, dynamic>?;
      if (logData != null) {
        return WorkoutLog.fromJson(logData);
      }
    }

    return null;
  }

  /// Updates an existing workout log
  /// 
  /// Modifies an existing workout log entry.
  /// 
  /// Parameters:
  /// - id: Workout log ID to update
  /// - log: Updated WorkoutLog object
  /// - token: Authentication token
  /// Returns: Future with updated WorkoutLog or null if failed
  Future<WorkoutLog?> updateWorkoutLog(String id, WorkoutLog log, String token) async {
    final data = await _patchJson(
      '/workouts/logs/$id',
      log.toJson(),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (data['success'] == true) {
      final logData = data['workoutLog'] as Map<String, dynamic>?;
      if (logData != null) {
        return WorkoutLog.fromJson(logData);
      }
    }

    return null;
  }

  /// Deletes a workout log
  /// 
  /// Removes a workout log entry from the database.
  /// 
  /// Parameters:
  /// - id: Workout log ID to delete
  /// - token: Authentication token
  /// Returns: Future with boolean indicating success
  Future<bool> deleteWorkoutLog(String id, String token) async {
    final data = await _deleteJson(
      '/workouts/logs/$id',
      headers: {'Authorization': 'Bearer $token'},
    );

    return data['success'] == true;
  }

  /// Gets workout log for a specific date
  /// 
  /// Retrieves the workout log entry for a specific date.
  /// 
  /// Parameters:
  /// - date: Date string (YYYY-MM-DD format)
  /// - token: Authentication token
  /// Returns: Future with WorkoutLog or null if not found
  Future<WorkoutLog?> getWorkoutLogByDate(String date, String token) async {
    final data = await _getJson(
      '/workouts/logs/date/$date',
      headers: {'Authorization': 'Bearer $token'},
    );

    if (data['success'] == true) {
      final logData = data['workoutLog'] as Map<String, dynamic>?;
      if (logData != null) {
        return WorkoutLog.fromJson(logData);
      }
    }

    return null;
  }
}
