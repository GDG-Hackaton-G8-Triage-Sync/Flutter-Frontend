import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter_frontend/core/constants/api_endpoints.dart';
import 'package:flutter_frontend/core/services/session_service.dart';

typedef UnauthorizedHandler = Future<void> Function();

class AuthInterceptor extends QueuedInterceptor {
  AuthInterceptor({
    required Dio dio,
    required Dio authDio,
    required SessionService sessionService,
    this.onUnauthorized,
  }) : _dio = dio,
       _authDio = authDio,
       _sessionService = sessionService;

  static const String retryKey = 'auth_retried';
  static const String skipAuthKey = 'skip_auth';

  final Dio _dio;
  final Dio _authDio;
  final SessionService _sessionService;
  final UnauthorizedHandler? onUnauthorized;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final skipAuth = options.extra[skipAuthKey] == true;
    final isRefreshCall = options.path.contains(ApiEndpoints.authRefresh);
    if (skipAuth || isRefreshCall) {
      handler.next(options);
      return;
    }

    try {
      final token = await _sessionService.getAccessToken();
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('AUTH_INTERCEPTOR token read failed: $e');
      }
    }

    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final statusCode = err.response?.statusCode;
    final request = err.requestOptions;

    final isRefreshCall = request.path.contains(ApiEndpoints.authRefresh);
    final isLogoutCall = request.path.contains(ApiEndpoints.authLogout);
    final alreadyRetried = request.extra[retryKey] == true;

    if (statusCode == 401 && !isRefreshCall && !isLogoutCall && !alreadyRetried) {
      String? refreshToken;
      try {
        refreshToken = await _sessionService.getRefreshToken();
      } catch (e) {
        if (kDebugMode) {
          debugPrint('AUTH_INTERCEPTOR refresh token read failed: $e');
        }
      }

      if (refreshToken == null || refreshToken.isEmpty) {
        await _handleUnauthorized();
        handler.next(err);
        return;
      }

      try {
        final newToken = await _refreshAccessToken(refreshToken);
        await _sessionService.updateAccessToken(newToken);

        request.headers['Authorization'] = 'Bearer $newToken';
        request.extra[retryKey] = true;

        final retriedResponse = await _dio.fetch(request);
        handler.resolve(retriedResponse);
        return;
      } catch (_) {
        await _handleUnauthorized();
      }
    }

    handler.next(err);
  }

  Future<String> _refreshAccessToken(String refreshToken) async {
    final response = await _authDio.post<Map<String, dynamic>>(
      ApiEndpoints.authRefresh,
      data: <String, dynamic>{'refresh': refreshToken},
      options: Options(extra: <String, dynamic>{skipAuthKey: true}),
    );

    final token =
        (response.data?['access_token'] ?? response.data?['access'] ?? '')
            .toString();

    if (token.isEmpty) {
      throw StateError('Refresh response does not contain an access token');
    }

    return token;
  }

  Future<void> _handleUnauthorized() async {
    await _sessionService.clear();
    if (onUnauthorized != null) {
      await onUnauthorized!();
    }
  }
}
