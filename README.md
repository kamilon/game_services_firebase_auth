# 🎮 Game Services FirebaseAuth Plugin

A Flutter plugin that simplifies Firebase Authentication using GameCenter on iOS and Play Games on
Android.

## Features

- **Cross-Platform Game Services**: Supports Firebase Authentication with GameCenter on iOS and Play
  Games on Android.
- **Easy Integration**: Minimal code required to sign in, link accounts, and manage authentication
  with game services.

## Installation

To install the package, add the following to your `pubspec.yaml`:

```yaml
dependencies:
  
  your_package_name: ^latest_version
```

Then run:

```bash
flutter pub get
```

Please follow the instructions carefully to set up your project for iOS and Android, especially for
Android, which can be a bit tricky and may lead to ambiguous errors if not set up correctly.


### 🍏 iOS

1. Open your project in Xcode. In the Signing & Capabilities tab, add the ‘Game Center’ capability [(Doc here)](https://developer.apple.com/documentation/gamekit/enabling_and_configuring_game_center/)
2. Ensure to activate the Game Center Authentication method in the Firebase Console.
[Firebase Activate Game Center](./blob/firebase_activate_game_center.png)


## Usage

### Sign In with Game Services

```dart
await
FirebaseAuth.instance.signInWithGamesServices
();
```

### Check if Current User is Linked with Game Services

```dart
firebaseUser.isLinkedWithGamesServices
();
```

### Link Firebase User with Game Services

```dart
await
firebaseUser.linkWithGamesServices
();
```

### Force Sign In with Game Services if Account Already Linked

```dart
await
firebaseUser.linkWithGamesServices
(
forceSignInWithGameServiceIfCredentialAlreadyUsed
:
true
);
```

## Requirements

- **Firebase Core**
- **Firebase Auth**

## Contributing

Contributions are welcome! Please follow the [contribution guidelines](CONTRIBUTING.md) and basic
open-source practices.

## License

This project is licensed under the BSD-3-Clause License. See the [LICENSE](LICENSE) file for more
details.


