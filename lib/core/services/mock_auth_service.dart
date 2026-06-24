import 'dart:async';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Mock authentication service for testing without backend
/// Simulates all backend authentication endpoints
class MockAuthService {
  // In-memory storage for mock data
  static final Map<String, Map<String, dynamic>> _mockUsers = {
    'test_user_123456': {
      'id': 'test_user_123456',
      'username': 'testuser',
      'email': 'test@example.com',
      'password': _hashPassword('password123'),
      'country': 'USA',
      'phone_number': '+1234567890',
      'date_of_birth': '1990-01-01',
      'target_weight': 75.0,
      'created_at': DateTime(2024, 1, 1).toIso8601String(),
    },
  };
  static final Map<String, String> _mockTokens = {}; // token -> userId
  static final Map<String, Map<String, dynamic>> _resetCodes = {};
  static const _storage = FlutterSecureStorage();
  static const String _tokensKey = 'mock_tokens';

  // Load tokens from storage on first use
  static Future<void> loadTokens() async {
    if (_mockTokens.isEmpty) {
      final storedTokens = await _storage.read(key: _tokensKey);
      if (storedTokens != null) {
        final decoded = jsonDecode(storedTokens) as Map<String, dynamic>;
        decoded.forEach((key, value) {
          _mockTokens[key] = value as String;
        });
      }
    }
  }

  // Save tokens to storage
  static Future<void> saveTokens() async {
    await _storage.write(key: _tokensKey, value: jsonEncode(_mockTokens));
  }

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
    await loadTokens();
    await _delay();

    // Find user by username
    final user = _mockUsers.values.firstWhere(
      (u) => u['username'] == username,
      orElse: () => {},
    );

    if (user.isEmpty || user['password'] != _hashPassword(password)) {
      return {'success': false, 'message': 'Invalid credentials'};
    }

    final userId = user['id'] as String;
    final token = _generateToken(userId);
    _mockTokens[token] = userId;
    await saveTokens();

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
    await loadTokens();
    await _delay();

    // Check if user already exists
    final exists = _mockUsers.values.any(
      (u) => u['username'] == username || u['email'] == email,
    );

    if (exists) {
      return {'success': false, 'message': 'User already exists'};
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
    await saveTokens();

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

    // Generate a 4-digit code (fixed to 1234 for easy testing)
    final code = '1234';

    _resetCodes[email] = {
      'code': code,
      'expires_at': DateTime.now()
          .add(const Duration(minutes: 10))
          .millisecondsSinceEpoch,
    };

    // In a real app, this would send an email
    // For testing, we'll just log it

    return {'success': true, 'message': 'Code sent to email'};
  }

  // Verify Reset Code
  Future<Map<String, dynamic>> verifyResetCode({
    required String email,
    required String code,
  }) async {
    await _delay();

    final resetData = _resetCodes[email];
    if (resetData == null) {
      return {'success': false, 'message': 'Invalid code'};
    }

    final expiresAt = resetData['expires_at'] as int;
    if (DateTime.now().millisecondsSinceEpoch > expiresAt) {
      _resetCodes.remove(email);
      return {'success': false, 'message': 'Code expired'};
    }

    if (resetData['code'] != code) {
      return {'success': false, 'message': 'Invalid code'};
    }

    return {'success': true, 'message': 'Code verified'};
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
      return {'success': false, 'message': 'Invalid code'};
    }

    final expiresAt = resetData['expires_at'] as int;
    if (DateTime.now().millisecondsSinceEpoch > expiresAt) {
      _resetCodes.remove(email);
      return {'success': false, 'message': 'Code expired'};
    }

    if (resetData['code'] != code) {
      return {'success': false, 'message': 'Invalid code'};
    }

    // Find user and update password
    final userEntry = _mockUsers.entries.firstWhere(
      (entry) => entry.value['email'] == email,
      orElse: () => const MapEntry('', {}),
    );

    if (userEntry.key.isEmpty) {
      return {'success': false, 'message': 'User not found'};
    }

    _mockUsers[userEntry.key]!['password'] = _hashPassword(newPassword);
    _resetCodes.remove(email);

    return {'success': true, 'message': 'Password reset successful'};
  }

  // Change Password (Authenticated)
  Future<Map<String, dynamic>> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    await _delay();

    const storage = FlutterSecureStorage();
    final token = await storage.read(key: 'auth_token');
    if (token == null || !_mockTokens.containsKey(token)) {
      return {'success': false, 'message': 'Not authenticated'};
    }

    final userId = _mockTokens[token];
    final user = _mockUsers[userId];
    if (user == null) {
      return {'success': false, 'message': 'User not found'};
    }

    if (user['password'] != _hashPassword(oldPassword)) {
      return {'success': false, 'message': 'Invalid current password'};
    }

    user['password'] = _hashPassword(newPassword);

    return {'success': true, 'message': 'Password changed successfully'};
  }

  // Helper method to get current user from token
  static Map<String, dynamic>? getCurrentUser(String? token) {
    if (token == null || !_mockTokens.containsKey(token)) {
      return null;
    }
    final userId = _mockTokens[token];
    return _mockUsers[userId];
  }

  // Helper method to check if email is taken (for registration)
  static bool isEmailTaken(String email) {
    return _mockUsers.values.any((u) => u['email'] == email);
  }

  // Helper method to check if phone number is taken (for registration)
  static bool isPhoneNumberTaken(String phoneNumber) {
    return _mockUsers.values.any((u) => u['phone_number'] == phoneNumber);
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

  // Clear all tokens from storage and memory
  static Future<void> clearTokens() async {
    _mockTokens.clear();
    await _storage.delete(key: _tokensKey);
  }
}
