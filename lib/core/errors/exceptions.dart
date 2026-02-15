/// Custom exception classes for the 3ASH - Gym Trainer app
///
/// Provides type-safe exception handling with error codes and messages.
library;

/// Base exception class for all app-specific exceptions
abstract class AppException implements Exception {

  const AppException(this.message, [this.code]);
  /// Error message to display to the user
  final String message;

  /// Optional error code for debugging purposes
  final String? code;

  @override
  String toString() => code != null ? '$message (Code: $code)' : message;
}

/// Exception thrown when there's an authentication error
class AuthenticationException extends AppException {
  const AuthenticationException(super.message, [super.code]);
}

/// Exception thrown when there's an authorization error (e.g., token expired)
class AuthorizationException extends AppException {
  const AuthorizationException(super.message, [super.code = '401']);
}

/// Exception thrown when there's a network error
class NetworkException extends AppException {
  const NetworkException([super.message = 'Network connection error', super.code = 'NETWORK_ERROR']);
}

/// Exception thrown when request times out
class TimeoutException extends AppException {
  const TimeoutException([super.message = 'Request timed out', super.code = 'TIMEOUT']);
}

/// Exception thrown when there's an API error
class ApiException extends AppException {

  const ApiException(super.message, [this.statusCode, super.code]);
  /// HTTP status code
  final int? statusCode;
}

/// Exception thrown when data parsing fails
class ParseException extends AppException {
  const ParseException([super.message = 'Data parsing error', super.code = 'PARSE_ERROR']);
}

/// Exception thrown when there's a database error
class DatabaseException extends AppException {
  const DatabaseException(super.message, [super.code]);
}

/// Exception thrown when validation fails
class ValidationException extends AppException {

  const ValidationException(super.message, [this.fields, super.code = 'VALIDATION_ERROR']);
  /// Field names that failed validation
  final List<String>? fields;
}
