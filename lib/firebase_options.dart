// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCxcJefVljPpa_ebT9PsGaFSzEheXqq6-4',
    appId: '1:590644022203:android:62e4d277b51e0c426d129e',
    messagingSenderId: '590644022203',
    projectId: 'admin-panel-e4013',
    databaseURL: 'https://admin-panel-e4013-default-rtdb.firebaseio.com',
    storageBucket: 'admin-panel-e4013.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAikr9tqnuWPoLSYRa6WGkfr7WN4SO8KKE',
    appId: '1:590644022203:ios:15e4d72fffab52516d129e',
    messagingSenderId: '590644022203',
    projectId: 'admin-panel-e4013',
    databaseURL: 'https://admin-panel-e4013-default-rtdb.firebaseio.com',
    storageBucket: 'admin-panel-e4013.appspot.com',
    androidClientId: '590644022203-90tp5kgguc4l7e5adav9cugrbn3l7dnh.apps.googleusercontent.com',
    iosBundleId: 'com.gurbanow.bamboo',
  );
}
