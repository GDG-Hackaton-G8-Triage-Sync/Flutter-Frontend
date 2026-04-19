import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_frontend/app.dart';

Future<void> mainCommon() async {
  // Catch all Flutter errors securely without triggering Web inspector bugs
  FlutterError.onError = (FlutterErrorDetails details) {
    debugPrint('FLUTTER_ERROR: ${details.exceptionAsString()}');
    if (details.stack != null) {
      debugPrint(details.stack.toString());
    }
  };

  runApp(const ProviderScope(child: TriageSyncApp()));
}
