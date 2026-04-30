import 'package:flutter/foundation.dart';
import 'package:flutter_frontend/core/config/app_config.dart';

class ApiConfig {
  ApiConfig._();

  static const String apiPrefix = '/api/v1';

  static String get baseUrl {
    const envUrl = String.fromEnvironment('API_URL', defaultValue: '');
    if (envUrl.trim().isNotEmpty) {
      return _normalizeHttpBase(envUrl);
    }
    
    final appConfigUrl = AppConfig.apiUrl;
    if (appConfigUrl.trim().isNotEmpty) {
      return _normalizeHttpBase(appConfigUrl);
    }

    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      return 'http://10.0.2.2:9000';
    }

    return 'http://127.0.0.1:9000';
  }

  static String get websocketUrl {
    const envUrl = String.fromEnvironment('WS_URL', defaultValue: '');
    if (envUrl.trim().isNotEmpty) {
      return _normalizeWebSocketBase(envUrl);
    }

    final uri = Uri.parse(baseUrl);
    final scheme = uri.scheme == 'https' ? 'wss' : 'ws';
    return uri.replace(scheme: scheme, path: '/ws/triage/events/').toString();
  }

  static Uri websocketUri({required String token}) {
    final uri = Uri.parse(websocketUrl);
    return uri.replace(
      queryParameters: <String, String>{
        ...uri.queryParameters,
        'token': token,
      },
    );
  }

  static String _normalizeHttpBase(String raw) {
    var value = raw.trim();
    while (value.endsWith('/')) {
      value = value.substring(0, value.length - 1);
    }

    if (value.endsWith(apiPrefix)) {
      value = value.substring(0, value.length - apiPrefix.length);
    }

    return value;
  }

  static String _normalizeWebSocketBase(String raw) {
    var value = raw.trim();
    if (value.startsWith('http://')) {
      value = value.replaceFirst('http://', 'ws://');
    } else if (value.startsWith('https://')) {
      value = value.replaceFirst('https://', 'wss://');
    }

    if (!value.contains('/ws/triage/events')) {
      while (value.endsWith('/')) {
        value = value.substring(0, value.length - 1);
      }
      value = '$value/ws/triage/events/';
    }

    return value;
  }
}
