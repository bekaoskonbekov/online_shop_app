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
    apiKey: 'AIzaSyCXWmYAiT9LRIi2aBs-2iXnt5RcdYHwWzU',
    appId: '1:76119278853:web:2931b9c21a33820e66236c',
    messagingSenderId: '76119278853',
    projectId: 'nakta-a6efb',
    authDomain: 'nakta-a6efb.firebaseapp.com',
    storageBucket: 'nakta-a6efb.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyASQz3eRxmIWraJ9347hNPD8iEm3U8eKj8',
    appId: '1:76119278853:android:0362fb55e0abee7166236c',
    messagingSenderId: '76119278853',
    projectId: 'nakta-a6efb',
    storageBucket: 'nakta-a6efb.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBVxAAD6zDcJwdcBbt76H59H3rlkXmlAWs',
    appId: '1:76119278853:ios:95e97b67f6907a3266236c',
    messagingSenderId: '76119278853',
    projectId: 'nakta-a6efb',
    storageBucket: 'nakta-a6efb.appspot.com',
    iosBundleId: 'com.example.myExampleFile',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBVxAAD6zDcJwdcBbt76H59H3rlkXmlAWs',
    appId: '1:76119278853:ios:95e97b67f6907a3266236c',
    messagingSenderId: '76119278853',
    projectId: 'nakta-a6efb',
    storageBucket: 'nakta-a6efb.appspot.com',
    iosBundleId: 'com.example.myExampleFile',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCXWmYAiT9LRIi2aBs-2iXnt5RcdYHwWzU',
    appId: '1:76119278853:web:a5bd18241f8aba0666236c',
    messagingSenderId: '76119278853',
    projectId: 'nakta-a6efb',
    authDomain: 'nakta-a6efb.firebaseapp.com',
    storageBucket: 'nakta-a6efb.appspot.com',
  );
}
