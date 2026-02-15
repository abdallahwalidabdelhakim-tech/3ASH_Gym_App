# 3ASH - Gym Trainer App Backend Presentation

## Overview

This presentation showcases the backend architecture of the 3ASH - Gym Trainer App, a comprehensive workout and progress tracking application built with Flutter. The backend system supports both real API integration and mock services for testing purposes.

---

## 1. Architecture Overview

### **Backend Architecture Diagram**

```
┌─────────────────────────────────────────────────────────────────┐
│                    3ASH - Gym Trainer App                       │
├─────────────────────────────────────────────────────────────────┤
│  Mobile Application Layer (Flutter)                              │
│  ├─────────────────────────────────────────────────────────────┤
│  │ Services Layer                                              │
│  │ ├─ AuthService              ──┬─ MockAuthService            │
│  │ ├─ UserService              ──┼─ MockUserService            │
│  │ ├─ ExerciseService           │  (In-Memory Storage)         │
│  │ ├─ WorkoutLogService         │                              │
│  │ ├─ BodyLogService            │                              │
│  │ ├─ NutritionService          │                              │
│  │ ├─ PlanService               │                              │
│  │ └─ AIService                 │                              │
│  ├─────────────────────────────────────────────────────────────┤
│  │ API Configuration Layer                                     │
│  │ ├─ AppConfig (Backend Switcher)                             │
│  │ ├─ Base URL Configuration (Platform-Specific)                │
│  │ └─ Environment Variables Support                            │
│  ├─────────────────────────────────────────────────────────────┤
│  │ Storage Layer                                               │
│  │ ├─ FlutterSecureStorage (Token Storage)                    │
│  │ └─ SharedPreferences (User Preferences)                     │
└─────────────────────────────────────────────────────────────────┘
```

---

## 2. Core Services Architecture

### **Service Design Pattern**

Each service follows a consistent architecture:

```dart
class AuthService {
  // Authentication operations
  Future<Map<String, dynamic>> login({
    required String username,
    required String password,
    bool rememberMe = false,
  })
  
  Future<Map<String, dynamic>> signUp({
    required String username,
    required String email,
    required String password,
    required String country,
    required String phoneNumber,
  })
  
  // Token management
  Future<void> saveToken(String token, {bool persist = true})
  Future<String?> getToken()
  Future<void> clearToken()
  Future<bool> isAuthenticated()
}
```

---

## 3. Authentication System

### **Auth Service Features**

| Feature | Description |
|---------|-------------|
| **Login** | Authenticates users with username/password |
| **Sign Up** | Creates new user accounts |
| **Password Recovery** | Send reset code to email, verify code, reset password |
| **Password Change** | Updates password for authenticated users |
| **Token Management** | Secure token storage with FlutterSecureStorage |
| **Session Management** | Handles persistent login with rememberMe functionality |

### **Authentication Flow**

```
User enters credentials
    ↓
AuthService determines backend type (real/mock)
    ↓
[Mock Backend] Verify against in-memory storage
[Real Backend] Send HTTP POST to /auth/login
    ↓
Return user data + JWT token
    ↓
Store token in FlutterSecureStorage
    ↓
Set authenticated state
```

---

## 4. User Profile Management

### **User Service Operations**

```dart
class UserService {
  // Profile management
  Future<Map<String, dynamic>> getCurrentUser()
  Future<Map<String, dynamic>> updateProfile({
    String? username,
    String? country,
    String? phoneNumber,
  })
  
  // Onboarding
  Future<Map<String, dynamic>> getOnboarding()
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
  })
}
```

### **Onboarding Data Structure**

```json
{
  "goal": "lose_weight",
  "activity_level": "moderate",
  "sex": "male",
  "date_of_birth": "1990-01-01",
  "age": 34,
  "height": 180.0,
  "weight": 80.0,
  "target_weight": 75.0,
  "objective": "lose_0.5kg_per_week",
  "target_calories": 2200
}
```

---

## 5. Configuration System

### **App Configuration**

```dart
class AppConfig {
  // Use mock backend by default (toggleable via environment variable)
  static const bool useMockBackend = bool.fromEnvironment(
    'USE_MOCK_BACKEND',
    defaultValue: true,
  );
  
  // Platform-specific base URL configuration
  static String get baseUrl {
    if (kIsWeb) return 'http://localhost:3000/api';
    if (Platform.isAndroid) return 'http://192.168.100.7:3000/api';
    return 'http://localhost:3001/api';
  }
}
```

### **Environment Variables**

```bash
# Run with real backend
flutter run --dart-define=USE_MOCK_BACKEND=false

# Run with custom API base URL
flutter run --dart-define=API_BASE_URL=http://your-api-domain.com/api
```

---

## 6. Mock Backend System

### **Mock Services Architecture**

```
MockAuthService
├─ login() - Accepts any credentials (creates user if needed)
├─ signUp() - Creates users in memory
├─ sendResetCode() - Generates 4-digit codes (console output)
├─ verifyResetCode() - Validates codes
├─ resetPassword() - Updates password
└─ changePassword() - Changes authenticated user's password

MockUserService
├─ getCurrentUser() - Returns user data from mock storage
├─ updateProfile() - Updates profile information
└─ updateOnboarding() - Stores onboarding data
```

### **Mock Data Storage**

```dart
class MockAuthService {
  static final Map<String, Map<String, dynamic>> _mockUsers = {};
  static final Map<String, String> _mockTokens = {};
  static final Map<String, Map<String, dynamic>> _resetCodes = {};
  
  static Future<void> _delay() async {
    await Future.delayed(const Duration(milliseconds: 500));
  }
}
```

