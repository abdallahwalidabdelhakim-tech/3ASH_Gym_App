/// User profile and onboarding service
///
/// Handles user profile management and onboarding operations, switching between
/// real backend API and mock backend based on configuration.
library;
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/app_config.dart';
import 'auth_service.dart';
import 'mock_user_service.dart';
import '../errors/exceptions.dart';

class UserService {

  /// Creates a UserService instance
  UserService(this._authService);
  /// Authentication service instance
  final AuthService _authService;
  
  /// Mock user service instance for testing
  static final MockUserService _mockUser = MockUserService();

  /// Gets the API base URL from configuration
  static String get baseUrl => AppConfig.baseUrl;

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

  /// Generic authenticated GET request helper
  /// 
  /// Sends a GET request to the backend API with authentication token.
  /// 
  /// Parameters:
  /// - path: API endpoint path
  /// Returns: Future with response data
  Future<Map<String, dynamic>> _getJsonAuthed(String path) async {
    try {
      final token = await _authService.getToken();
      if (token == null || token.isEmpty) {
        throw const AuthorizationException('Not authenticated');
      }

      final response = await http
          .get(
            _uri(path),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
          )
          .timeout(const Duration(seconds: 15));

      Map<String, dynamic> data = {};
      if (response.body.isNotEmpty) {
        final decoded = jsonDecode(response.body);
        if (decoded is Map<String, dynamic>) {
          data = decoded;
        }
      }

      if (response.statusCode == 200) {
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

  /// Generic authenticated POST request helper
  /// 
  /// Sends a POST request to the backend API with authentication token.
  /// 
  /// Parameters:
  /// - path: API endpoint path
  /// - body: Request body as Map
  /// Returns: Future with response data
  Future<Map<String, dynamic>> _postJsonAuthed(
    String path,
    Map<String, dynamic> body,
  ) async {
    try {
      final token = await _authService.getToken();
      if (token == null || token.isEmpty) {
        throw const AuthorizationException('Not authenticated');
      }

      final response = await http
          .post(
            _uri(path),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
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

      if (response.statusCode == 200 || response.statusCode == 201) {
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

  /// Generic authenticated PUT request helper
  /// 
  /// Sends a PUT request to the backend API with authentication token.
  /// 
  /// Parameters:
  /// - path: API endpoint path
  /// - body: Request body as Map
  /// Returns: Future with response data
  Future<Map<String, dynamic>> _putJsonAuthed(
    String path,
    Map<String, dynamic> body,
  ) async {
    try {
      final token = await _authService.getToken();
      if (token == null || token.isEmpty) {
        throw const AuthorizationException('Not authenticated');
      }

      final response = await http
          .put(
            _uri(path),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
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

      if (response.statusCode == 200 || response.statusCode == 201) {
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

  /// Gets current user profile
  /// 
  /// Returns user profile information if authenticated.
  /// 
  /// Returns: Future with user profile data
  Future<Map<String, dynamic>> getCurrentUser() async {
    if (AppConfig.useMockBackend) {
      final user = await _mockUser.getCurrentUser();
      if (user == null) {
        throw const AuthorizationException('Not authenticated');
      }
      return user;
    }

    return _getJsonAuthed('/users/me');
  }

  /// Updates user profile information
  /// 
  /// Parameters:
  /// - username: New username (optional)
  /// - country: New country (optional)
  /// - phoneNumber: New phone number (optional)
  /// Returns: Future with update result
  Future<Map<String, dynamic>> updateProfile({
    String? username,
    String? country,
    String? phoneNumber,
  }) async {
    if (AppConfig.useMockBackend) {
      final result = await _mockUser.updateProfile(
        username: username,
        country: country,
        phoneNumber: phoneNumber,
      );
      if (result['success'] == false) {
        throw ValidationException(result['message'] as String? ?? 'Update failed');
      }
      return result;
    }

    final body = <String, dynamic>{};
    if (username != null) body['username'] = username;
    if (country != null) body['country'] = country;
    if (phoneNumber != null) body['phone_number'] = phoneNumber;

    return _putJsonAuthed('/users/me', body);
  }

  /// Gets user onboarding data
  /// 
  /// Returns onboarding information including fitness goals and preferences.
  /// 
  /// Returns: Future with onboarding data
  Future<Map<String, dynamic>> getOnboarding() async {
    if (AppConfig.useMockBackend) {
      final result = await _mockUser.getOnboarding();
      if (result['success'] == false) {
        throw ValidationException(result['message'] as String? ?? 'Onboarding data not found');
      }
      return result;
    }

    final result = await _getJsonAuthed('/users/me');
    if (result['success'] == true && result['user'] != null) {
      final user = result['user'] as Map<String, dynamic>;
      if (user.containsKey('onboarding')) {
        return {
          'success': true,
          'onboarding': user['onboarding'],
        };
      }
    }
    
    throw const ValidationException('Onboarding data not found');
  }

  /// Updates user onboarding data
  /// 
  /// Saves or updates user's onboarding information including fitness goals and preferences.
  /// 
  /// Parameters:
  /// - goal: Fitness goal (optional)
  /// - activityLevel: Activity level (optional)
  /// - sex: Biological sex (optional)
  /// - dateOfBirth: Date of birth (optional)
  /// - age: Age (optional)
  /// - height: Height in centimeters (optional)
  /// - weight: Current weight in kilograms (optional)
  /// - targetWeight: Target weight in kilograms (optional)
  /// - objective: Weekly weight change objective (optional)
  /// - targetCalories: Daily calorie target (optional)
  /// Returns: Future with update result
  Future<Map<String, dynamic>> updateOnboarding({
    String? goal,
    String? activityLevel,
    String? sex,
    String? dateOfBirth,
    int? age,
    double? height,
    double? weight,
    double? targetWeight,
    String? objective,
    int? targetCalories,
  }) async {
    if (AppConfig.useMockBackend) {
      final result = await _mockUser.updateOnboarding(
        goal: goal,
        activityLevel: activityLevel,
        sex: sex,
        dateOfBirth: dateOfBirth,
        age: age,
        height: height,
        weight: weight,
        targetWeight: targetWeight,
        objective: objective,
        targetCalories: targetCalories,
      );
      if (result['success'] == false) {
        throw ValidationException(result['message'] as String? ?? 'Update failed');
      }
      return result;
    }

    final body = <String, dynamic>{
      'goal': goal,
      'activity_level': activityLevel,
      'sex': sex,
      'date_of_birth': dateOfBirth,
      'age': age,
      'height': height,
      'weight': weight,
      'target_weight': targetWeight,
      'objective': objective,
      'target_calories': targetCalories,
    };

    return _postJsonAuthed('/users/onboarding', body);
  }
}