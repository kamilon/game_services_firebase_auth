import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'game_services_firebase_auth_method_channel.dart';

/// An abstract class that defines the platform interface for GameServicesFirebaseAuth.
/// This class ensures that platform-specific implementations (like iOS and Android)
/// can be swapped out using a method channel or other mechanisms.
abstract class GameServicesFirebaseAuthPlatform extends PlatformInterface {
  // Constructor that calls the super constructor with a platform-specific token.
  GameServicesFirebaseAuthPlatform() : super(token: _token);

  // A token to ensure that platform interfaces cannot be overridden without verification.
  static final Object _token = Object();

  // The default instance of the platform interface, which currently uses the
  // method channel implementation for communicating with the native side.
  static GameServicesFirebaseAuthPlatform _instance = GameServicesFirebaseAuthMethodChannel();

  /// A getter to access the current instance of the platform interface.
  /// This allows dynamic switching between different platform-specific implementations.
  static GameServicesFirebaseAuthPlatform get instance => _instance;

  /// A setter to change the platform interface instance.
  /// The instance can be swapped out but must pass the platform token verification check.
  static set instance(GameServicesFirebaseAuthPlatform instance) {
    // Ensures the new instance being set has the proper token for security.
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  /// Signs the user in with the game service.
  ///
  /// [playGamesClientId] is only required for Android platforms.
  /// It allows you to specify a different clientId if you want to provide a clientId
  /// other than the one defined in your `google-services.json` file.
  /// This parameter is ignored on non-Android platforms.
  ///
  /// Throws [UnimplementedError] if this method is not implemented by the platform-specific code.
  Future<String?> signInWithGameService({String? playGamesClientId}) {
    throw UnimplementedError('signInWithGameService has not been implemented.');
  }

  /// Checks if the user is already signed in with the game service.
  ///
  /// Returns a [bool] indicating whether the user is already signed in.
  /// Throws [UnimplementedError] if this method is not implemented by the platform-specific code.
  Future<bool> isAlreadySignInWithGameService() {
    throw UnimplementedError('isAlreadySignInWithGameService has not been implemented.');
  }
}
