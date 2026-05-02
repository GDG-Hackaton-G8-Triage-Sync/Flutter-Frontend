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
              try {
                debugPrint('NETWORK_REQ: ${options.method} ${options.baseUrl}${options.path}');
                final token = await _sessionService.getAccessToken();
                if (token != null && token.isNotEmpty) {
                  options.headers['Authorization'] = 'Bearer $token';
                }
                handler.next(options);
              } catch (e) {
                debugPrint('INTERCEPTOR_ERROR: $e');
                handler.next(options); // Continue even if token retrieval fails
              }
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
    required String username,
    required String password,
  }) async {
    try {
      debugPrint('LOGGING_IN: $username to $_baseUrl/api/v1/auth/login/');
      final response = await _dio.post<Map<String, dynamic>>(
        '/api/v1/auth/login/',
        data: <String, dynamic>{'username': username, 'password': password},
      );

      final auth = AuthResponse.fromJson(response.data ?? <String, dynamic>{});

      if (auth.accessToken.isEmpty || auth.refreshToken.isEmpty) {
        throw Exception('Login response missing JWT tokens: ${response.data}');
      }

      await _sessionService.saveSession(
        accessToken: auth.accessToken,
        refreshToken: auth.refreshToken,
        role: auth.role,
        email: auth.email,
        name: auth.name,
      );

      return auth;
    } on DioException catch (e) {
      debugPrint('Login failed: ${e.message}, Response: ${e.response?.data}');
      rethrow;
    }
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
        'password2': password,
        'role': role,
        if (age != null) 'age': age,
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
    String? photoName, // Match v1.6.0 doc field name
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/api/v1/triage/',
      data: <String, dynamic>{
        'description': description,
        if (photoName != null) 'photo_name': photoName,
      },
    );

    return TriageItem.fromJson(response.data ?? <String, dynamic>{});
  }

  Future<TriageItem> analyzeSymptomsAi({
    required String symptoms,
    int? age,
    String? gender,
    String? bloodType,
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/api/v1/triage/ai/',
      data: <String, dynamic>{
        'symptoms': symptoms,
        if (age != null) 'age': age,
        if (gender != null) 'gender': gender,
        if (bloodType != null) 'blood_type': bloodType,
      },
    );
    return TriageItem.fromJson(response.data ?? <String, dynamic>{});
  }

  Future<TriageItem> extractSymptomsFromPdf({
    required String filePath,
    int? age,
    String? gender,
    String? bloodType,
  }) async {
    final formData = FormData.fromMap(<String, dynamic>{
      'file': await MultipartFile.fromFile(filePath),
      if (age != null) 'age': age,
      if (gender != null) 'gender': gender,
      if (bloodType != null) 'blood_type': bloodType,
    });

    final response = await _dio.post<Map<String, dynamic>>(
      '/api/v1/triage/pdf-extract/',
      data: formData,
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
    final response = await _dio.patch<Map<String, dynamic>>(
      '/api/v1/dashboard/staff/patient/$id/status/',
      data: <String, dynamic>{'status': status},
    );

    return TriageItem.fromJson(response.data ?? <String, dynamic>{});
  }

  Future<TriageItem> updatePatientPriority({
    required int id,
    required int priority,
  }) async {
    final response = await _dio.patch<Map<String, dynamic>>(
      '/api/v1/dashboard/staff/patient/$id/priority/',
      data: <String, dynamic>{'priority': priority},
    );

    return TriageItem.fromJson(response.data ?? <String, dynamic>{});
  }

  Future<void> logVitals({
    required int id,
    required String bp,
    required String heartRate,
    required String temperature,
  }) async {
    // POST /api/v1/triage/{id}/vitals/ (VitalsHistoryView)
    final data = <String, dynamic>{
      'blood_pressure': bp,
      if (int.tryParse(heartRate) != null) 'heart_rate': int.parse(heartRate),
      if (double.tryParse(temperature) != null) 'temperature': double.parse(temperature),
    };

    await _dio.post<dynamic>(
      '/api/v1/triage/$id/vitals/',
      data: data,
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
    int? age,
    String? gender,
    String? bloodType,
    String? healthHistory,
    String? allergies,
    String? currentMedications,
    String? badHabits,
  }) async {
    final response = await _dio.patch<Map<String, dynamic>>(
      '/api/v1/profile/',
      data: <String, dynamic>{
        'name': name,
        'email': email,
        if (age != null) 'age': age,
        if (gender != null) 'gender': gender,
        if (bloodType != null) 'blood_type': bloodType,
        if (healthHistory != null) 'health_history': healthHistory,
        if (allergies != null) 'allergies': allergies,
        if (currentMedications != null) 'current_medications': currentMedications,
        if (badHabits != null) 'bad_habits': badHabits,
      },
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


  Future<void> deleteUser(int id) async {
    await _dio.delete<void>('/api/v1/admin/users/$id/');
  }

  Future<void> suspendUser(int id) async {
    await _dio.patch<dynamic>('/api/v1/admin/users/$id/suspend/');
  }

  Future<Map<String, dynamic>> getReportSummary({
    String? startDate,
    String? endDate,
  }) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/api/v1/admin/reports/summary/',
      queryParameters: <String, dynamic>{
        if (startDate != null) 'start_date': startDate,
        if (endDate != null) 'end_date': endDate,
      },
    );
    return response.data ?? <String, dynamic>{};
  }


  Future<List<TriageItem>> getPatientSubmissions() async {
    final response = await _dio.get<dynamic>(
      '/api/v1/patients/triage-submissions/',
    );

    final data = _extractList(response.data);
    return data
        .whereType<Map<String, dynamic>>()
        .map(TriageItem.fromJson)
        .toList();
  }

  Future<WaitingAnalytics> getWaitingAnalytics(int id) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '/api/v1/triage/$id/waiting-analytics/',
      );

      final data = response.data ?? <String, dynamic>{};
      
      return WaitingAnalytics(
        position: (data['queue_position'] as num?)?.toInt() ?? 1,
        totalWaiting: (data['patients_ahead'] as num?)?.toInt() ?? 1,
        estimatedWaitMins: (data['estimated_wait_minutes'] as num?)?.toInt() ?? 15,
        aiConfidence: 0.8,
        message: 'Live analytics connected.',
      );
    } catch (_) {
      return WaitingAnalytics(
        position: 1,
        totalWaiting: 1,
        estimatedWaitMins: 15,
        aiConfidence: 0.72,
        message: 'Live wait analytics fallback.',
      );
    }
  }

  Future<List<AppNotification>> getNotifications({
    bool fallbackToLocal = true,
  }) async {
    try {
      final response = await _dio.get<dynamic>(
        '/api/v1/notifications/',
      );

      final data = response.data;
      final list = data is Map<String, dynamic>
          ? _extractList(data['data'])
          : _extractList(data);

      return list
          .whereType<Map<String, dynamic>>()
          .map(AppNotification.fromJson)
          .toList();
    } on DioException {
      if (!fallbackToLocal) rethrow;
      return _localNotifications();
    }
  }

  Future<int> getUnreadNotificationCount() async {
    try {
      final response = await _dio.get<dynamic>(
        '/api/v1/notifications/unread-count/',
      );
      final data = response.data;
      if (data is Map<String, dynamic>) {
        final payload = data['data'];
        if (payload is Map<String, dynamic>) {
          return (payload['unread_count'] as num? ?? 0).toInt();
        }
      }
    } on DioException {
      // Fall back to local unread count below.
    }

    final local = _localNotifications();
    return local.where((notification) => !notification.isRead).length;
  }

  Future<void> markAllNotificationsRead() async {
    try {
      await _dio.patch<dynamic>(
        '/api/v1/notifications/read-all/',
      );
    } on DioException {
      // Local fallback notifications are read-only placeholders.
    }
  }

  Future<List<AuditLogEntry>> getAuditLogs() async {
    final response = await _dio.get<dynamic>('/api/v1/admin/audit-logs/');
    final data = _extractList(response.data);
    return data.whereType<Map<String, dynamic>>().map(AuditLogEntry.fromJson).toList();
  }

  Future<void> verifyPatient(int id) async {
    // Section 4B: POST /api/staff/patient/{id}/confirm-priority/
    await _dio.post<dynamic>('/api/v1/staff/patient/$id/confirm-priority/');
  }

  Future<List<StaffNote>> getStaffNotes(int id) async {
    try {
      final response = await _dio.get<dynamic>('/api/v1/staff/patient/$id/notes/');
      final data = _extractList(response.data);
      return data.whereType<Map<String, dynamic>>().map(StaffNote.fromJson).toList();
    } catch (_) {
      return [];
    }
  }

  Future<StaffNote> addStaffNote(int id, String content, bool isInternal) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/api/v1/staff/patient/$id/notes/',
      data: <String, dynamic>{
        'content': content,
        'is_internal': isInternal,
      },
    );
    return StaffNote.fromJson(response.data ?? <String, dynamic>{});
  }

  Future<void> assignStaff(int id) async {
    await _dio.patch<dynamic>('/api/v1/staff/patient/$id/assign/');
  }

  Future<List<VitalsLog>> getVitalsHistory(int id) async {
    try {
      final response = await _dio.get<dynamic>('/api/v1/staff/patient/$id/vitals/history/');
      final data = _extractList(response.data);
      return data.whereType<Map<String, dynamic>>().map(VitalsLog.fromJson).toList();
    } catch (_) {
      return [];
    }
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

  List<AppNotification> _localNotifications() {
    final now = DateTime.now();
    return <AppNotification>[
      AppNotification(
        id: -1,
        type: 'triage_status_change',
        title: 'Triage status ready',
        message:
            'Your triage queue status will appear here when the backend notification feed is reachable.',
        isRead: false,
        createdAt: now.subtract(const Duration(minutes: 2)),
      ),
      AppNotification(
        id: -2,
        type: 'system_message',
        title: 'Django notification fallback',
        message:
            'This local item keeps the inbox usable while server notifications are being finalized.',
        isRead: false,
        createdAt: now.subtract(const Duration(hours: 1)),
      ),
    ];
  }
}
