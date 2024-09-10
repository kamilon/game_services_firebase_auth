import 'dart:async';

import 'game_services_firebase_auth_platform_interface.dart';
import 'logging.dart';

/// A singleton class that provides an interface for interacting with Game Services
/// authentication (Play Games on Android and Game Center on iOS).
///
/// This class serves as the entry point for signing in with native game services
/// and checking if the user is already authenticated via those services.
class GameServicesFirebaseAuth {
  // Singleton instance of GameServicesFirebaseAuth.
  static final GameServicesFirebaseAuth _instance = GameServicesFirebaseAuth._internal();

  // Private internal constructor to prevent external instantiation.
  GameServicesFirebaseAuth._internal();

  /// Factory constructor that returns the singleton instance of GameServicesFirebaseAuth.
  ///
  /// This ensures only one instance of the class exists throughout the app,
  /// adhering to the Singleton pattern.
  factory GameServicesFirebaseAuth() {
    return _instance;
  }

  /// Enables or disables debug logging for Game Services authentication.
  ///
  /// If [enabled] is `true`, detailed debug logs will be printed for diagnostic purposes.
  /// This can be helpful during development to trace issues in authentication processes.
  ///
  /// Example usage:
  /// ```dart
  /// GameServicesFirebaseAuth().enableDebugLogging(true);
  /// ```
  void enableDebugLogging(bool enabled) {
    setLogging(enabled: enabled);
  }

  /// Signs the user in with the native Game Service (Play Games for Android or Game Center for iOS).
  ///
  /// This method uses platform-specific implementations to authenticate the user and return
  /// an authentication token if the sign-in is successful.
  ///
  /// If sign-in fails, the method returns `false`.
  ///
  /// Returns a [Future] that resolves with a `bool` indicating whether the sign-in was successful (`true`) or not (`false`).
  ///
  /// Example usage:
  /// ```dart
  /// final success = await GameServicesFirebaseAuth().signInWithGameService();
  /// ```
  Future<bool> signInWithGameService() {
    return GameServicesFirebaseAuthPlatform.instance.signInWithGameService();
  }

  /// Checks whether the user is already signed in with the native Game Service (Play Games on Android or Game Center on iOS).
  ///
  /// This method can be used to determine whether the user needs to go through the sign-in process
  /// or if they are already authenticated with the game services.
  ///
  /// Returns a [Future] that resolves to `true` if the user is already signed in,
  /// and `false` if they are not.
  ///
  /// Example usage:
  /// ```dart
  /// bool isSignedIn = await GameServicesFirebaseAuth().isAlreadySignInWithGameService();
  /// ```
  Future<bool> isAlreadySignInWithGameService() {
    return GameServicesFirebaseAuthPlatform.instance.isAlreadySignInWithGameService();
  }

  /// Retrieves the Android server authentication code for Play Games.
  ///
  /// This method is only relevant on Android. It retrieves the server authentication code,
  /// which can be used for further authentication with Firebase or other services.
  ///
  /// Returns a [Future] that resolves with the server authentication code as a [String],
  /// or `null` if the process fails.
  ///
  /// Example usage:
  /// ```dart
  /// final authCode = await GameServicesFirebaseAuth().getAndroidServerAuthCode();
  /// ```
  Future<String?> getAndroidServerAuthCode() {
    return GameServicesFirebaseAuthPlatform.instance.getAndroidServerAuthCode();
  }
}
