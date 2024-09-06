import 'package:firebase_auth/firebase_auth.dart';
import 'package:game_services_firebase_auth/game_services_firebase_auth.dart';
import 'package:game_services_firebase_auth/game_services_firebase_auth_exception.dart';

/// A utility class that provides methods for retrieving authentication credentials
/// for Play Games (Android) and Game Center (iOS).
///
/// This class interacts with the Game Services authentication system to fetch OAuth credentials
/// that can be used with Firebase Authentication.
class GameServicesCredentialsUtils {
  /// Retrieves an OAuthCredential for Play Games (Android).
  ///
  /// This method signs the user into Play Games and retrieves an authentication code,
  /// which is then used to create a Firebase OAuth credential.
  ///
  /// Throws a [GameServicesFirebaseAuthException] if the sign-in process fails, indicating
  /// that the user is not signed into Play Games.
  ///
  /// Returns an [OAuthCredential] that can be used with Firebase for authenticating the user.
  static Future<OAuthCredential> getPlayGamesCredential({String? playGamesClientId}) async {
    // Attempts to sign in with Play Games and retrieve an auth code.
    final String? authCode =
        await GameServicesFirebaseAuth().signInWithGameService(playGamesClientId: playGamesClientId);

    // If the auth code is null, throw an exception indicating the failure.
    if (authCode == null) {
      throw GameServicesFirebaseAuthException(
        code: GameServicesFirebaseExceptionCode.notSignedIntoGamesServices,
        message: 'Failed to sign into Play Games. Please check your Play Games settings and try again.',
      );
    }

    // Returns a Firebase OAuth credential using the retrieved serverAuthCode from Play Games.
    return PlayGamesAuthProvider.credential(serverAuthCode: authCode);
  }

  /// Retrieves an OAuthCredential for Game Center (iOS).
  ///
  /// This method first checks if the user is already signed into Game Center.
  /// If not, it attempts to sign in and retrieve an auth token.
  /// If the sign-in fails, an exception is thrown.
  ///
  /// Throws a [GameServicesFirebaseAuthException] if the sign-in process fails.
  ///
  /// Returns an [OAuthCredential] for Game Center, which can be used with Firebase.
  static Future<OAuthCredential> getGameCenterCredential() async {
    // Checks if the user is already signed into Game Center.
    if (await GameServicesFirebaseAuth().isAlreadySignInWithGameService()) {
      // If already signed in, return the Game Center credential.
      return GameCenterAuthProvider.credential();
    }

    // Attempts to sign in with Game Center and retrieve the auth token.
    if ((await GameServicesFirebaseAuth().signInWithGameService()) == null) {
      // If the auth token is null, throw an exception indicating the failure.
      throw GameServicesFirebaseAuthException(
        code: GameServicesFirebaseExceptionCode.notSignedIntoGamesServices,
        message: 'Failed to sign into Game Center. Please check your Game Center settings and try again.',
      );
    }

    // If successful, return the Game Center credential for Firebase.
    return GameCenterAuthProvider.credential();
  }
}
