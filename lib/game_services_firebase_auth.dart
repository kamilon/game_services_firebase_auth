import 'dart:async';

import 'game_services_firebase_auth_platform_interface.dart';
import 'logging.dart';

/// A singleton class that provides the primary interface for interacting with
/// Game Services authentication (Play Games on Android and GameCenter on iOS).
///
/// This class serves as the entry point for the authentication methods, allowing
/// developers to sign in with the native game services or check if the user is already signed in.
class GameServicesFirebaseAuth {
  // Singleton instance of GameServicesFirebaseAuth.
  static final GameServicesFirebaseAuth _instance = GameServicesFirebaseAuth._internal();

  // Private internal constructor to prevent external instantiation.
  GameServicesFirebaseAuth._internal();

  /// Factory constructor that returns the singleton instance of GameServicesFirebaseAuth.
  ///
  /// This ensures that there is only one instance of the class throughout the app.
  factory GameServicesFirebaseAuth() {
    return _instance;
  }

  /// Enables or disables debug logging for the Game Services authentication.
  ///
  /// If [enabled] is `true`, detailed logs will be printed to help with debugging.
  /// The logging functionality is controlled by the `setLogging` method.
  void enableDebugLogging(bool enabled) {
    setLogging(enabled: enabled);
  }

  /// Attempts to sign in with the native Game Service (Play Games for Android and GameCenter for iOS).
  ///
  /// Returns a [Future] that completes with the authentication token if the sign-in is successful.
  /// If the sign-in fails, the returned value will be `null`.
  ///
  /// This method utilizes the platform-specific implementation to handle sign-in.
  Future<String?> signInWithGameService({String? playGamesClientId}) {
    return GameServicesFirebaseAuthPlatform.instance.signInWithGameService(playGamesClientId: playGamesClientId);
  }

  /// Checks whether the user is already signed in with the native Game Service.
  ///
  /// Returns a [Future] that completes with `true` if the user is already signed in,
  /// or `false` if they are not.
  ///
  /// This is useful for determining if the sign-in process is necessary or if the user
  /// is already authenticated.
  Future<bool> isAlreadySignInWithGameService() {
    return GameServicesFirebaseAuthPlatform.instance.isAlreadySignInWithGameService();
  }
}
