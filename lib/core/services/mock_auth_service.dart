import 'dart:async';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Mock authentication service for testing without backend
/// Simulates all backend authentication endpoints
class MockAuthService {
  // In-memory storage for mock data
  static final Map<String, Map<String, dynamic>> _mockUsers = {};
  static final Map<String, String> _mockTokens = {}; // token -> userId
  static final Map<String, Map<String, dynamic>> _resetCodes = {};

  // Simulate network delay
  static Future<void> _delay() async {
    await Future.delayed(const Duration(milliseconds: 500));
  }

  // Hash password using SHA-256
  static String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  // Generate mock token
  static String _generateToken(String userId) {
    return 'mock_token_${userId}_${DateTime.now().millisecondsSinceEpoch}';
  }

  // Login
  Future<Map<String, dynamic>> login({
    required String username,
    required String password,
  }) async {
    await _delay();

    // Find user by username
    final user = _mockUsers.values.firstWhere(
      (u) => u['username'] == username,
      orElse: () => {},
    );

    if (user.isEmpty || user['password'] != _hashPassword(password)) {
      return {
        'success': false,
        'message': 'Invalid credentials',
      };
    }

    final userId = user['id'] as String;
    final token = _generateToken(userId);
    _mockTokens[token] = userId;

    // Token storage is handled by AuthService

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
      'token': token,
    };
  }

  // Sign Up
  Future<Map<String, dynamic>> signUp({
    required String username,
    required String email,
    required String password,
    required String country,
    required String phoneNumber,
  }) async {
    await _delay();

    // Check if user already exists
    final exists = _mockUsers.values.any(
      (u) => u['username'] == username || u['email'] == email,
    );

    if (exists) {
      return {
        'success': false,
        'message': 'User already exists',
      };
    }

    // Create new user
    final userId = 'user_${DateTime.now().millisecondsSinceEpoch}';
    final createdAt = DateTime.now().toIso8601String();

    _mockUsers[userId] = {
      'id': userId,
      'username': username,
      'email': email,
      'password': _hashPassword(password),
      'country': country,
      'phone_number': phoneNumber,
      'date_of_birth': null,
      'created_at': createdAt,
    };

    final token = _generateToken(userId);
    _mockTokens[token] = userId;

    // Token storage is handled by AuthService

    return {
      'success': true,
      'user': {
        'id': userId,
        'username': username,
        'email': email,
        'country': country,
        'phone_number': phoneNumber,
        'date_of_birth': null,
        'created_at': createdAt,
      },
      'token': token,
    };
  }

  // Forgot Password - Send Code
  Future<Map<String, dynamic>> sendResetCode(String email) async {
    await _delay();

    // Generate a 4-digit code
    final code = (1000 + (DateTime.now().millisecondsSinceEpoch % 9000)).toString();
    
    _resetCodes[email] = {
      'code': code,
      'expires_at': DateTime.now().add(const Duration(minutes: 10)).millisecondsSinceEpoch,
    };

    // In a real app, this would send an email
    // For testing, we'll just log it
    

    return {
      'success': true,
      'message': 'Code sent to email',
    };
  }

  // Verify Reset Code
  Future<Map<String, dynamic>> verifyResetCode({
    required String email,
    required String code,
  }) async {
    await _delay();

    final resetData = _resetCodes[email];
    if (resetData == null) {
      return {
        'success': false,
        'message': 'Invalid code',
      };
    }

    final expiresAt = resetData['expires_at'] as int;
    if (DateTime.now().millisecondsSinceEpoch > expiresAt) {
      _resetCodes.remove(email);
      return {
        'success': false,
        'message': 'Code expired',
      };
    }

    if (resetData['code'] != code) {
      return {
        'success': false,
        'message': 'Invalid code',
      };
    }

    return {
      'success': true,
      'message': 'Code verified',
    };
  }

  // Reset Password
  Future<Map<String, dynamic>> resetPassword({
    required String email,
    required String code,
    required String newPassword,
  }) async {
    await _delay();

    final resetData = _resetCodes[email];
    if (resetData == null) {
      return {
        'success': false,
        'message': 'Invalid code',
      };
    }

    final expiresAt = resetData['expires_at'] as int;
    if (DateTime.now().millisecondsSinceEpoch > expiresAt) {
      _resetCodes.remove(email);
      return {
        'success': false,
        'message': 'Code expired',
      };
    }

    if (resetData['code'] != code) {
      return {
        'success': false,
        'message': 'Invalid code',
      };
    }

    // Find user and update password
    final userEntry = _mockUsers.entries.firstWhere(
      (entry) => entry.value['email'] == email,
      orElse: () => const MapEntry('', {}),
    );

    if (userEntry.key.isEmpty) {
      return {
        'success': false,
        'message': 'User not found',
      };
    }

    _mockUsers[userEntry.key]!['password'] = newPassword;
    _resetCodes.remove(email);

    return {
      'success': true,
      'message': 'Password reset successful',
    };
  }

  // Change Password (Authenticated)
  Future<Map<String, dynamic>> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    await _delay();

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    if (token == null || !_mockTokens.containsKey(token)) {
      return {
        'success': false,
        'message': 'Not authenticated',
      };
    }

    final userId = _mockTokens[token];
    final user = _mockUsers[userId];
    if (user == null) {
      return {
        'success': false,
        'message': 'User not found',
      };
    }

    if (user['password'] != _hashPassword(oldPassword)) {
      return {
        'success': false,
        'message': 'Invalid current password',
      };
    }

    user['password'] = _hashPassword(newPassword);

    return {
      'success': true,
      'message': 'Password changed successfully',
    };
  }

  // Helper method to get current user from token
  static Map<String, dynamic>? getCurrentUser(String? token) {
    if (token == null || !_mockTokens.containsKey(token)) {
      return null;
    }
    final userId = _mockTokens[token];
    return _mockUsers[userId];
  }

  // Helper method to check if username is taken (excluding current user)
  static bool isUsernameTaken(String username, String? excludeUserId) {
    return _mockUsers.values.any(
      (u) => u['username'] == username && u['id'] != excludeUserId,
    );
  }

  // Helper method to get user by ID
  static Map<String, dynamic>? getUserById(String userId) {
    return _mockUsers[userId];
  }

  // Helper method to create a test user for easier testing
  static Future<void> createTestUser({
    String username = 'testuser',
    String email = 'test@example.com',
    String password = 'password123',
    String country = 'USA',
    String phoneNumber = '+1234567890',
  }) async {
    final userId = 'test_user_${DateTime.now().millisecondsSinceEpoch}';
    final createdAt = DateTime.now().toIso8601String();

    _mockUsers[userId] = {
      'id': userId,
      'username': username,
      'email': email,
      'password': _hashPassword(password),
      'country': country,
      'phone_number': phoneNumber,
      'date_of_birth': null,
      'created_at': createdAt,
    };
  }
}

