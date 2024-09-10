import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:game_services_firebase_auth/firebase_auth_extension.dart';
import 'package:game_services_firebase_auth/game_services_credentials_utils.dart';

/// Extension on the [User] class from Firebase, adding functionality to link
/// and manage game services such as Play Games (Android) and Game Center (iOS).
extension FirebaseUserExtension on User {
  /// Links the current Firebase user with Play Games (Android) or Game Center (iOS).
  ///
  /// This method fetches the appropriate game service credentials (either Play Games on Android
  /// or Game Center on iOS) and attempts to link them with the current Firebase user account.
  ///
  /// [forceSignInWithGameServiceIfCredentialAlreadyUsed] indicates whether to force a sign-in
  /// with game services if the credentials are already linked with another account.
  /// If set to `true`, the user is signed out and signed in again using game services.
  ///
  /// Throws:
  /// - [UnimplementedError] for unsupported platforms (non-Android, non-iOS).
  /// - [FirebaseAuthGamesServicesException] if authentication with game services fails.
  /// - [FirebaseAuthException] if linking with Firebase fails (e.g., invalid credentials, network issues).
  Future<UserCredential> linkWithGamesServices({bool forceSignInWithGameServiceIfCredentialAlreadyUsed = false}) async {
    try {
      // Handle linking on Android (Play Games).
      if (Platform.isAndroid) {
        final playGamesCredential = await GameServicesCredentialsUtils.getPlayGamesCredential();
        return await linkWithCredential(playGamesCredential);
      }

      // Handle linking on iOS (Game Center).
      if (Platform.isIOS) {
        final gameCenterCredential = await GameServicesCredentialsUtils.getGameCenterCredential();
        return await linkWithCredential(gameCenterCredential);
      }

      // Unsupported platform error.
      throw UnimplementedError('This platform is not supported. Only Android and iOS are supported.');
    } on FirebaseAuthException catch (e) {
      // Handle the case where credentials are already linked with another account.
      if (forceSignInWithGameServiceIfCredentialAlreadyUsed && e.code == 'credential-already-in-use') {
        await FirebaseAuth.instance.signOut();
        return FirebaseAuth.instance.signInWithGamesServices();
      }
      rethrow; // Re-throw the exception if not handled.
    }
  }

  /// Checks if the current Firebase user is linked with Play Games (Android) or Game Center (iOS).
  ///
  /// Returns `true` if the user's account is linked with either Play Games (on Android)
  /// or Game Center (on iOS), and `false` otherwise.
  ///
  /// Throws [UnimplementedError] for unsupported platforms (non-Android, non-iOS).
  bool isLinkedWithGamesServices() {
    // Check if Play Games is linked on Android.
    if (Platform.isAndroid) {
      return providerData.any((UserInfo info) => info.providerId == PlayGamesAuthProvider.PROVIDER_ID);
    }

    // Check if Game Center is linked on iOS.
    if (Platform.isIOS) {
      return providerData.any((UserInfo info) => info.providerId == GameCenterAuthProvider.PROVIDER_ID);
    }

    throw UnimplementedError('This platform is not supported.');
  }

  /// Retrieves the Game Services ID for the current user (Play Games ID on Android or Game Center ID on iOS).
  ///
  /// This method searches the linked provider data for the Game Services provider (either Play Games or Game Center)
  /// and returns the corresponding user ID (`uid`).
  ///
  /// Returns the Game Services ID if found, or `null` if the user is not linked with either
  /// Play Games or Game Center.
  ///
  /// Throws [UnimplementedError] for unsupported platforms (non-Android, non-iOS).
  String? getGamesServicesId() {
    try {
      // Return Play Games ID on Android.
      if (Platform.isAndroid) {
        return providerData
            .firstWhere(
              (UserInfo info) => info.providerId == PlayGamesAuthProvider.PROVIDER_ID,
            )
            .uid;
      }

      // Return Game Center ID on iOS.
      if (Platform.isIOS) {
        return providerData
            .firstWhere(
              (UserInfo info) => info.providerId == GameCenterAuthProvider.PROVIDER_ID,
            )
            .uid;
      }

      throw UnimplementedError('This platform is not supported.');
    } catch (e) {
      // Return null if no provider is found or if an error occurs.
      return null;
    }
  }
}
