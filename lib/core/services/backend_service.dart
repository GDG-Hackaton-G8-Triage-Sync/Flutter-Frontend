import 'package:dio/dio.dart';

import 'package:flutter_frontend/core/config/api_config.dart';
import 'package:flutter_frontend/core/models/api_models.dart';
import 'package:flutter_frontend/core/services/session_service.dart';
import 'package:flutter_frontend/core/services/cache_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_frontend/core/utils/globals.dart';
import 'package:flutter_frontend/features/auth/presentation/pages/login_screen.dart';

class BackendService {
  BackendService._();

  static final BackendService instance = BackendService._();

  static String get _baseUrl => ApiConfig.baseUrl;

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
      data: <String, dynamic>{'refresh': refreshToken},
    );

    final token =
        (response.data?['access_token'] ?? response.data?['access'] ?? '')
            .toString();
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
      data: <String, dynamic>{'username': email, 'password': password},
    );

    final auth = AuthResponse.fromJson(response.data ?? <String, dynamic>{});

    if (auth.accessToken.isEmpty || auth.refreshToken.isEmpty) {
      throw Exception('Login response missing JWT tokens');
    }

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
    final backendRole = role == 'staff' ? 'nurse' : role;

    await _dio.post<void>(
      '/api/v1/auth/register/',
      data: <String, dynamic>{
        'name': name,
        'email': email,
        'password': password,
        'role': backendRole,
        if (age != null || backendRole != 'patient') 'age': age ?? 0,
        if (gender != null) 'gender': gender,
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
      final response = await _dio.get<dynamic>(
        '/api/v1/dashboard/staff/patients/',
        queryParameters: <String, dynamic>{
          if (priority != null) 'priority': priority,
          if (status != null && status.isNotEmpty) 'status': status,
        },
      );

      final data = _extractList(response.data);
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
    await _dio.patch<Map<String, dynamic>>(
      '/api/v1/dashboard/staff/patient/$id/status/',
      data: <String, dynamic>{'status': status},
    );

    return _fetchStaffPatientById(id);
  }

  Future<TriageItem> updatePatientPriority({
    required int id,
    required int priority,
  }) async {
    await _dio.patch<Map<String, dynamic>>(
      '/api/v1/dashboard/staff/patient/$id/priority/',
      data: <String, dynamic>{'priority': priority},
    );

    return _fetchStaffPatientById(id);
  }

  Future<TriageItem> verifyTriage({
    required int id,
    required String nurseName,
  }) async {
    await _dio.patch<Map<String, dynamic>>(
      '/api/v1/dashboard/staff/patient/$id/verify/',
      data: <String, dynamic>{},
    );

    return _fetchStaffPatientById(id);
  }

  Future<TriageItem> logVitals({
    required int id,
    required String bp,
    required String heartRate,
    required String temperature,
  }) async {
    throw UnsupportedError(
      'The Django backend does not expose a vitals logging endpoint yet.',
    );
  }

  Future<AdminOverview> getAdminOverview() async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '/api/v1/dashboard/admin/overview/',
      );
      return AdminOverview.fromJson(response.data ?? <String, dynamic>{});
    } on DioException catch (error) {
      if (error.response?.statusCode == 403) {
        return AdminOverview.fromJson(<String, dynamic>{});
      }
      rethrow;
    }
  }

  Future<AdminAnalytics> getAdminAnalytics() async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '/api/v1/dashboard/admin/analytics/',
      );
      return AdminAnalytics.fromJson(response.data ?? <String, dynamic>{});
    } on DioException catch (error) {
      if (error.response?.statusCode == 403) {
        return AdminAnalytics.fromJson(<String, dynamic>{});
      }
      rethrow;
    }
  }

  Future<List<AppUser>> getUsers() async {
    final response = await _dio.get<dynamic>('/api/v1/admin/users/');
    final data = _extractList(response.data);
    return data
        .whereType<Map<String, dynamic>>()
        .map(AppUser.fromJson)
        .toList();
  }

  Future<AppUser> updateUserRole({
    required int id,
    required String role,
  }) async {
    final backendRole = role == 'staff' ? 'nurse' : role;
    await _dio.patch<Map<String, dynamic>>(
      '/api/v1/admin/users/$id/role/',
      data: <String, dynamic>{'role': backendRole},
    );

    final users = await getUsers();
    return users.firstWhere(
      (user) => user.id == id,
      orElse: () => AppUser(id: id, name: '', email: '', role: backendRole),
    );
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
    throw UnsupportedError(
      'The Django backend deletes submissions by submission id, not users.',
    );
  }

  Future<List<TriageItem>> getPatientSubmissionsByEmail(String email) async {
    final response = await _dio.get<dynamic>(
      '/api/v1/patients/triage-submissions/',
      queryParameters: <String, dynamic>{'email': email},
    );

    final data = _extractList(response.data);
    return data
        .whereType<Map<String, dynamic>>()
        .map(TriageItem.fromJson)
        .toList();
  }

  Future<WaitingAnalytics> getWaitingAnalytics(int id) async {
    throw UnsupportedError(
      'The Django backend does not expose waiting analytics yet.',
    );
  }

  List<dynamic> _extractList(dynamic data) {
    if (data is List) return data;
    if (data is Map<String, dynamic>) {
      final results = data['results'];
      if (results is List) return results;

      final submissions = data['submissions'];
      if (submissions is List) return submissions;
    }
    return <dynamic>[];
  }

  Future<TriageItem> _fetchStaffPatientById(int id) async {
    final patients = await getStaffPatients();
    return patients.firstWhere(
      (patient) => patient.id == id,
      orElse: () => TriageItem.fromJson(<String, dynamic>{'id': id}),
    );
  }
}
