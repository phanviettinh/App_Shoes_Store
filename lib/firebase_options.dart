// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
    apiKey: 'AIzaSyDG_wt4_TYkdtsaaMWVCnnOo9GufYNAxPc',
    appId: '1:257970270681:web:9fa047314086ffc88069c8',
    messagingSenderId: '257970270681',
    projectId: 'shopshoe-8ef20',
    authDomain: 'shopshoe-8ef20.firebaseapp.com',
    storageBucket: 'shopshoe-8ef20.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAnAa3Qu08byT43YwFLWKgfSykuPlhWi-U',
    appId: '1:257970270681:android:48e2acca52bdc2808069c8',
    messagingSenderId: '257970270681',
    projectId: 'shopshoe-8ef20',
    storageBucket: 'shopshoe-8ef20.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAs8-4A7F4lrsWcwuKFs3JV_fZj5Bs7bgs',
    appId: '1:257970270681:ios:6d4870f5ad89d1858069c8',
    messagingSenderId: '257970270681',
    projectId: 'shopshoe-8ef20',
    storageBucket: 'shopshoe-8ef20.appspot.com',
    androidClientId: '257970270681-2l8omo8olmkj4gkb027u8jarrb3mj393.apps.googleusercontent.com',
    iosClientId: '257970270681-qkk47egenqvmdur9e8s1uk4nalupt3pt.apps.googleusercontent.com',
    iosBundleId: 'com.example.sportsShoeStore',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAs8-4A7F4lrsWcwuKFs3JV_fZj5Bs7bgs',
    appId: '1:257970270681:ios:0a0bfed2499fdfee8069c8',
    messagingSenderId: '257970270681',
    projectId: 'shopshoe-8ef20',
    storageBucket: 'shopshoe-8ef20.appspot.com',
    androidClientId: '257970270681-2l8omo8olmkj4gkb027u8jarrb3mj393.apps.googleusercontent.com',
    iosClientId: '257970270681-5e3efkg7k710qjn66alk267kc8vv3agm.apps.googleusercontent.com',
    iosBundleId: 'com.example.sportsShoeStore.RunnerTests',
  );
}
