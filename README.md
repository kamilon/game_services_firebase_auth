
# 🎮 Game Services FirebaseAuth Plugin

A Flutter plugin that simplifies Firebase Authentication using GameCenter on iOS and Play Games on Android.

## Features

- **Cross-Platform Support**: Authenticate users via GameCenter (iOS) and Play Games (Android) using Firebase.
- **Simple Integration**: Minimal setup to sign in, link accounts, and manage authentication.

## Requirements

- **Firebase Auth**

## Installation

To install the plugin, add the following to your `pubspec.yaml`:

```yaml
dependencies:
  game_services_firebase_auth: ^latest_version
```

Then, run the following command to fetch the dependency:

```bash
flutter pub get
```

Carefully follow the setup instructions for both iOS and Android to avoid configuration errors.

### 🍏 iOS Setup

1. Ensure Firebase is properly configured for your iOS project. Follow the [Firebase setup guide](https://firebase.google.com/docs/flutter/setup?platform=ios).
2. Open your project in Xcode, navigate to the Signing & Capabilities tab, and add the **Game Center** capability. [Learn more](https://developer.apple.com/documentation/gamekit/enabling_and_configuring_game_center/).
3. Enable Game Center authentication in the Firebase Console.

![Firebase Activate Game Center](https://raw.githubusercontent.com/revoltgames/game_services_firebase_auth/refs/heads/main/blob/firebase_activate_game_center.png)

### 🤖 Android Setup

Refer to the [official documentation](https://developers.google.com/games/services/console/enabling) for enabling Play Games services.

1. Make sure Firebase is configured correctly for Android. [Setup instructions here](https://firebase.google.com/docs/flutter/setup?platform=android).
2. Retrieve your project’s SHA-1 keys using the command below:

```bash
./gradlew signingReport
```

3. Add the SHA-1 keys to your Firebase Console, including debug and production keys.

![Firebase Android SHA-1](https://raw.githubusercontent.com/revoltgames/game_services_firebase_auth/refs/heads/main/blob/firebase_android_sha1.png)

4. Create a Web OAuth client ID in the Google Cloud Console and save the credentials (ID & secret).
5. Enable Google Play Games as a sign-in provider in the Firebase Console. Use the OAuth credentials created in the previous step.

![Firebase Sign-In Method](https://raw.githubusercontent.com/revoltgames/game_services_firebase_auth/refs/heads/main/blob/firebase_android_sign_in_method.png)

6. For each SHA-1 key (e.g., one for debug and one for Play Console), create a corresponding OAuth Android client ID in Google Cloud Console.

![GCP OAuth Keys](https://raw.githubusercontent.com/revoltgames/game_services_firebase_auth/refs/heads/main/blob/gcp_oauth_keys.png)

7. Activate Play Games on your app in the Google Play Console and fill in the required fields.
8. Create Play Services credentials for each key (from step 6).

![Google Play Keys](https://raw.githubusercontent.com/revoltgames/game_services_firebase_auth/refs/heads/main/blob/google_play_keys.png)

9. Add the following metadata to your `AndroidManifest.xml`:

```xml
<meta-data
    android:name="com.google.android.gms.games.APP_ID"
    android:value="@string/game_services_project_id" />

<meta-data
    android:name="io.revoltgames.game_services_firebase_auth.OAUTH_2_WEB_CLIENT_ID"
    android:value="@string/game_services_oauth_2_web_client_id" />
```

10. In your `res/values/strings.xml`, add the following values (replace `XXXXXX` with your actual values):

```xml
<resources>
    <string name="game_services_project_id" translatable="false">XXXXXX</string>
    <string name="game_services_oauth_2_web_client_id" translatable="false">XXXXXX</string>
</resources>
```

11. Finally, run the Firebase configuration command to ensure everything is set up:

```bash
flutterfire configure
```

## Usage

### Sign In with Game Services

```dart
await FirebaseAuth.instance.signInWithGamesServices();
```

### Check if User is Linked with Game Services

```dart
bool isLinked = firebaseUser.isLinkedWithGamesServices();
```

### Link User with Game Services

```dart
await firebaseUser.linkWithGamesServices();
```

### Force Sign-In if Account Already Linked

```dart
await firebaseUser.linkWithGamesServices(forceSignInWithGameServiceIfCredentialAlreadyUsed: true);
```

## Troubleshooting

### iOS

#### Error: Lexical or Preprocessor Issue (Xcode): Include of non-modular header inside framework module 'firebase_auth.FLTIdTokenChannelStreamHandle'

To resolve this issue:

1. Open your project in Xcode.
2. Navigate to **Build Settings** under your target.
3. Set **Allow Non-modular Includes in Framework Modules** to **YES**.

## Contributing

Contributions are welcome! Please check out the [contributing guidelines](CONTRIBUTING.md) for more details.

## License

This project is licensed under the BSD-3-Clause License. See the [LICENSE](LICENSE) file for more information.
