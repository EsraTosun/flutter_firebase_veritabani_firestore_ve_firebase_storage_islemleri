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
    apiKey: 'AIzaSyDLKFFABg1y6QXdCuMw4_eaUqYgfFKVbXU',
    appId: '1:753407162182:web:cf85a1d98b98c80ee41747',
    messagingSenderId: '753407162182',
    projectId: 'flutter-firebase-dersler-51975',
    authDomain: 'flutter-firebase-dersler-51975.firebaseapp.com',
    storageBucket: 'flutter-firebase-dersler-51975.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA1Zl3rlXJqtfPspYdcqc6ICzBb3lGy-a8',
    appId: '1:753407162182:android:42b5cc4fbafc1117e41747',
    messagingSenderId: '753407162182',
    projectId: 'flutter-firebase-dersler-51975',
    storageBucket: 'flutter-firebase-dersler-51975.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyB8da_s6MBeBvL8wlYZjWpT_LkwRROmlY0',
    appId: '1:753407162182:ios:13e7dabb9b76ad0fe41747',
    messagingSenderId: '753407162182',
    projectId: 'flutter-firebase-dersler-51975',
    storageBucket: 'flutter-firebase-dersler-51975.appspot.com',
    androidClientId: '753407162182-4uh7rmlqne65l5c2ltrqnemvrdt30mun.apps.googleusercontent.com',
    iosClientId: '753407162182-f9pqeg7f6rjo9mv8q3096d14moosp24o.apps.googleusercontent.com',
    iosBundleId: 'com.example.firebaseVeritabaniFirestoreVeFirebaseStorageIslemleri',
  );
}
