import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:logging/logging.dart';

import 'game_services_firebase_auth_platform_interface.dart';

/// A platform-specific implementation for GameServicesFirebaseAuth that communicates
/// with native code via method channels.
class GameServicesFirebaseAuthMethodChannel extends GameServicesFirebaseAuthPlatform {
  // Logger instance for logging important information, warnings, or errors.
  static final Logger _log = Logger('GameServiceFirebaseAuth');

  // Defines the method channel to communicate with the native platform (iOS/Android).
  // The channel name 'game_service_firebase_auth' must match with the native code.
  @visibleForTesting
  final methodChannel = const MethodChannel('game_services_firebase_auth');

  @override
  Future<String?> signInWithGameService({String? playGamesClientId}) async {
    final String? authCode;
    try {
      authCode = await methodChannel.invokeMethod<String>('signInWithGameService');
    } on PlatformException catch (e) {
      _log.severe('Failed to get Game Service auth code: ${e.message}');
      return null;
    }
    _log.fine('Game Service authCode is: $authCode');
    return authCode;
  }

  @override
  Future<bool> isAlreadySignInWithGameService() async {
    final bool result;
    try {
      result = await methodChannel.invokeMethod<bool>('isAlreadySignInWithGameService') ?? false;
    } on PlatformException catch (e) {
      _log.severe('Failed to check if user is already sign in with Game Service: ${e.message}');
      return false;
    }
    return result;
  }
}
