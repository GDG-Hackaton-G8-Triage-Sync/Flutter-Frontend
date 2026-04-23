import 'package:dio/dio.dart';

import 'package:flutter_frontend/features/shared/models/queue_models.dart';
import '../dio_client.dart';

class StaffApi {
  final Dio _dio = DioClient.instance;

  Future<List<QueuePatient>> getQueue() async {
    final response = await _dio.get<dynamic>('/api/staff/queue/');

    final data = response.data;
    final listData = data is List
        ? data
        : data is Map<String, dynamic> && data['results'] is List
        ? data['results'] as List<dynamic>
        : <dynamic>[];

    return listData
        .whereType<Map<String, dynamic>>()
        .map(QueuePatient.fromJson)
        .toList();
  }

  Future<QueuePatient> updatePatientStatus(
    int patientId,
    String status,
  ) async {
    final response = await _dio.patch<dynamic>(
      '/api/staff/patient/$patientId/status/',
      data: {'status': status},
    );

    return QueuePatient.fromJson(response.data as Map<String, dynamic>);
  }
}
