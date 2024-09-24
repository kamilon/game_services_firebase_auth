/// Enum that defines different types of exception codes related to Game Services Firebase.
///
/// This can be expanded to include more error codes in the future as needed.
enum GameServicesFirebaseExceptionCode {
  /// Indicates that the user is not signed into Game Services.
  notSignedIntoGamesServices
}

/// A custom exception class for Game Services Firebase authentication errors.
///
/// This class provides a way to throw and catch exceptions that are specifically
/// related to Game Services Firebase authentication, along with detailed error
/// codes and messages to help with debugging.
class GameServicesFirebaseAuthException implements Exception {
  /// The error code associated with the exception.
  ///
  /// This uses the [GameServicesFirebaseExceptionCode] enum to categorize the error.
  final GameServicesFirebaseExceptionCode code;

  /// A human-readable error message explaining what went wrong.
  final String message;

  /// Additional details about the exception, if any.
  ///
  /// This can be used to include extra debugging information or the root cause
  /// of the exception (e.g., stack traces, raw error data).
  final Object? details;

  /// Creates a [GameServicesFirebaseAuthException] with the given [code], [message],
  /// and optional [details] about the exception.
  ///
  /// The [code] is required and should come from the [GameServicesFirebaseExceptionCode] enum.
  /// The [message] should provide a clear explanation of the error.
  GameServicesFirebaseAuthException(
      {required this.code, required this.message, this.details});

  /// Returns a string representation of the exception, which includes the error
  /// code, the message, and any additional details provided.
  ///
  /// This is useful for logging or debugging when the exception is caught.
  @override
  String toString() {
    return '[GameServiceFirebaseAuthException] $code, msg=$message, details=$details';
  }
}
