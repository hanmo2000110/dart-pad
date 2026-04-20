// Copyright (c) 2019, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// Runtime configuration for the Microlearnable-hosted DartPad embed.
///
/// Values are provided at build time with `--dart-define` so deployment
/// configuration does not live directly in source code.
class MicrolearnableConfig {
  static const firebaseApiKey =
      String.fromEnvironment('MICROLEARNABLE_FIREBASE_API_KEY');
  static const firebaseAuthDomain =
      String.fromEnvironment('MICROLEARNABLE_FIREBASE_AUTH_DOMAIN');
  static const firebaseDatabaseUrl =
      String.fromEnvironment('MICROLEARNABLE_FIREBASE_DATABASE_URL');
  static const firebaseProjectId =
      String.fromEnvironment('MICROLEARNABLE_FIREBASE_PROJECT_ID');
  static const firebaseAppId =
      String.fromEnvironment('MICROLEARNABLE_FIREBASE_APP_ID');
  static const firebaseStorageBucket =
      String.fromEnvironment('MICROLEARNABLE_FIREBASE_STORAGE_BUCKET');

  static const firebaseAuthEmail =
      String.fromEnvironment('MICROLEARNABLE_FIREBASE_AUTH_EMAIL');
  static const firebaseAuthPassword =
      String.fromEnvironment('MICROLEARNABLE_FIREBASE_AUTH_PASSWORD');

  static const storageCorsProxy = String.fromEnvironment(
    'MICROLEARNABLE_STORAGE_CORS_PROXY',
    defaultValue: 'https://cors-anywhere-my.onrender.com/',
  );

  static bool get hasFirebaseConfig => missingFirebaseConfigKeys.isEmpty;

  static bool get hasEmailPasswordAuth =>
      firebaseAuthEmail.isNotEmpty && firebaseAuthPassword.isNotEmpty;

  static List<String> get missingFirebaseConfigKeys {
    final missingKeys = <String>[];
    if (firebaseApiKey.isEmpty) {
      missingKeys.add('MICROLEARNABLE_FIREBASE_API_KEY');
    }
    if (firebaseAuthDomain.isEmpty) {
      missingKeys.add('MICROLEARNABLE_FIREBASE_AUTH_DOMAIN');
    }
    if (firebaseDatabaseUrl.isEmpty) {
      missingKeys.add('MICROLEARNABLE_FIREBASE_DATABASE_URL');
    }
    if (firebaseProjectId.isEmpty) {
      missingKeys.add('MICROLEARNABLE_FIREBASE_PROJECT_ID');
    }
    if (firebaseAppId.isEmpty) {
      missingKeys.add('MICROLEARNABLE_FIREBASE_APP_ID');
    }
    if (firebaseStorageBucket.isEmpty) {
      missingKeys.add('MICROLEARNABLE_FIREBASE_STORAGE_BUCKET');
    }
    return missingKeys;
  }

  static String proxyFirebaseStorageUrls(String source) {
    const storageHost = 'https://firebasestorage.';
    if (storageCorsProxy.isEmpty || !source.contains(storageHost)) {
      return source;
    }

    return source.replaceAll(storageHost, '$storageCorsProxy$storageHost');
  }
}
