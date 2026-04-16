import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvLoader {
  static String get environment {
    final value = _readFromDotEnv('ENVIRONMENT');
    if (value != null && value.isNotEmpty) {
      return value;
    }
    return const String.fromEnvironment('ENVIRONMENT', defaultValue: 'dev');
  }

  static String get apiUrl {
    final value = _readFromDotEnv('API_URL');
    if (value != null && value.isNotEmpty) {
      return value;
    }
    return const String.fromEnvironment(
      'API_URL',
      defaultValue: 'http://localhost:8000',
    );
  }

  static bool get isDev => environment == 'dev';
  static bool get isProd => environment == 'prod';
  static bool get isStaging => environment == 'staging';

  static String? _readFromDotEnv(String key) {
    try {
      return dotenv.env[key];
    } catch (_) {
      return null;
    }
  }
}
