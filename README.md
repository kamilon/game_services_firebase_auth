# 🎮Game Services FirebaseAuth Plugin

A Flutter plugin that simplifies Firebase Authentication using GameCenter on iOS and Play Games on Android.

## Features

- **Cross-Platform Game Services**: Supports Firebase Authentication with GameCenter on iOS and Play Games on Android.
- **Easy Integration**: Minimal code required to sign in, link accounts, and manage authentication with game services.

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

## Usage

### Sign In with Game Services

```dart
await FirebaseAuth.instance.signInWithGamesServices();
```

### Check if Current User is Linked with Game Services

```dart
firebaseUser.isLinkedWithGamesServices();
```

### Link Firebase User with Game Services

```dart
firebaseUser.linkWithGamesServices();
```

### Force Sign In with Game Services if Account Already Linked

```dart
_user.linkWithGamesServices(forceSignInWithGameServiceIfCredentialAlreadyUsed: true);
```

## Requirements

- **Firebase Core**
- **Firebase Auth**

## Contributing

Contributions are welcome! Please follow the [contribution guidelines](CONTRIBUTING.md) and basic open-source practices.

## License

This project is licensed under the BSD-3-Clause License. See the [LICENSE](LICENSE) file for more details.


