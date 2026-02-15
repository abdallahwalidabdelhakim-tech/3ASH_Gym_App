import 'package:shared_preferences/shared_preferences.dart';
import 'mock_auth_service.dart';

/// Mock user service for testing without backend
/// Simulates user profile and onboarding endpoints
class MockUserService {
  // In-memory storage for onboarding data
  static final Map<String, Map<String, dynamic>> _onboardingData = {};

  // Simulate network delay
  static Future<void> _delay() async {
    await Future.delayed(const Duration(milliseconds: 300));
  }

  // Get current user
  Future<Map<String, dynamic>?> getCurrentUser() async {
    await _delay();

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    
    final user = MockAuthService.getCurrentUser(token);
    if (user == null) {
      return null;
    }

    return {
      'success': true,
      'user': {
        'id': user['id'],
        'username': user['username'],
        'email': user['email'],
        'country': user['country'],
        'phone_number': user['phone_number'],
        'date_of_birth': user['date_of_birth'],
        'target_weight': _onboardingData[user['id']]?['target_weight'],
        'created_at': user['created_at'],
      },
    };
  }

  // Update user profile
  Future<Map<String, dynamic>> updateProfile({
    String? username,
    String? country,
    String? phoneNumber,
  }) async {
    await _delay();

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    
    final user = MockAuthService.getCurrentUser(token);
    if (user == null) {
      return {
        'success': false,
        'message': 'Not authenticated',
      };
    }

    // Check if username is already taken (if changing username)
    if (username != null && username != user['username']) {
      final usernameTaken = MockAuthService.isUsernameTaken(username, user['id'] as String);
      if (usernameTaken) {
        return {
          'success': false,
          'message': 'Username already in use',
        };
      }
    }

    // Update user data
    if (username != null) user['username'] = username;
    if (country != null) user['country'] = country;
    if (phoneNumber != null) user['phone_number'] = phoneNumber;

    return {
      'success': true,
      'user': {
        'id': user['id'],
        'username': user['username'],
        'email': user['email'],
        'country': user['country'],
        'phone_number': user['phone_number'],
        'date_of_birth': user['date_of_birth'],
        'created_at': user['created_at'],
      },
    };
  }

  // Get onboarding data
  Future<Map<String, dynamic>> getOnboarding() async {
    await _delay();

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    
    final user = MockAuthService.getCurrentUser(token);
    if (user == null) {
      return {
        'success': false,
        'message': 'Not authenticated',
      };
    }

    final userId = user['id'] as String;
    final onboarding = _onboardingData[userId];

    return {
      'success': true,
      'onboarding': onboarding,
    };
  }

  // Update onboarding data
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
    await _delay();

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    
    final user = MockAuthService.getCurrentUser(token);
    if (user == null) {
      return {
        'success': false,
        'message': 'Not authenticated',
      };
    }

    final userId = user['id'] as String;
    
    _onboardingData[userId] = {
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

    return {
      'success': true,
    };
  }
}

