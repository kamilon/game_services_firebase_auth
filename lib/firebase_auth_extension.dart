import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';

import 'game_services_credentials_utils.dart';

/// This extension on [FirebaseAuth] adds support for signing in with platform-specific
/// game services like Google Play Games (Android) and Game Center (iOS).
///
/// It provides a platform-aware method [signInWithGamesServices] that retrieves game
/// services credentials and authenticates users via Firebase.
extension FirebaseAuthExtension on FirebaseAuth {
  /// Signs the user in with Google Play Games (Android) or Game Center (iOS) via Firebase Authentication.
  ///
  /// On Android, it fetches the Play Games credentials
  ///
  /// On iOS, it retrieves Game Center credentials to authenticate the user.
  ///
  /// Throws:
  /// - [UnimplementedError] for unsupported platforms (non-Android or non-iOS).
  /// - [FirebaseAuthException] if Firebase authentication fails (e.g., invalid credentials, network issues).
  ///
  /// Returns a [UserCredential] containing information about the authenticated user.
  ///
  /// Example usage:
  /// ```dart
  /// final userCredential = await FirebaseAuth.instance.signInWithGamesServices();
  /// ```
  Future<UserCredential> signInWithGamesServices() async {
    // Handle Android platform: Fetch Play Games credentials and sign in with Firebase.
    if (Platform.isAndroid) {
      final playGamesCredential =
          await GameServicesCredentialsUtils.getPlayGamesCredential();
      return signInWithCredential(playGamesCredential);
    }

    // Handle iOS platform: Fetch Game Center credentials and sign in with Firebase.
    if (Platform.isIOS) {
      final gameCenterCredential =
          await GameServicesCredentialsUtils.getGameCenterCredential();
      return signInWithCredential(gameCenterCredential);
    }

    // For unsupported platforms, throw an error.
    throw UnimplementedError(
        'This platform is not supported. Only Android and iOS are supported.');
  }
}
