import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../../core/utils/env_loader.dart';

class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (EnvLoader.isDev) {
      debugPrint('REQUEST[${options.method}] => PATH: ${options.path}');
    }
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (EnvLoader.isDev) {
      debugPrint(
        'RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}',
      );
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (EnvLoader.isDev) {
      debugPrint(
        'ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}',
      );
    }
    handler.next(err);
  }
}
