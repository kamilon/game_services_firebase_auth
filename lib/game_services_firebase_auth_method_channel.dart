import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:logging/logging.dart';

import 'game_services_firebase_auth_platform_interface.dart';

/// A platform-specific implementation of GameServicesFirebaseAuth that communicates
/// with native code (iOS/Android) via method channels.
///
/// This class provides the logic to interact with native game services, such as
/// Play Games on Android and Game Center on iOS, by invoking method channel calls.
class GameServicesFirebaseAuthMethodChannel extends GameServicesFirebaseAuthPlatform {
  // Logger instance for logging important information, warnings, or errors.
  static final Logger _log = Logger('GameServiceFirebaseAuth');

  // Defines the method channel to communicate with the native platform (iOS/Android).
  // The channel name 'game_services_firebase_auth' must match with the native code's channel.
  @visibleForTesting
  final methodChannel = const MethodChannel('game_services_firebase_auth');

  /// Signs the user in with the platform's native game service.
  ///
  /// - On Android, [playGamesClientId] can be used to specify a different client ID for Play Games.
  /// - On iOS, this parameter is ignored.
  ///
  /// Returns a [Future] that resolves with `true` if the sign-in is successful, or `false` otherwise.
  ///
  /// Logs any platform exceptions that occur during the sign-in process.
  @override
  Future<bool> signInWithGameService({String? playGamesClientId}) async {
    final bool? success;
    try {
      // Invoke the native method for signing in with the game service.
      success = await methodChannel.invokeMethod<bool>('signInWithGameService', {
            'playGamesClientId': playGamesClientId,
          }) ??
          false;
    } on PlatformException catch (e) {
      // Log the error if the platform throws an exception.
      _log.severe('Failed to sign in with Game Service: ${e.message}');
      return false;
    }
    _log.fine('Game Service sign in successful');
    return success;
  }

  /// Checks whether the user is already signed in with the platform's native game service.
  ///
  /// Returns a [Future] that resolves with `true` if the user is already signed in,
  /// or `false` if not.
  ///
  /// Logs any platform exceptions that occur during the check.
  @override
  Future<bool> isAlreadySignInWithGameService() async {
    final bool result;
    try {
      // Invoke the native method to check if the user is already signed in.
      result = await methodChannel.invokeMethod<bool>('isAlreadySignInWithGameService') ?? false;
    } on PlatformException catch (e) {
      // Log the error if the platform throws an exception.
      _log.severe('Failed to check if user is already signed in with Game Service: ${e.message}');
      return false;
    }
    _log.fine('Checked Game Service sign-in status successfully');
    return result;
  }

  /// Retrieves the Android server authentication code for Play Games.
  ///
  /// - [playGamesClientId] is an optional parameter to specify a different client ID on Android.
  /// - This parameter is ignored on non-Android platforms.
  ///
  /// Returns a [Future] that resolves with the server authentication code as a [String],
  /// or `null` if the process fails.
  ///
  /// Logs any platform exceptions that occur during the retrieval of the auth code.
  @override
  Future<String?> getAndroidServerAuthCode({String? playGamesClientId}) async {
    final String? authCode;
    try {
      // Invoke the native method to get the Android server auth code.
      authCode = await methodChannel.invokeMethod<String>('getAndroidServerAuthCode');
    } on PlatformException catch (e) {
      // Log the error if the platform throws an exception.
      _log.severe('Failed to get Android server auth code: ${e.message}');
      return null;
    }
    _log.fine('Successfully retrieved Android server auth code');
    return authCode;
  }
}
