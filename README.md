# Bamboo Restaurant

Bamboo Restaurant is the mobile ordering app for Ho-Go Restaurant Bamboo in Ashgabat, Turkmenistan. It brings the restaurant's Asian and local dishes to your phone, so you can browse the menu and order without calling.

## What the app does

According to the [Google Play listing](https://play.google.com/store/apps/details?id=com.softpage.bamboo), customers can:

- Explore a photo menu with more than 23 categories, including grilled dishes, salads, drinks, children's meals, and healthier choices.
- Add dishes to a cart and place an order for delivery across Ashgabat or pickup. The listing also describes table reservations.
- Choose from the payment methods offered at checkout, including online payment, a bank card on delivery, or cash.
- Follow an order's status, receive notifications about offers, and send feedback from their profile.

The app also includes restaurant information, a map, and order history. Its interface supports Turkmen, Russian, and English. Menu items, availability, prices, and payment options come from the restaurant and may change.

## Download

- [Google Play: Bamboo Restaurant](https://play.google.com/store/apps/details?id=com.softpage.bamboo) (`com.softpage.bamboo`)
- An iOS store listing has not been verified for this repository.
- A direct APK download will be linked here after a signed release passes the checks in the [release guide](docs/RELEASE.md). This repository is currently private, so its GitHub Releases are accessible only to people with repository access.

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