---

## 7. API Communication

### **HTTP Request Helpers**

```dart
// Generic POST request (unauthenticated)
Future<Map<String, dynamic>> _postJson(
  String path,
  Map<String, dynamic> body, {
  Set<int> okStatusCodes = const {200},
})

// Generic POST request (authenticated)
Future<Map<String, dynamic>> _postJsonAuthed(
  String path,
  Map<String, dynamic> body, {
  Set<int> okStatusCodes = const {200},
})

// Generic GET request (authenticated)
Future<Map<String, dynamic>> _getJsonAuthed(String path)

// Generic PUT request (authenticated)
Future<Map<String, dynamic>> _putJsonAuthed(
  String path,
  Map<String, dynamic> body,
)
```

### **Error Handling**

```dart
// Custom exception classes
class ApiException implements Exception {
  final String message;
  final int? statusCode;
  ApiException(this.message, [this.statusCode]);
}

class ValidationException implements Exception {
  final String message;
  ValidationException(this.message);
}

class AuthorizationException implements Exception {
  final String message;
  const AuthorizationException([this.message = 'Unauthorized']);
}

class NetworkException implements Exception {
  const NetworkException();
}

class TimeoutException implements Exception {
  final String message;
  const TimeoutException([this.message = 'Request timed out']);
}
```

---

## 8. Data Models

### **User Model**

```dart
class UserModel {
  final String id;
  final String username;
  final String email;
  final String country;
  final String phoneNumber;
  final String? dateOfBirth;
  final String createdAt;
  
  UserModel({
    required this.id,
    required this.username,
    required this.email,
    required this.country,
    required this.phoneNumber,
    this.dateOfBirth,
    required this.createdAt,
  });
  
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      country: json['country'],
      phoneNumber: json['phone_number'],
      dateOfBirth: json['date_of_birth'],
      createdAt: json['created_at'],
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'country': country,
      'phone_number': phoneNumber,
      'date_of_birth': dateOfBirth,
      'created_at': createdAt,
    };
  }
}
```

### **Workout & Exercise Models**

```dart
class Exercise {
  final String id;
  final String name;
  final String imagePath;
  final String videoPath;
  final String type;
  final String bodyPart;
  final int sets;
  final int reps;
  
  Exercise({
    required this.id,
    required this.name,
    required this.imagePath,
    required this.videoPath,
    required this.type,
    required this.bodyPart,
    required this.sets,
    required this.reps,
  });
}

class WorkoutLog {
  final String id;
  final String userId;
  final String exerciseId;
  final String exerciseName;
  final String bodyPart;
  final int sets;
  final List<int> reps;
  final List<double?> weights;
  final String notes;
  final String date;
  
  WorkoutLog({
    required this.id,
    required this.userId,
    required this.exerciseId,
    required this.exerciseName,
    required this.bodyPart,
    required this.sets,
    required this.reps,
    required this.weights,
    required this.notes,
    required this.date,
  });
}
```

---

## 9. Performance & Security

### **Security Measures**

- **Token Storage**: FlutterSecureStorage (encrypted)
- **Password Hashing**: SHA-256 (mock service)
- **Token Management**: In-memory cache + secure storage
- **Session Handling**: Persistent login with token expiration check

### **Performance Optimizations**

- **API Timeouts**: 15-second timeout for all requests
- **Network Retries**: Automatic retry logic for failed requests
- **Error Recovery**: Comprehensive error handling with user-friendly messages
- **Data Caching**: In-memory caching for frequent API responses

---

## 10. Testing Capabilities

### **Mock Backend Benefits**

```
✅ No backend server required for development
✅ Realistic testing with simulated network delays (500ms)
✅ Test user creation via MockAuthService.createTestUser()
✅ Supports all authentication and profile management features
✅ Same API response format as real backend
```

### **Test Scenarios**

```dart
// Create test user programmatically
await MockAuthService.createTestUser(
  username: 'testuser',
  email: 'test@example.com',
  password: 'password123',
  country: 'USA',
  phoneNumber: '+1234567890',
);

// Login with test credentials
final result = await authService.login(
  username: 'testuser',
  password: 'password123',
);
```

---

## 11. API Endpoints

### **Authentication Endpoints**

| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/auth/login` | User login |
| POST | `/auth/signup` | User registration |
| POST | `/auth/send-reset-code` | Send password reset code |
| POST | `/auth/verify-reset-code` | Verify reset code |
| POST | `/auth/reset-password` | Reset password |
| POST | `/auth/change-password` | Change current password |

### **User Endpoints**

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/users/me` | Get current user profile |
| PUT | `/users/me` | Update user profile |
| POST | `/users/onboarding` | Save onboarding data |

---

## 12. Future Enhancements

### **Immediate Improvements**

1. **Real Backend Integration**: Complete real API implementation
2. **Database Integration**: Connect to real backend database
3. **JWT Token Refresh**: Implement token refresh mechanism
4. **Biometric Authentication**: Add fingerprint/face ID support

### **Advanced Features**

1. **Push Notifications**: Send workout reminders and updates
2. **Offline Support**: Local data persistence for offline usage
3. **Analytics**: Track user activity and engagement
4. **Social Features**: Friend connections and workout sharing

---

## Conclusion

The 3ASH backend architecture provides a robust foundation for a comprehensive gym and progress tracking application. With its dual backend support (mock and real API), the system enables efficient development and testing workflows while maintaining production readiness. The architecture emphasizes security, performance, and maintainability, making it suitable for scaling the application with additional features in the future.