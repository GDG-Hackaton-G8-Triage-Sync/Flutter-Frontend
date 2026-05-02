import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_frontend/app.dart';
import 'package:flutter_frontend/core/services/cache_service.dart';

Future<void> mainCommon() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await CacheService.instance.init();
  // Catch all Flutter errors securely without triggering Web inspector bugs
  FlutterError.onError = (FlutterErrorDetails details) {
    debugPrint('FLUTTER_ERROR: ${details.exceptionAsString()}');
    if (details.stack != null) {
      debugPrint(details.stack.toString());
    }
  };

  runApp(const ProviderScope(child: TriageSyncApp()));
}
