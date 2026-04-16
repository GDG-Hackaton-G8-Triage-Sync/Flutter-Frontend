import 'dart:async';

import 'package:dio/dio.dart';

import '../../../core/utils/env_loader.dart';
import '../../secure_storage/secure_storage_service.dart';

class AuthInterceptor extends Interceptor {
  AuthInterceptor(this._dio);

  final Dio _dio;
  final SecureStorageService _storage = SecureStorageService();
  late final Dio _refreshDio = Dio(
    BaseOptions(
      baseUrl: EnvLoader.apiUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: const {'Content-Type': 'application/json'},
    ),
  );

  Future<String>? _refreshFuture;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _storage.getAccessToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final isUnauthorized = err.response?.statusCode == 401;
    final alreadyRetried = err.requestOptions.extra['retry_attempted'] == true;
    final isRefreshRequest = err.requestOptions.path.contains(
      '/api/auth/refresh/',
    );

    if (!isUnauthorized || alreadyRetried || isRefreshRequest) {
      handler.next(err);
      return;
    }

    final refreshToken = await _storage.getRefreshToken();
    if (refreshToken == null || refreshToken.isEmpty) {
      await _storage.clearAll();
      handler.next(err);
      return;
    }

    try {
      final newAccessToken = await _queueTokenRefresh(refreshToken);
      await _storage.saveAccessToken(newAccessToken);

      final retryOptions = err.requestOptions;
      retryOptions.headers['Authorization'] = 'Bearer $newAccessToken';
      retryOptions.extra['retry_attempted'] = true;

      final response = await _dio.fetch<dynamic>(retryOptions);
      handler.resolve(response);
    } catch (_) {
      await _storage.clearAll();
      handler.next(err);
    }
  }

  Future<String> _queueTokenRefresh(String refreshToken) {
    if (_refreshFuture != null) {
      return _refreshFuture!;
    }

    _refreshFuture = _refreshAccessToken(refreshToken).whenComplete(() {
      _refreshFuture = null;
    });

    return _refreshFuture!;
  }

  Future<String> _refreshAccessToken(String refreshToken) async {
    final response = await _refreshDio.post<dynamic>(
      '/api/auth/refresh/',
      data: {'refresh_token': refreshToken},
    );

    final data = response.data;
    if (data is Map<String, dynamic>) {
      final token = data['access_token'];
      if (token is String && token.isNotEmpty) {
        return token;
      }
    }

    throw Exception('Refresh token response did not contain access_token');
  }
}
