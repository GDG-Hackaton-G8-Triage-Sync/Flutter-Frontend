import 'package:dio/dio.dart';
import 'package:flutter_frontend/core/config/api_config.dart';

class DioClient {
  static final Dio instance = Dio(
    BaseOptions(
      baseUrl: ApiConfig.baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: <String, String>{'Content-Type': 'application/json'},
    ),
  );
}
