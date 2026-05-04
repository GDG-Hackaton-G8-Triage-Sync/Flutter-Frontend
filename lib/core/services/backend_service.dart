import 'dart:typed_data';

import 'package:dio/dio.dart';

import 'package:flutter_frontend/core/config/api_config.dart';
import 'package:flutter_frontend/core/constants/api_endpoints.dart';
import 'package:flutter_frontend/core/models/api_models.dart';
import 'package:flutter_frontend/core/network/interceptors/interceptor_setup.dart';
import 'package:flutter_frontend/core/services/session_service.dart';
import 'package:flutter_frontend/core/services/cache_service.dart';
import 'package:flutter_frontend/core/services/websocket_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_frontend/core/utils/globals.dart';
import 'package:flutter_frontend/features/auth/presentation/pages/login_screen.dart';

class BackendService {
  BackendService._() {
    _dio.configureDioInterceptors(
      sessionService: _sessionService,
      authDio: _authDio,
      onUnauthorized: () async {
        _forceLogout();
      },
    );
  }

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

  late final Dio _dio = Dio(
    BaseOptions(
      baseUrl: _baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: <String, String>{'Content-Type': 'application/json'},
    ),
  );

  void _forceLogout() {
    globalNavigatorKey.currentState?.pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  Future<AuthResponse> login({
    required String username,
    required String password,
  }) async {
    try {
      debugPrint('LOGGING_IN: $username to $_baseUrl${ApiEndpoints.authLogin}');
      final response = await _dio.post<Map<String, dynamic>>(
        ApiEndpoints.authLogin,
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
      ApiEndpoints.authRegister,
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
      ApiEndpoints.triageAi,
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
      ApiEndpoints.triageAi,
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
      ApiEndpoints.triageAi,
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
        ApiEndpoints.dashboardStaffPatients,
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
      ApiEndpoints.dashboardStaffPatientStatus(id),
      data: <String, dynamic>{'status': status},
    );

    return TriageItem.fromJson(response.data ?? <String, dynamic>{});
  }

  Future<TriageItem> updatePatientPriority({
    required int id,
    required int priority,
  }) async {
    final response = await _dio.patch<Map<String, dynamic>>(
      ApiEndpoints.dashboardStaffPatientPriority(id),
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
    final data = <String, dynamic>{
      'blood_pressure': bp,
      if (int.tryParse(heartRate) != null) 'heart_rate': int.parse(heartRate),
      if (double.tryParse(temperature) != null)
        'temperature': double.parse(temperature),
    };

    await _dio.post<dynamic>(ApiEndpoints.triageVitals(id), data: data);
  }

  Future<AdminOverview> getAdminOverview() async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        ApiEndpoints.dashboardAdminOverview,
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
        ApiEndpoints.dashboardAdminAnalytics,
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
    final response = await _dio.get<dynamic>(ApiEndpoints.adminUsers);
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
      ApiEndpoints.adminUserRole(id),
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
    String? medications,
    String? lifestyleHabits,
    Uint8List? profilePhotoBytes,
    String? profilePhotoName,
  }) async {
    final formData = FormData.fromMap(<String, dynamic>{
      'name': name,
      'email': email,
      if (age != null) 'age': age,
      if (gender != null) 'gender': gender,
      if (bloodType != null) 'blood_type': bloodType,
      if (healthHistory != null) 'health_history': healthHistory,
      if (allergies != null) 'allergies': allergies,
      if (medications != null) 'medications': medications,
      if (medications != null) 'current_medications': medications,
      if (lifestyleHabits != null) 'lifestyle_habits': lifestyleHabits,
      if (lifestyleHabits != null) 'bad_habits': lifestyleHabits,
      if (profilePhotoBytes != null)
        'profile_photo': MultipartFile.fromBytes(
          profilePhotoBytes,
          filename: (profilePhotoName != null && profilePhotoName.isNotEmpty)
              ? profilePhotoName
              : 'profile_photo',
        ),
    });

    final response = await _dio.patch<Map<String, dynamic>>(
      ApiEndpoints.profile,
      data: formData,
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
      if ((data['profile_photo_name'] ?? '').toString().isNotEmpty)
        'profilePhotoName': data['profile_photo_name'].toString(),
      if ((data['profile_photo_url'] ?? data['profile_photo'] ?? '')
          .toString()
          .isNotEmpty)
        'profilePhotoUrl':
            data['profile_photo_url']?.toString() ??
            data['profile_photo']?.toString() ??
            '',
    };
  }

  Future<PatientProfile> getProfile() async {
    final response = await _dio.get<Map<String, dynamic>>(ApiEndpoints.profile);
    return PatientProfile.fromJson(response.data ?? <String, dynamic>{});
  }

  Future<void> logout() async {
    try {
      final refresh = await _sessionService.getRefreshToken();
      await _dio.post<dynamic>(
        ApiEndpoints.authLogout,
        data: <String, dynamic>{'refresh': refresh ?? ''},
      );
    } catch (_) {
      // ignore network errors during logout
    }

    // Ensure local session cleanup and realtime disconnect
    WebSocketManager.instance.disconnect();
    await _sessionService.clear();
  }

  Future<void> deleteUser(int id) async {
    await _dio.delete<void>(ApiEndpoints.adminUser(id));
  }

  Future<void> suspendUser(int id) async {
    await _dio.patch<dynamic>(ApiEndpoints.adminUserSuspend(id));
  }

  Future<Map<String, dynamic>> getReportSummary({
    String? startDate,
    String? endDate,
  }) async {
    // The backend exposes a CSV export at admin/reports/export/ and a JSON overview
    // at dashboard/admin/overview/. For UI summary counts, use the overview endpoint.
    final response = await _dio.get<Map<String, dynamic>>(
      ApiEndpoints.dashboardAdminOverview,
      queryParameters: <String, dynamic>{
        if (startDate != null) 'start_date': startDate,
        if (endDate != null) 'end_date': endDate,
      },
    );

    return response.data ?? <String, dynamic>{};
  }

  Future<TriageItem?> getCurrentPatientSubmission() async {
    try {
      final response = await _dio.get<dynamic>(ApiEndpoints.patientCurrent);
      final data = response.data;
      if (data is Map<String, dynamic>) {
        return TriageItem.fromJson(data);
      }
      if (data is List &&
          data.isNotEmpty &&
          data.first is Map<String, dynamic>) {
        return TriageItem.fromJson(data.first as Map<String, dynamic>);
      }
    } on DioException {
      return null;
    }
    return null;
  }

  Future<List<TriageItem>> getPatientHistory() async {
    try {
      final response = await _dio.get<dynamic>(ApiEndpoints.patientHistory);
      final data = _extractList(response.data);
      return data
          .whereType<Map<String, dynamic>>()
          .map(TriageItem.fromJson)
          .toList();
    } on DioException {
      return <TriageItem>[];
    }
  }

  Future<List<TriageItem>> getPatientSubmissions() async {
    try {
      final response = await _dio.get<dynamic>(
        ApiEndpoints.patientTriageSubmissions,
      );

      final data = _extractList(response.data);
      return data
          .whereType<Map<String, dynamic>>()
          .map(TriageItem.fromJson)
          .toList();
    } on DioException {
      return <TriageItem>[];
    }
  }

  Future<WaitingAnalytics> getWaitingAnalytics(int id) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        ApiEndpoints.triageWaitingAnalytics(id),
      );

