# Bamboo Restaurant

Bamboo Restaurant is a Flutter app for browsing the restaurant menu and placing delivery or pickup orders in Ashgabat. The app also includes order history, restaurant information, a map, and push notifications. Its interface supports Turkmen, Russian, and English.

## Download

- [Google Play: Bamboo Restaurant](https://play.google.com/store/apps/details?id=com.softpage.bamboo) (`com.softpage.bamboo`)
- An iOS store listing has not been verified for this repository.
- A direct APK download will be linked here only after a signed release passes the checks in [Release guide](docs/RELEASE.md).

## Development

Install Flutter 3.47.8 or a compatible stable release, Android SDK, and Xcode with CocoaPods for iOS. This project uses Dart 3 and includes a local copy of the Iconly font package under `packages/iconly` (see its license there).

```sh
flutter pub get
flutter run
```

The app calls the Bamboo API at `https://bambukresto.com.tm:4443` and uses Firebase for push notifications. Access to those services is required to exercise sign-in, menu, order, and notification flows. Never place signing passwords or service credentials in the repository.

## Checks and builds

```sh
dart format --output=none --set-exit-if-changed lib test
flutter analyze --no-pub --no-fatal-infos
flutter test --no-pub
flutter build apk --debug --no-pub
flutter build ios --simulator --no-pub # macOS with Xcode
```

The codebase still has legacy analyzer info messages. The analysis command above fails on errors and warnings while allowing those existing style notices.

For a signed Android release, create ignored `android/key.properties` with `storeFile`, `storePassword`, `keyAlias`, and `keyPassword` pointing to the project's release key outside Git, then run `flutter build apk --release`. A release build fails if signing is not configured. See [Release guide](docs/RELEASE.md) before publishing or installing it over the Play version.

## Known limits

- A passing build and unit tests do not verify backend availability, payment settlement, push delivery, or an upgrade from the Play build. These require real-device checks.
- iOS signing, TestFlight, and App Store availability have not been verified.
- Google Play privacy declarations must be checked against the app's current Firebase, location, and account behavior before a new store rollout.
- Current Flutter builds warn that the app and several plugins still use the Kotlin Gradle Plugin; iOS builds warn about Swift Package Manager support in two plugins. These migrations need separate plugin compatibility work before a future Flutter upgrade.
