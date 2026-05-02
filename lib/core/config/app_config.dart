import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  static String get environment => dotenv.env['ENVIRONMENT'] ?? 'dev';
  static String get apiUrl {
    final url = dotenv.env['API_URL'];
    if (url == null || url.isEmpty) {
      throw Exception('API_URL is not set in the environment configuration.');
    }
    return url;
  }

  static bool get isDev => environment == 'dev';
  static bool get isProd => environment == 'prod';
}
