import 'package:dio/dio.dart';

class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.type == DioExceptionType.connectionTimeout) {
      throw Exception('Connection timeout. Check your internet.');
    } else if (err.type == DioExceptionType.connectionError) {
      throw Exception('Cannot connect to server. Is backend running?');
    } else if (err.response?.statusCode == 400) {
      final message = err.response?.data['error'] ?? 'Invalid data';
      throw Exception(message);
    } else if (err.response?.statusCode == 403) {
      throw Exception('Permission denied. You cannot access this resource.');
    } else if (err.response?.statusCode == 500) {
      throw Exception('Server error. Please try again later.');
    }
    handler.next(err);
  }
}
