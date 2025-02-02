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

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAU2VGl60K8RSE3x0zQFTY_WS60q1oA8Rg',
    appId: '1:563440823299:web:9394e8a41cf57b9f0f7236',
    messagingSenderId: '563440823299',
    projectId: 'nasajwebbphotos',
    authDomain: 'nasajwebbphotos.firebaseapp.com',
    storageBucket: 'nasajwebbphotos.firebasestorage.app',
    measurementId: 'G-0VCGHRFJX6',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAv9mePXPV0ti8kaqiZxYwENA5tqY2KWZQ',
    appId: '1:563440823299:android:b19cec8f6fd829fd0f7236',
    messagingSenderId: '563440823299',
    projectId: 'nasajwebbphotos',
    storageBucket: 'nasajwebbphotos.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyB1CRiBHWOMGYX3Ul5oQNo2x2PiT4YQbjs',
    appId: '1:563440823299:ios:041568b317d8c4a20f7236',
    messagingSenderId: '563440823299',
    projectId: 'nasajwebbphotos',
    storageBucket: 'nasajwebbphotos.firebasestorage.app',
    iosBundleId: 'com.example.nasajwebbphotos',
  );
}
