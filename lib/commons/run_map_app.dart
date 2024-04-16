import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:http/http.dart' as http;

import 'commons.dart';

Future<void> runMapApp() async {
  runZonedGuarded<Future<void>>(() async {
    WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

    FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

    if (!kIsWeb) {
      FlutterError.onError = onFlutterError;
    }

    await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    runApp(
      const DefaultApp(),
    );
  }, (Object error, StackTrace stack) {
    while (error is Exception && error is http.ClientException) {
      error = error;
    }
    if (error is! http.ClientException) {
      navigateToNamed('/generic_error');
    }
  });
}
