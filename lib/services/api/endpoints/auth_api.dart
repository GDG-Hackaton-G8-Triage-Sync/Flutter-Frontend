import 'package:dio/dio.dart';
import '../dio_client.dart';
import '../../../features/shared/models/auth_models.dart';

class AuthApi {
  final Dio _dio = DioClient.instance;

  Future<AuthResponse> login(String email, String password) async {
    try {
      final response = await _dio.post(
        '/api/auth/login/',
        data: {'email': email, 'password': password},
      );
      return AuthResponse.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<AuthResponse> refresh(String refreshToken) async {
    final response = await _dio.post(
      '/api/auth/refresh/',
      data: {'refresh_token': refreshToken},
    );
    return AuthResponse.fromJson(response.data);
  }
}
