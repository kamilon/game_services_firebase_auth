import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:game_services_firebase_auth/game_services_credentials_utils.dart';

// Extending the [User] class from Firebase to add functionality for linking and managing
// Play Games (Android) and Game Center (iOS) services.
extension FirebaseUserExtension on User {
  /// Links the currently signed-in Firebase user with Play Games on Android or
  /// Game Center on iOS.
  ///
  /// This method retrieves the appropriate credentials (either Play Games for Android
  /// or Game Center for iOS) and attempts to link them with the user's Firebase account.
  ///
  /// Throws [UnimplementedError] if this method is called on unsupported platforms (non-Android, non-iOS).
  /// Throws [FirebaseAuthGamesServicesException] if authentication with game services fails.
  /// Throws [FirebaseAuthException] if linking with Firebase fails (e.g., due to network issues or invalid credentials).
  Future<UserCredential> linkWithGamesServices({
    String? playGamesClientId,
    bool forceSignInIfCredentialAlreadyUsed = false,
  }) async {
    // For Android, retrieve Play Games credentials and link them to Firebase.
    if (Platform.isAndroid) {
      return linkWithCredential(
        await GameServicesCredentialsUtils.getPlayGamesCredential(playGamesClientId: playGamesClientId),
      );
    }
    // For iOS, retrieve Game Center credentials and link them to Firebase.
    if (Platform.isIOS) {
      return linkWithCredential(
        await GameServicesCredentialsUtils.getGameCenterCredential(),
      );
    }
    // If the platform is neither Android nor iOS, throw an error indicating unsupported platform.
    throw UnimplementedError('Platform not supported.');

    // TODO forceSignInIfCredentialAlreadyUsed
  }

  /// Checks if the currently signed-in Firebase user is linked with Play Games
  /// (Android) or Game Center (iOS).
  ///
  /// Returns `true` if the user's account is linked with either Play Games (on Android)
  /// or Game Center (on iOS), and `false` if not.
  bool isLinkedWithGamesServices() {
    // On Android, check if the user's account is linked with Play Games.
    if (Platform.isAndroid) {
      return providerData.any((UserInfo info) => info.providerId == PlayGamesAuthProvider.PROVIDER_ID);
    }
    // On iOS, check if the user's account is linked with Game Center.
    if (Platform.isIOS) {
      return providerData.any((UserInfo info) => info.providerId == GameCenterAuthProvider.PROVIDER_ID);
    }

    throw UnimplementedError('Platform not supported.');
  }

  /// Retrieves the user's Game Services ID (Play Games ID on Android or Game Center ID on iOS).
  ///
  /// This method searches the user's linked providers to find the one associated with
  /// Play Games (Android) or Game Center (iOS), and returns the corresponding `uid`.
  ///
  /// Returns the Game Services ID if available, or `null` if not found or on unsupported platforms.
  String? getGamesServicesId() {
    try {
      // On Android, return the user's Play Games ID.
      if (Platform.isAndroid) {
        return providerData.firstWhere((UserInfo info) => info.providerId == PlayGamesAuthProvider.PROVIDER_ID).uid;
      }
      // On iOS, return the user's Game Center ID.
      if (Platform.isIOS) {
        return providerData.firstWhere((UserInfo info) => info.providerId == GameCenterAuthProvider.PROVIDER_ID).uid;
      }

      throw UnimplementedError('Platform not supported.');
    } catch (_) {
      // If an exception occurs (e.g., no matching provider found), return null.
      return null;
    }
  }
}
