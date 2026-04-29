import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter_frontend/core/models/api_models.dart';
import 'package:flutter_frontend/core/services/session_service.dart';
import 'package:flutter_frontend/core/services/cache_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_frontend/core/utils/globals.dart';
import 'package:flutter_frontend/features/auth/presentation/pages/login_screen.dart';

class BackendService {
  BackendService._();

  static final BackendService instance = BackendService._();

  static String get _baseUrl {
    const envUrl = String.fromEnvironment('API_URL', defaultValue: '');
    if (envUrl.isNotEmpty) {
      return envUrl;
    }
    if (kIsWeb) {
      return 'http://localhost:3001';
    }
    if (Platform.isAndroid) {
      return 'http://10.0.2.2:3001';
    }
    return 'http://localhost:3001';
  }

  final SessionService _sessionService = SessionService();

  late final Dio _authDio = Dio(
    BaseOptions(
      baseUrl: _baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: <String, String>{'Content-Type': 'application/json'},
    ),
  );

  late final Dio _dio =
      Dio(
          BaseOptions(
            baseUrl: _baseUrl,
            connectTimeout: const Duration(seconds: 10),
            receiveTimeout: const Duration(seconds: 10),
            headers: <String, String>{'Content-Type': 'application/json'},
          ),
        )
        ..interceptors.add(
          InterceptorsWrapper(
            onRequest: (options, handler) async {
              final token = await _sessionService.getAccessToken();
              if (token != null && token.isNotEmpty) {
                options.headers['Authorization'] = 'Bearer $token';
              }
              handler.next(options);
            },
            onError: (error, handler) async {
              final statusCode = error.response?.statusCode;
              final req = error.requestOptions;
              final isRefreshCall = req.path == '/api/v1/auth/refresh/';
              final alreadyRetried = req.extra['retried'] == true;

              if (statusCode == 401 && !isRefreshCall && !alreadyRetried) {
                final refreshToken = await _sessionService.getRefreshToken();
                if (refreshToken == null || refreshToken.isEmpty) {
                  await _sessionService.clear();
                  _forceLogout();
                  handler.next(error);
                  return;
                }

                try {
                  final newToken = await _refreshAccessToken(refreshToken);
                  await _sessionService.updateAccessToken(newToken);

                  req.headers['Authorization'] = 'Bearer $newToken';
                  req.extra['retried'] = true;

                  final retried = await _dio.fetch(req);
                  handler.resolve(retried);
                  return;
                } catch (_) {
                  await _sessionService.clear();
                  _forceLogout();
                }
              }

              handler.next(error);
            },
          ),
        );

  void _forceLogout() {
    globalNavigatorKey.currentState?.pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  Future<String> _refreshAccessToken(String refreshToken) async {
    final response = await _authDio.post<Map<String, dynamic>>(
      '/api/v1/auth/refresh/',
      data: <String, dynamic>{'refresh_token': refreshToken},
    );

    final token = (response.data?['access_token'] ?? '') as String;
    if (token.isEmpty) {
      throw Exception('Refresh token response missing access token');
    }

    return token;
  }

  Future<AuthResponse> login({
    required String email,
    required String password,
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/api/v1/auth/login/',
      data: <String, dynamic>{'email': email, 'password': password},
    );

    final auth = AuthResponse.fromJson(response.data ?? <String, dynamic>{});

    await _sessionService.saveSession(
      accessToken: auth.accessToken,
      refreshToken: auth.refreshToken,
      role: auth.role,
      email: auth.email,
      name: auth.name,
    );

    return auth;
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
    String role = 'patient',
    String? gender,
    int? age,
    String? bloodType,
    String? healthHistory,
    String? allergies,
    String? currentMedications,
    String? badHabits,
  }) async {
    await _dio.post<void>(
      '/api/v1/auth/register/',
      data: <String, dynamic>{
        'name': name,
        'email': email,
        'password': password,
        'role': role,
        if (gender != null) 'gender': gender,
        if (age != null) 'age': age,
        if (bloodType != null) 'blood_type': bloodType,
        if (healthHistory != null) 'health_history': healthHistory,
        if (allergies != null) 'allergies': allergies,
        if (currentMedications != null)
          'current_medications': currentMedications,
        if (badHabits != null) 'bad_habits': badHabits,
      },
    );
  }

  Future<TriageItem> submitSymptoms({
    required String description,
    String? photoName,
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/api/v1/triage/',
      data: <String, dynamic>{
        'description': description,
        if (photoName != null && photoName.isNotEmpty) 'photo_name': photoName,
      },
    );

    return TriageItem.fromJson(response.data ?? <String, dynamic>{});
  }

