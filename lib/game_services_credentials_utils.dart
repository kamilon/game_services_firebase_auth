import 'package:firebase_auth/firebase_auth.dart';
import 'package:game_services_firebase_auth/game_services_firebase_auth.dart';
import 'package:game_services_firebase_auth/game_services_firebase_auth_exception.dart';

/// A utility class to retrieve OAuth credentials for Play Games (Android) and Game Center (iOS),
/// which can be used to authenticate with Firebase.
class GameServicesCredentialsUtils {
  /// Retrieves an [OAuthCredential] for Play Games (Android).
  ///
  /// This method interacts with the Play Games services to sign in the user and retrieve an
  /// authentication code (`serverAuthCode`). If successful, it generates a Firebase OAuth
  /// credential from the auth code.
  ///
  /// Throws:
  /// - [GameServicesFirebaseAuthException] if the sign-in process fails or the user is not signed in.
  ///
  /// Returns an [OAuthCredential] that can be used with Firebase for user authentication.
  static Future<OAuthCredential> getPlayGamesCredential() async {
    // Attempt to sign in with Play Games.
    final bool success =
        await GameServicesFirebaseAuth().signInWithGameService();

    // If sign-in fails, throw an exception.
    if (!success) {
      throw GameServicesFirebaseAuthException(
        code: GameServicesFirebaseExceptionCode.notSignedIntoGamesServices,
        message:
            'Failed to sign into Play Games. Please check your Play Games settings and try again.',
      );
    }

    // Retrieve the authentication code from Play Games.
    final String? authCode =
        await GameServicesFirebaseAuth().getAndroidServerAuthCode();

    // If the auth code is null, throw an exception.
    if (authCode == null) {
      throw GameServicesFirebaseAuthException(
        code: GameServicesFirebaseExceptionCode.notSignedIntoGamesServices,
        message:
            'Failed to retrieve auth code from Play Games. Please check your Play Games settings and try again.',
      );
    }

    // Return a Firebase OAuth credential using the retrieved serverAuthCode.
    return PlayGamesAuthProvider.credential(serverAuthCode: authCode);
  }

  /// Retrieves an [OAuthCredential] for Game Center (iOS).
  ///
  /// This method checks if the user is already signed into Game Center. If the user is
  /// not signed in, it attempts to sign them in and generate an OAuth token.
  ///
  /// Throws:
  /// - [GameServicesFirebaseAuthException] if the sign-in process fails or the user is not signed in.
  ///
  /// Returns an [OAuthCredential] that can be used with Firebase to authenticate the user.
  static Future<OAuthCredential> getGameCenterCredential() async {
    // Check if the user is already signed into Game Center.
    final bool alreadySignedIn =
        await GameServicesFirebaseAuth().isAlreadySignInWithGameService();

    if (alreadySignedIn) {
      // Return the Game Center OAuth credential if already signed in.
      return GameCenterAuthProvider.credential();
    }

    // Attempt to sign in with Game Center.
    final bool signInSuccess =
        await GameServicesFirebaseAuth().signInWithGameService();

    // If sign-in fails, throw an exception.
    if (!signInSuccess) {
      throw GameServicesFirebaseAuthException(
        code: GameServicesFirebaseExceptionCode.notSignedIntoGamesServices,
        message:
            'Failed to sign into Game Center. Please check your Game Center settings and try again.',
      );
    }

    // Return the Game Center credential for Firebase after successful sign-in.
    return GameCenterAuthProvider.credential();
  }
}
