import 'package:dio/dio.dart';

class ApiErrorMapper {
  static String toUserMessage(Object error, {required String fallbackMessage}) {
    if (error is! DioException) {
      return fallbackMessage;
    }

    switch (error.type) {
      case DioExceptionType.connectionError:
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Cannot reach the server right now. Check your connection and try again.';
      case DioExceptionType.badCertificate:
        return 'Secure connection failed. Please try again later.';
      case DioExceptionType.cancel:
        return 'Request was cancelled. Please try again.';
      case DioExceptionType.badResponse:
        return _handleBadResponse(error.response, fallbackMessage);
      case DioExceptionType.unknown:
        return 'Something went wrong while contacting the server. Please try again.';
    }
  }

  static String _handleBadResponse(
    Response<dynamic>? response,
    String fallbackMessage,
  ) {
    final payloadMessage = _extractMessage(response?.data);
    if (payloadMessage != null && payloadMessage.isNotEmpty) {
      return payloadMessage;
    }

    final statusCode = response?.statusCode ?? 0;

    if (statusCode == 400) {
      return 'Some fields are invalid. Please review your details and try again.';
    }
    if (statusCode == 401) {
      return 'Username or password is incorrect.';
    }
    if (statusCode == 403) {
      return 'You do not have permission to perform this action.';
    }
    if (statusCode == 404) {
      return 'Service endpoint was not found. Please try again later.';
    }
    if (statusCode == 409) {
      return 'An account with this email already exists.';
    }
    if (statusCode == 422) {
      return 'Submitted data failed validation. Please correct the fields and try again.';
    }
    if (statusCode == 429) {
      return 'Too many requests. Please wait a moment and try again.';
    }
    if (statusCode >= 500) {
      return 'The server is temporarily unavailable. Please try again shortly.';
    }

    return fallbackMessage;
  }

  static String? _extractMessage(dynamic data) {
    if (data is Map<String, dynamic>) {
      for (final key in <String>[
        'message',
        'error',
        'detail',
        'non_field_errors',
      ]) {
        final value = data[key];
        if (value is String && value.trim().isNotEmpty) {
          return value.trim();
        }
        if (value is List && value.isNotEmpty) {
          final first = value.first;
          if (first is String && first.trim().isNotEmpty) {
            return first.trim();
          }
        }
      }
    }

    if (data is String && data.trim().isNotEmpty) {
      return data.trim();
    }

    return null;
  }
}