  Future<List<TriageItem>> getStaffPatients({
    int? priority,
    String? status,
  }) async {
    try {
      final response = await _dio.get<List<dynamic>>(
        '/api/v1/staff/patients/',
        queryParameters: <String, dynamic>{
          if (priority != null) 'priority': priority,
          if (status != null && status.isNotEmpty) 'status': status,
        },
      );

      final data = response.data ?? <dynamic>[];
      final items = data
          .whereType<Map<String, dynamic>>()
          .map(TriageItem.fromJson)
          .toList();

      // Cache the full list for offline redundancy
      await CacheService.instance.cachePatients(items);

      return items;
    } on DioException catch (_) {
      // If offline or server down, fallback to cache
      final cached = CacheService.instance.getCachedPatients();
      if (cached.isNotEmpty) {
        return cached;
      }
      rethrow;
    }
  }

  Future<TriageItem> updatePatientStatus({
    required int id,
    required String status,
  }) async {
    final response = await _dio.patch<Map<String, dynamic>>(
      '/api/v1/staff/patient/$id/status/',
      data: <String, dynamic>{'status': status},
    );

    return TriageItem.fromJson(response.data ?? <String, dynamic>{});
  }

  Future<TriageItem> updatePatientPriority({
    required int id,
    required int priority,
  }) async {
    final response = await _dio.patch<Map<String, dynamic>>(
      '/api/v1/staff/patient/$id/priority/',
      data: <String, dynamic>{'priority': priority},
    );

    return TriageItem.fromJson(response.data ?? <String, dynamic>{});
  }

  Future<TriageItem> verifyTriage({
    required int id,
    required String nurseName,
  }) async {
    final response = await _dio.patch<Map<String, dynamic>>(
      '/api/v1/staff/patient/$id/verify/',
      data: <String, dynamic>{'verified_by': nurseName},
    );

    return TriageItem.fromJson(response.data ?? <String, dynamic>{});
  }

  Future<TriageItem> logVitals({
    required int id,
    required String bp,
    required String heartRate,
    required String temperature,
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/api/v1/staff/patient/$id/vitals/',
      data: <String, dynamic>{
        'bp': bp,
        'heart_rate': heartRate,
        'temperature': temperature,
      },
    );

    return TriageItem.fromJson(response.data ?? <String, dynamic>{});
  }

  Future<AdminOverview> getAdminOverview() async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/api/v1/admin/overview/',
    );
    return AdminOverview.fromJson(response.data ?? <String, dynamic>{});
  }

  Future<AdminAnalytics> getAdminAnalytics() async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/api/v1/admin/analytics/',
    );
    return AdminAnalytics.fromJson(response.data ?? <String, dynamic>{});
  }

  Future<List<AppUser>> getUsers() async {
    final response = await _dio.get<List<dynamic>>('/api/v1/admin/users/');
    final data = response.data ?? <dynamic>[];
    return data
        .whereType<Map<String, dynamic>>()
        .map(AppUser.fromJson)
        .toList();
  }

  Future<AppUser> updateUserRole({
    required int id,
    required String role,
  }) async {
    final response = await _dio.patch<Map<String, dynamic>>(
      '/api/v1/admin/users/$id/role/',
      data: <String, dynamic>{'role': role},
    );
    return AppUser.fromJson(response.data ?? <String, dynamic>{});
  }

  Future<Map<String, String>> updateProfile({
    required String name,
    required String email,
  }) async {
    final response = await _dio.patch<Map<String, dynamic>>(
      '/api/v1/profile/',
      data: <String, dynamic>{'name': name, 'email': email},
    );

    final data = response.data ?? <String, dynamic>{};
    final updatedName = (data['name'] ?? name).toString();
    final updatedEmail = (data['email'] ?? email).toString();
    final updatedRole = (data['role'] ?? '').toString();

    await _sessionService.updateProfile(
      name: updatedName,
      email: updatedEmail,
      role: updatedRole,
    );

    return <String, String>{
      'name': updatedName,
      'email': updatedEmail,
      'role': updatedRole,
    };
  }

  Future<void> deletePatient(int id) async {
    await _dio.delete<void>('/api/v1/admin/patient/$id/');
  }

  Future<List<TriageItem>> getPatientSubmissionsByEmail(String email) async {
    final response = await _dio.get<List<dynamic>>(
      '/api/v1/triage-submissions/',
      queryParameters: <String, dynamic>{'email': email},
    );

    final data = response.data ?? <dynamic>[];
    return data
        .whereType<Map<String, dynamic>>()
        .map(TriageItem.fromJson)
        .toList();
  }

  Future<WaitingAnalytics> getWaitingAnalytics(int id) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/api/v1/triage/$id/waiting-analytics/',
    );
    return WaitingAnalytics.fromJson(response.data ?? <String, dynamic>{});
  }
}
