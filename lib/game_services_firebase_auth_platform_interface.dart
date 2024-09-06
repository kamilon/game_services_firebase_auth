import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'game_services_firebase_auth_method_channel.dart';

/// The platform interface for GameServicesFirebaseAuth.
///
/// This abstract class defines the platform-independent contract for interacting with
/// game services authentication (e.g., Play Games on Android, Game Center on iOS).
/// It allows platform-specific implementations to be swapped out dynamically using a
/// method channel or any other mechanism.
abstract class GameServicesFirebaseAuthPlatform extends PlatformInterface {
  // Constructor that calls the super constructor with a platform-specific token.
  GameServicesFirebaseAuthPlatform() : super(token: _token);

  // A security token to ensure that platform interfaces cannot be overridden
  // without proper verification.
  static final Object _token = Object();

  // The default instance of the platform interface, currently set to use the
  // method channel implementation to communicate with native code.
  static GameServicesFirebaseAuthPlatform _instance = GameServicesFirebaseAuthMethodChannel();

  /// Provides access to the current instance of the platform interface.
  ///
  /// This instance may be swapped with different platform-specific implementations.
  static GameServicesFirebaseAuthPlatform get instance => _instance;

  /// Allows setting a new platform interface instance.
  ///
  /// The new instance must pass a security check using the platform token.
  static set instance(GameServicesFirebaseAuthPlatform instance) {
    // Verifies that the instance being set has the proper token for security.
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  /// Signs the user in with the platform's native game service.
  ///
  /// - [playGamesClientId]: Optional parameter required for Android platforms, allowing
  ///   the developer to specify a different client ID other than the one defined in
  ///   `google-services.json`. This parameter is ignored on non-Android platforms.
  ///
  /// Throws:
  /// - [UnimplementedError] if this method is not implemented by the platform-specific code.
  ///
  /// Returns a [Future] that completes with a [bool] indicating success (`true`) or failure (`false`).
  Future<bool> signInWithGameService({String? playGamesClientId}) {
    throw UnimplementedError('signInWithGameService has not been implemented.');
  }

  /// Checks if the user is already signed in with the native game service.
  ///
  /// Throws:
  /// - [UnimplementedError] if this method is not implemented by the platform-specific code.
  ///
  /// Returns a [Future] that completes with a [bool] indicating whether the user is signed in (`true`) or not (`false`).
  Future<bool> isAlreadySignInWithGameService() {
    throw UnimplementedError('isAlreadySignInWithGameService has not been implemented.');
  }

  /// Retrieves the Android server authentication code (for Play Games).
  ///
  /// - [playGamesClientId]: Optional parameter to specify a different client ID
  ///   on Android. This parameter is ignored on non-Android platforms.
  ///
  /// Throws:
  /// - [UnimplementedError] if this method is not implemented by the platform-specific code.
  ///
  /// Returns a [Future] that completes with a [String?] representing the server authentication code,
  /// or `null` if the authentication code could not be retrieved.
  Future<String?> getAndroidServerAuthCode({String? playGamesClientId}) {
    throw UnimplementedError('getAndroidServerAuthCode has not been implemented.');
  }
}
