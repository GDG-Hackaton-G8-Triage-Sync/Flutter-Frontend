import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter_frontend/core/network/interceptors/auth_interceptor.dart';
import 'package:flutter_frontend/core/network/interceptors/error_interceptor.dart';
import 'package:flutter_frontend/core/network/interceptors/logging_interceptor.dart';
import 'package:flutter_frontend/core/services/session_service.dart';

extension DioInterceptorSetup on Dio {
  void configureDioInterceptors({
    required SessionService sessionService,
    required Dio authDio,
    UnauthorizedHandler? onUnauthorized,
  }) {
    interceptors.removeWhere(
      (interceptor) =>
          interceptor is AuthInterceptor ||
          interceptor is ErrorInterceptor ||
          interceptor is LoggingInterceptor,
    );

    if (kDebugMode) {
      interceptors.add(LoggingInterceptor());
    }

    interceptors.add(
      AuthInterceptor(
        dio: this,
        authDio: authDio,
        sessionService: sessionService,
        onUnauthorized: onUnauthorized,
      ),
    );

    interceptors.add(ErrorInterceptor());
  }
}
