import '../config/app_config.dart';

class EnvLoader {
  static String get environment => AppConfig.environment;
  static String get apiUrl => AppConfig.apiUrl;

  static bool get isDev => AppConfig.isDev;
  static bool get isProd => AppConfig.isProd;
  static bool get isStaging => environment == 'staging';
}
