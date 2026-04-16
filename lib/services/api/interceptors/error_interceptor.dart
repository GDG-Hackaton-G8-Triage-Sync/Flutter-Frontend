import 'package:dio/dio.dart';

class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final friendlyMessage = _mapErrorMessage(err);
    handler.next(err.copyWith(error: Exception(friendlyMessage)));
  }

  String _mapErrorMessage(DioException err) {
    if (err.type == DioExceptionType.connectionTimeout) {
      return 'Connection timeout. Check your internet.';
    }
    if (err.type == DioExceptionType.connectionError) {
      return 'Cannot connect to server. Is backend running?';
    }

    final statusCode = err.response?.statusCode;
    if (statusCode == 400) {
      final data = err.response?.data;
      if (data is Map<String, dynamic>) {
        final message = data['error'] ?? data['message'];
        if (message is String && message.isNotEmpty) {
          return message;
        }
      }
      return 'Invalid data.';
    }
    if (statusCode == 403) {
      return 'Permission denied. You cannot access this resource.';
    }
    if (statusCode == 500) {
      return 'Server error. Please try again later.';
    }

    return 'Unexpected network error occurred.';
  }
}
