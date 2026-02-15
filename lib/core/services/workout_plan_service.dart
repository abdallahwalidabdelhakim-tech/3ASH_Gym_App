/// Workout plan management service
///
/// Handles operations for managing user's workout plans.
/// Provides CRUD operations for workout plan data and related functionality.
library;
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/app_config.dart';

class WorkoutPlanService {
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

  /// Gets current workout plan for authenticated user
  /// 
  /// Retrieves the currently active workout plan for the user.
  /// 
  /// Parameters:
  /// - token: Authentication token
  /// Returns: Future with workout plan data or null
  Future<Map<String, dynamic>?> getCurrentWorkoutPlan(String token) async {
    final data = await _getJson(
      '/workouts/plans/current',
      headers: {'Authorization': 'Bearer $token'},
    );

    if (data['success'] == true) {
      return data['workoutPlan'] as Map<String, dynamic>?;
    }

    return null;
  }

  /// Gets all workout plans for authenticated user
  /// 
  /// Retrieves the complete list of workout plans associated with the user.
  /// 
  /// Parameters:
  /// - token: Authentication token
  /// Returns: Future with list of workout plan data
  Future<List<Map<String, dynamic>>> getWorkoutPlans(String token) async {
    final data = await _getJson(
      '/workouts/plans',
      headers: {'Authorization': 'Bearer $token'},
    );

    if (data['success'] == true) {
      final plansData = data['plans'] as List?;
      if (plansData != null) {
        return plansData.cast<Map<String, dynamic>>();
      }
    }

    return [];
  }

  /// Gets workout plan by ID
  /// 
  /// Retrieves a specific workout plan by its unique identifier.
  /// 
  /// Parameters:
  /// - id: Workout plan ID
  /// - token: Authentication token
  /// Returns: Future with workout plan data or null
  Future<Map<String, dynamic>?> getWorkoutPlanById(String id, String token) async {
    final data = await _getJson(
      '/workouts/plans/$id',
      headers: {'Authorization': 'Bearer $token'},
    );

    if (data['success'] == true) {
      return data['workoutPlan'] as Map<String, dynamic>?;
    }

    return null;
  }

  /// Creates a new workout plan
  /// 
  /// Saves a new workout plan.
  /// 
  /// Parameters:
  /// - plan: Workout plan data as Map
  /// - token: Authentication token
  /// Returns: Future with created workout plan data or null
  Future<Map<String, dynamic>?> createWorkoutPlan(Map<String, dynamic> plan, String token) async {
    final data = await _postJson(
      '/workouts/plans',
      plan,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (data['success'] == true) {
      return data['workoutPlan'] as Map<String, dynamic>?;
    }

    return null;
  }

  /// Updates an existing workout plan
  /// 
  /// Modifies an existing workout plan.
  /// 
  /// Parameters:
  /// - id: Workout plan ID to update
  /// - plan: Updated workout plan data as Map
  /// - token: Authentication token
  /// Returns: Future with updated workout plan data or null
  Future<Map<String, dynamic>?> updateWorkoutPlan(String id, Map<String, dynamic> plan, String token) async {
    final data = await _patchJson(
      '/workouts/plans/$id',
      plan,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (data['success'] == true) {
      return data['workoutPlan'] as Map<String, dynamic>?;
    }

    return null;
  }

  /// Deletes a workout plan
  /// 
  /// Removes a workout plan from the database.
  /// 
  /// Parameters:
  /// - id: Workout plan ID to delete
  /// - token: Authentication token
  /// Returns: Future with boolean indicating success
  Future<bool> deleteWorkoutPlan(String id, String token) async {
    final data = await _deleteJson(
      '/workouts/plans/$id',
      headers: {'Authorization': 'Bearer $token'},
    );

    return data['success'] == true;
  }

  /// Marks workout as completed
  /// 
  /// Marks a specific workout in a plan as completed.
  /// 
  /// Parameters:
  /// - id: Workout plan ID
  /// - token: Authentication token
  /// - date: Optional date string (YYYY-MM-DD format) to mark as completed
  /// Returns: Future with updated workout plan data or null
  Future<Map<String, dynamic>?> markWorkoutAsCompleted(String id, String token, {String? date}) async {
    final data = await _postJson(
      '/workouts/plans/$id/mark-complete',
      date != null ? {'date': date} : {},
      headers: {'Authorization': 'Bearer $token'},
    );

    if (data['success'] == true) {
      return data['workoutPlan'] as Map<String, dynamic>?;
    }

    return null;
  }
}
