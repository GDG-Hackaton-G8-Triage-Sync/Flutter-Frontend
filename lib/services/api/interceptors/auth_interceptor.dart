import 'package:dio/dio.dart';
import '../../secure_storage/secure_storage_service.dart';
import '../../../core/utils/env_loader.dart';

class AuthInterceptor extends Interceptor {
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final storage = SecureStorageService();
    final token = await storage.getAccessToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      final storage = SecureStorageService();
      final refreshToken = await storage.getRefreshToken();
      if (refreshToken != null) {
        try {
          final newToken = await _refreshAccessToken(refreshToken);
          await storage.saveAccessToken(newToken);

          final opts = err.requestOptions;
          opts.headers['Authorization'] = 'Bearer $newToken';
          final retryResponse = await Dio().fetch(opts);
          handler.resolve(retryResponse);
          return;
        } catch (e) {
          await storage.clearAll();
          // Logout logic triggered by stream later
        }
      }
    }
    handler.next(err);
  }

  Future<String> _refreshAccessToken(String refreshToken) async {
    final dio = Dio();
    final response = await dio.post(
      '${EnvLoader.apiUrl}/api/auth/refresh/',
      data: {'refresh_token': refreshToken},
    );
    return response.data['access_token'];
  }
}
