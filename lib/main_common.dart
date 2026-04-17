import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app.dart';

Future<void> mainCommon() async {
  // Catch all Flutter errors
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.dumpErrorToConsole(details);
    // In production, send to Sentry or similar
  };

  runApp(const ProviderScope(child: TriageSyncApp()));
}
