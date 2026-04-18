import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  static String get environment => dotenv.env['ENVIRONMENT'] ?? 'dev';
  static String get apiUrl => dotenv.env['API_URL'] ?? 'http://localhost:8000';

  static bool get isDev => environment == 'dev';
  static bool get isProd => environment == 'prod';
}