      final data = response.data ?? <String, dynamic>{};

      return WaitingAnalytics(
        position: (data['queue_position'] as num?)?.toInt() ?? 1,
        totalWaiting: (data['patients_ahead'] as num?)?.toInt() ?? 1,
        estimatedWaitMins:
            (data['estimated_wait_minutes'] as num?)?.toInt() ?? 15,
        aiConfidence: (data['ai_confidence'] as num?)?.toDouble() ?? 0.0,
        message: 'Live analytics connected.',
      );
    } on DioException catch (_) {
      // Backend does not expose per-triage waiting analytics in this API.
      // Return a conservative fallback so UI remains stable.
      return WaitingAnalytics(
        position: 1,
        totalWaiting: 1,
        estimatedWaitMins: 15,
        aiConfidence: 0.0,
        message: 'Analytics unavailable',
      );
    }
  }

  Future<List<AppNotification>> getNotifications() async {
    final response = await _dio.get<dynamic>(ApiEndpoints.notifications);

    final data = response.data;
    final list = data is Map<String, dynamic>
        ? _extractList(data['data'])
        : _extractList(data);

    return list
        .whereType<Map<String, dynamic>>()
        .map(AppNotification.fromJson)
        .toList();
  }

  Future<int> getUnreadNotificationCount() async {
    final response = await _dio.get<dynamic>(
      ApiEndpoints.notificationsUnreadCount,
    );

    final data = response.data;
    if (data is Map<String, dynamic>) {
      // Support multiple shapes: { "unread_count": 5 } or { "data": { "unread_count": 5 } }
      if (data.containsKey('unread_count')) {
        return (data['unread_count'] as num? ?? 0).toInt();
      }
      final payload = data['data'];
      if (payload is Map<String, dynamic> &&
          payload.containsKey('unread_count')) {
        return (payload['unread_count'] as num? ?? 0).toInt();
      }
    }

    return 0;
  }

  Future<void> markAllNotificationsRead() async {
    try {
      await _dio.patch<dynamic>(ApiEndpoints.notificationsReadAll);
    } on DioException {
      // Local fallback notifications are read-only placeholders.
    }
  }

  Future<AppNotification?> markNotificationRead(int id) async {
    try {
      final response = await _dio.patch<dynamic>(ApiEndpoints.notificationRead(id));
      final data = response.data;
      if (data is Map<String, dynamic>) {
        final payload = data['data'];
        if (payload is Map<String, dynamic>) {
          return AppNotification.fromJson(payload);
        }
        return AppNotification.fromJson(data);
      }
    } on DioException {
      // Keep inbox usable even if backend rejects/omits item-level read updates.
    }
    return null;
  }

  Future<List<AuditLogEntry>> getAuditLogs() async {
    final response = await _dio.get<dynamic>(ApiEndpoints.adminAuditLogs);
    final data = _extractList(response.data);
    return data
        .whereType<Map<String, dynamic>>()
        .map(AuditLogEntry.fromJson)
        .toList();
  }

  Future<void> verifyPatient(int id) async {
    await _dio.patch<dynamic>(ApiEndpoints.dashboardStaffPatientVerify(id));
  }

  Future<List<StaffNote>> getStaffNotes(int id) async {
    try {
      final response = await _dio.get<dynamic>(ApiEndpoints.triageNotes(id));
      final data = _extractList(response.data);
      return data
          .whereType<Map<String, dynamic>>()
          .map(StaffNote.fromJson)
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<StaffNote> addStaffNote(
    int id,
    String content,
    bool isInternal,
  ) async {
    final response = await _dio.post<Map<String, dynamic>>(
      ApiEndpoints.triageNotes(id),
      data: <String, dynamic>{'content': content, 'is_internal': isInternal},
    );
    return StaffNote.fromJson(response.data ?? <String, dynamic>{});
  }

  Future<void> assignStaff(int id) async {
    await _dio.patch<dynamic>(ApiEndpoints.triageAssign(id));
  }

  Future<List<VitalsLog>> getVitalsHistory(int id) async {
    try {
      final response = await _dio.get<dynamic>(
        ApiEndpoints.triageVitalsHistory(id),
      );
      final data = _extractList(response.data);
      return data
          .whereType<Map<String, dynamic>>()
          .map(VitalsLog.fromJson)
          .toList();
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
}
