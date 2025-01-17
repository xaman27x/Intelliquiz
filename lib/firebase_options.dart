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
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
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

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyA_IWIfyIWizYhoSwmx3UGFaNM8NGXcLoI',
    appId: '1:889514701811:web:0a7a5a12bab8db26775886',
    messagingSenderId: '889514701811',
    projectId: 'intelliquiz1',
    authDomain: 'intelliquiz1.firebaseapp.com',
    storageBucket: 'intelliquiz1.appspot.com',
    measurementId: 'G-J6PRJ8NSJ0',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCkFLkheAVJ24IJLwqclYkEDFkWu0bd3VQ',
    appId: '1:889514701811:android:8dbd6211d9a0b9c7775886',
    messagingSenderId: '889514701811',
    projectId: 'intelliquiz1',
    storageBucket: 'intelliquiz1.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyA_3d3IMQGtcVKlOmn7an9qxKg7ZKhw4qY',
    appId: '1:889514701811:ios:de3a432f1a8c10f6775886',
    messagingSenderId: '889514701811',
    projectId: 'intelliquiz1',
    storageBucket: 'intelliquiz1.appspot.com',
    iosBundleId: 'com.example.intelliquiz',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyA_3d3IMQGtcVKlOmn7an9qxKg7ZKhw4qY',
    appId: '1:889514701811:ios:de3a432f1a8c10f6775886',
    messagingSenderId: '889514701811',
    projectId: 'intelliquiz1',
    storageBucket: 'intelliquiz1.appspot.com',
    iosBundleId: 'com.example.intelliquiz',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyA_IWIfyIWizYhoSwmx3UGFaNM8NGXcLoI',
    appId: '1:889514701811:web:2d232707f535e57f775886',
    messagingSenderId: '889514701811',
    projectId: 'intelliquiz1',
    authDomain: 'intelliquiz1.firebaseapp.com',
    storageBucket: 'intelliquiz1.appspot.com',
    measurementId: 'G-CMXYFHWS76',
  );
}
