/// User data model
///
/// Represents the core user information stored in the application.
/// This includes authentication data, personal details, and preferences.
class UserModel {

  /// Creates a UserModel instance
  UserModel({
    required this.id,
    required this.username,
    required this.email,
    this.country,
    this.phoneNumber,
    this.dateOfBirth,
    this.targetWeight,
    this.createdAt,
  });

  /// Creates a UserModel instance from JSON map
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      country: json['country'],
      phoneNumber: json['phone_number'],
      dateOfBirth: json['date_of_birth'],
      targetWeight: json['target_weight']?.toDouble(),
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
    );
  }
  /// Unique user identifier
  final String id;
  
  /// User's chosen username
  final String username;
  
  /// User's email address (used for login)
  final String email;
  
  /// User's country of residence
  final String? country;
  
  /// User's phone number
  final String? phoneNumber;
  
  /// User's date of birth (string format)
  final String? dateOfBirth;
  
  /// User's target weight in kilograms
  final double? targetWeight;
  
  /// Account creation timestamp
  final DateTime? createdAt;

  /// Converts the model to JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'country': country,
      'phone_number': phoneNumber,
      'date_of_birth': dateOfBirth,
      'target_weight': targetWeight,
      'created_at': createdAt?.toIso8601String(),
    };
  }
}

