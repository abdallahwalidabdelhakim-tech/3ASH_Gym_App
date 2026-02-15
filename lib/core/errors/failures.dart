/// Failure classes for the 3ASH - Gym Trainer app
///
/// Translate exceptions into user-friendly failure messages with recovery suggestions.
library;

import 'exceptions.dart';

/// Base failure class that represents an error that occurred in the application
abstract class Failure {

  const Failure(this.message, [this.suggestion]);
  /// User-friendly error message
  final String message;

  /// Optional recovery suggestion
  final String? suggestion;
}

/// Authentication failure
class AuthenticationFailure extends Failure {
  const AuthenticationFailure({
    required String message,
    String? suggestion = 'Please check your credentials and try again.',
  }) : super(message, suggestion);
}

/// Authorization failure
class AuthorizationFailure extends Failure {
  const AuthorizationFailure({
    String message = 'Your session has expired.',
    String? suggestion = 'Please log in again.',
  }) : super(message, suggestion);
}

/// Network failure
class NetworkFailure extends Failure {
  const NetworkFailure({
    String message = 'Network connection error',
    String? suggestion = 'Please check your internet connection and try again.',
  }) : super(message, suggestion);
}

/// API failure
class ApiFailure extends Failure {
  const ApiFailure({
    required String message,
    String? suggestion,
  }) : super(message, suggestion);
}

/// Database failure
class DatabaseFailure extends Failure {
  const DatabaseFailure({
    String message = 'Data storage error',
    String? suggestion = 'Please restart the app and try again.',
  }) : super(message, suggestion);
}

/// Validation failure
class ValidationFailure extends Failure {

  const ValidationFailure({
    required String message,
    this.invalidFields,
    String? suggestion,
  }) : super(message, suggestion);
  /// List of invalid fields
  final List<String>? invalidFields;
}

/// Helper extension to convert exceptions to failures
extension ExceptionToFailure on Exception {
  Failure toFailure() {
    if (this is AuthenticationException) {
      return AuthenticationFailure(message: (this as AuthenticationException).message);
    } else if (this is AuthorizationException) {
      return AuthorizationFailure(
        message: (this as AuthorizationException).message,
      );
    } else if (this is NetworkException) {
      return NetworkFailure(message: (this as NetworkException).message);
    } else if (this is ApiException) {
      final apiException = this as ApiException;
      return ApiFailure(
        message: apiException.message,
        suggestion: apiException.statusCode == 500 ? 'Please try again later' : null,
      );
    } else if (this is DatabaseException) {
      return DatabaseFailure(message: (this as DatabaseException).message);
    } else if (this is ValidationException) {
      final validationException = this as ValidationException;
      return ValidationFailure(
        message: validationException.message,
        invalidFields: validationException.fields,
      );
    } else {
      return const ApiFailure(
        message: 'An unexpected error occurred',
        suggestion: 'Please try again later',
      );
    }
  }
}
