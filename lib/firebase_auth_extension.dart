import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';

import 'game_services_credentials_utils.dart';

/// Extension on [FirebaseAuth] that provides a method for signing in with game services
/// (Play Games for Android and Game Center for iOS).
///
/// This extension adds a platform-specific sign-in mechanism that fetches credentials
/// from Play Games or Game Center and signs the user in with Firebase Authentication.
extension FirebaseAuthExtension on FirebaseAuth {
  /// Signs the user in with Play Games (Android) or Game Center (iOS) using Firebase Authentication.
  ///
  /// On Android, the method retrieves the Play Games credentials, optionally using the
  /// provided [playGamesClientId] if one is specified.
  ///
  /// On iOS, the method retrieves the Game Center credentials.
  ///
  /// Throws [UnimplementedError] if the method is called on platforms other than Android or iOS.
  ///
  /// Returns a [UserCredential] containing information about the authenticated user.
  Future<UserCredential> signInWithGamesServices({String? playGamesClientId}) async {
    // If the platform is Android, retrieve Play Games credentials and sign in with Firebase.
    if (Platform.isAndroid) {
      return signInWithCredential(
        await GameServicesCredentialsUtils.getPlayGamesCredential(playGamesClientId: playGamesClientId),
      );
    }
    // If the platform is iOS, retrieve Game Center credentials and sign in with Firebase.
    if (Platform.isIOS) {
      return signInWithCredential(
        await GameServicesCredentialsUtils.getGameCenterCredential(),
      );
    }
    // If the platform is neither Android nor iOS, throw an error indicating unsupported platform.
    throw UnimplementedError('Platform not supported.');
  }
}
