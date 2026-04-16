import 'package:dio/dio.dart';

import '../../../features/shared/models/auth_models.dart';
import '../dio_client.dart';

class AuthApi {
  final Dio _dio = DioClient.instance;

  Future<AuthResponse> login(String email, String password) async {
    final response = await _dio.post<dynamic>(
      '/api/auth/login/',
      data: {'email': email, 'password': password},
    );

    return AuthResponse.fromJson(response.data as Map<String, dynamic>);
  }

  Future<AuthResponse> refresh(String refreshToken) async {
    final response = await _dio.post<dynamic>(
      '/api/auth/refresh/',
      data: {'refresh_token': refreshToken},
    );

    return AuthResponse.fromJson(response.data as Map<String, dynamic>);
  }
}
