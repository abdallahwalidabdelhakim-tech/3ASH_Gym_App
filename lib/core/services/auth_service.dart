/// Authentication service
///
/// Handles all user authentication operations, switching between
/// real backend API and mock backend based on configuration.
/// 
/// Features:
/// - User login
/// - User registration
/// - Password recovery
/// - Token management
library;
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/user_model.dart';
import '../config/app_config.dart';
import 'mock_auth_service.dart';
import '../errors/exceptions.dart';

class AuthService {
  /// Gets the API base URL from configuration
  static String get baseUrl => AppConfig.baseUrl;
  
  /// Secure storage instance for token management
  static const _storage = FlutterSecureStorage();
  /// Key used to store authentication token
  static const String _tokenKey = 'auth_token';

  /// In-memory token for session-only storage
  String? _inMemoryToken;

  /// Mock authentication service instance for testing
  static final MockAuthService _mockAuth = MockAuthService();

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

  /// Generic unauthenticated POST request helper
  /// 
  /// Sends a POST request to the backend API without authentication.
  /// 
  /// Parameters:
  /// - path: API endpoint path
  /// - body: Request body as Map
  /// - okStatusCodes: Set of acceptable response status codes (defaults to {200})
  /// Returns: Future with response data
  Future<Map<String, dynamic>> _postJson(
    String path,
    Map<String, dynamic> body, {
    Set<int> okStatusCodes = const {200},
  }) async {
    try {
      final response = await http
          .post(
            _uri(path),
            headers: const {'Content-Type': 'application/json'},
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

      if (okStatusCodes.contains(response.statusCode)) {
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
  /// - okStatusCodes: Set of acceptable response status codes (defaults to {200})
  /// Returns: Future with response data
  Future<Map<String, dynamic>> _postJsonAuthed(
    String path,
    Map<String, dynamic> body, {
    Set<int> okStatusCodes = const {200},
  }) async {
    try {
      final token = await getToken();
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

      if (okStatusCodes.contains(response.statusCode)) {
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

  /// Authenticates a user with username and password
  /// 
  /// Attempts to login a user with the provided credentials.
  /// Returns user data and authentication token if successful.
  /// 
  /// Parameters:
  /// - username: User's username
  /// - password: User's password
  /// Returns: Future with login result including user data and token
  Future<Map<String, dynamic>> login({
    required String username,
    required String password,
    bool rememberMe = false,
  }) async {
    if (AppConfig.useMockBackend) {
      final result = await _mockAuth.login(username: username, password: password);
      // Mock backend doesn't use rememberMe logic for token generation in this simple implementation
      if (result['success'] == false) {
        throw AuthenticationException(result['message'] as String? ?? 'Login failed');
      }
      return result;
    }

    final data = await _postJson(
      '/auth/login',
      {
        'username': username,
        'password': password,
        'rememberMe': rememberMe,
      },
      okStatusCodes: const {200},
    );

    if (data['success'] == true) {
      final userJson = data['user'] as Map<String, dynamic>?;
      return {
        'success': true,
        'user': userJson != null ? UserModel.fromJson(userJson) : null,
        'token': data['token'],
      };
    }

    throw AuthenticationException(data['message'] as String? ?? 'Login failed');
  }

  /// Creates a new user account
  /// 
  /// Registers a new user with the provided information.
  /// Returns user data and authentication token if successful.
  /// 
  /// Parameters:
  /// - username: Desired username
  /// - email: Email address
  /// - password: Password
  /// - country: Country of residence
  /// - phoneNumber: Phone number
  /// Returns: Future with sign up result including user data and token
  Future<Map<String, dynamic>> signUp({
    required String username,
    required String email,
    required String password,
    required String country,
    required String phoneNumber,
  }) async {
    if (AppConfig.useMockBackend) {
      final result = await _mockAuth.signUp(
        username: username,
        email: email,
        password: password,
        country: country,
        phoneNumber: phoneNumber,
      );
      if (result['success'] == false) {
        throw AuthenticationException(result['message'] as String? ?? 'Sign up failed');
      }
      return result;
    }

    final data = await _postJson(
      '/auth/signup',
      {
        'username': username,
        'email': email,
        'password': password,
        'country': country,
        'phone_number': phoneNumber,
      },
      okStatusCodes: const {201},
    );

    if (data['success'] == true) {
      final userJson = data['user'] as Map<String, dynamic>?;
      return {
        'success': true,
        'user': userJson != null ? UserModel.fromJson(userJson) : null,
        'token': data['token'],
      };
    }

    throw AuthenticationException(data['message'] as String? ?? 'Sign up failed');
  }

  /// Sends password reset code to user's email
  /// 
  /// Initiates password recovery process by sending a reset code to the email.
  /// 
  /// Parameters:
  /// - email: User's email address
  /// Returns: Future with result of code sending operation
  Future<Map<String, dynamic>> sendResetCode(String email) async {
    if (AppConfig.useMockBackend) {
      final result = await _mockAuth.sendResetCode(email);
      if (result['success'] == false) {
        throw ValidationException(result['message'] as String? ?? 'Failed to send code');
      }
      return result;
    }

    final data = await _postJson(
      '/auth/send-reset-code',
      {'email': email},
      okStatusCodes: const {200},
    );

    if (data['success'] == true) {
      return {
        'success': true,
        'message': data['message'] ?? 'Code sent to email',
      };
    }

    throw ValidationException(data['message'] as String? ?? 'Failed to send code');
  }

  /// Verifies password reset code
  /// 
  /// Checks if the provided reset code is valid for the given email.
  /// 
  /// Parameters:
  /// - email: User's email address
  /// - code: Reset code to verify
  /// Returns: Future with verification result
  Future<Map<String, dynamic>> verifyResetCode({
    required String email,
    required String code,
  }) async {
    if (AppConfig.useMockBackend) {
      final result = await _mockAuth.verifyResetCode(email: email, code: code);
      if (result['success'] == false) {
        throw ValidationException(result['message'] as String? ?? 'Invalid code');
      }
      return result;
    }

    final data = await _postJson(
      '/auth/verify-reset-code',
      {
        'email': email,
        'code': code,
      },
      okStatusCodes: const {200},
    );

    if (data['success'] == true) {
      return {
        'success': true,
        'message': data['message'] ?? 'Code verified',
      };
    }

    throw ValidationException(data['message'] as String? ?? 'Invalid code');
  }

  /// Resets user's password
  /// 
  /// Resets user's password using the provided code and new password.
  /// 
  /// Parameters:
  /// - email: User's email address
  /// - code: Verification code
  /// - newPassword: New password to set
  /// Returns: Future with reset result
  Future<Map<String, dynamic>> resetPassword({
    required String email,
    required String code,
    required String newPassword,
  }) async {
    if (AppConfig.useMockBackend) {
      final result = await _mockAuth.resetPassword(
        email: email,
        code: code,
        newPassword: newPassword,
      );
      if (result['success'] == false) {
        throw ValidationException(result['message'] as String? ?? 'Failed to reset password');
      }
      return result;
    }

    final data = await _postJson(
      '/auth/reset-password',
      {
        'email': email,
        'code': code,
        'newPassword': newPassword,
      },
      okStatusCodes: const {200},
    );

    if (data['success'] == true) {
      return {
        'success': true,
        'message': data['message'] ?? 'Password reset successful',
      };
    }

    throw ValidationException(data['message'] as String? ?? 'Failed to reset password');
  }

  /// Changes user's password (authenticated)
  /// 
  /// Changes the password of an authenticated user.
  /// 
  /// Parameters:
  /// - oldPassword: Current password
  /// - newPassword: New password to set
  /// Returns: Future with password change result
  Future<Map<String, dynamic>> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    if (AppConfig.useMockBackend) {
      final result = await _mockAuth.changePassword(
        oldPassword: oldPassword,
        newPassword: newPassword,
      );
      if (result['success'] == false) {
        throw AuthenticationException(result['message'] as String? ?? 'Failed to change password');
      }
      return result;
    }

    final data = await _postJsonAuthed(
      '/auth/change-password',
      {
        'oldPassword': oldPassword,
        'newPassword': newPassword,
      },
      okStatusCodes: const {200},
    );

    if (data['success'] == true) {
      return {
        'success': true,
        'message': data['message'] ?? 'Password changed successfully',
      };
    }

    throw AuthenticationException(data['message'] as String? ?? 'Failed to change password');
  }

  /// Token management methods
  
  /// Saves authentication token
  /// 
  /// Parameters:
  /// - token: The token to save
  /// - persist: Whether to save to persistent storage (true) or memory only (false). Defaults to true.
  Future<void> saveToken(String token, {bool persist = true}) async {
    // Always save to in-memory variable for current session
    _inMemoryToken = token;
    
    if (persist) {
      await _storage.write(key: _tokenKey, value: token);
    } else {
      // If not persisting, ensure we clean up any previously persisted token
      await _storage.delete(key: _tokenKey);
    }
  }

  /// Retrieves saved authentication token
  /// 
  /// Returns: Future with token as String or null if not found
  Future<String?> getToken() async {
    // Check in-memory first
    if (_inMemoryToken != null && _inMemoryToken!.isNotEmpty) {
      return _inMemoryToken;
    }
    
    // Fallback to secure storage
    final token = await _storage.read(key: _tokenKey);
    if (token != null && token.isNotEmpty) {
      _inMemoryToken = token; // Cache it in memory
    }
    return token;
  }

  /// Clears authentication token from storage
  /// 
  /// Also cleans up any old shared preferences token if it exists.
  Future<void> clearToken() async {
    _inMemoryToken = null;
    await _storage.delete(key: _tokenKey);
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token'); // Clean up old storage if exists
  }

  /// Checks if user is authenticated
  /// 
  /// Returns: Future with boolean indicating if user is authenticated
  Future<bool> isAuthenticated() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }
}

