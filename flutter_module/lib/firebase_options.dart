
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;


class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for iOS - '
              'Not supported for ios',
        );
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
              'Not supported for for macos',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
              'Not supported for windows',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
              'Not supported for linux',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
      apiKey: '{YOUR API KEY HERE}',
      authDomain: '{YOUR AUTH DOMAIN HERE}',
      projectId: '{YOUR PROJECT ID HERE}',
      storageBucket: '{YOUR STORAGE BUCKET HERE}',
      messagingSenderId: '{YOUR MESSAGING SENDER ID HERE}',
      appId: '{YOUR APP ID HERE}'
  );

  static const FirebaseOptions android = FirebaseOptions(
      apiKey: '{YOUR API KEY HERE}',
      appId: '{YOUR APP ID HERE}',
      messagingSenderId: '{YOUR MESSAGING SENDER ID HERE}',
      projectId: '{YOUR PROJECT ID HERE}',
      storageBucket: '{YOUR STORAGE BUCKET HERE}'
  );
}
