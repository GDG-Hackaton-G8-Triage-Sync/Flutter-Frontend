import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final mappedMessage = _toReadableMessage(err);

    if (kDebugMode) {
      final code = err.response?.statusCode;
      debugPrint('HTTP_ERROR [$code] ${err.requestOptions.method} ${err.requestOptions.uri} -> $mappedMessage');
    }

    try {
      handler.next(err);
    } catch (_) {
      // If the interceptor pipeline is already in an error state, never throw again.
    }
  }

  String _toReadableMessage(DioException err) {
    final statusCode = err.response?.statusCode;

    if (statusCode == 401) {
      return 'Your session has expired. Please sign in again.';
    }

    if (statusCode == 403) {
      return 'You do not have permission to perform this action.';
    }

    if (statusCode == 404) {
      return 'The requested resource was not found.';
    }

    if (statusCode != null && statusCode >= 500) {
      return 'Server error. Please try again shortly.';
    }

    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Connection timed out. Please check your internet and retry.';
      case DioExceptionType.connectionError:
        return 'Unable to connect to server. Check your network connection.';
      case DioExceptionType.cancel:
        return 'Request was cancelled.';
      case DioExceptionType.badCertificate:
        return 'Secure connection failed due to an invalid certificate.';
      case DioExceptionType.badResponse:
      case DioExceptionType.unknown:
        return 'Unexpected network error. Please try again.';
    }
  }
}
