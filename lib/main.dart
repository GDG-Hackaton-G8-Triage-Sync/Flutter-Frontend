import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _loadEnvironment();

  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.dumpErrorToConsole(details);
    // TODO: Send errors to Crashlytics/Sentry in production.
  };

  runApp(const ProviderScope(child: TriageSyncApp()));
}

Future<void> _loadEnvironment() async {
  try {
    await dotenv.load(fileName: '.env');
  } catch (_) {
    // Fallback to --dart-define values when .env is unavailable.
  }
}
