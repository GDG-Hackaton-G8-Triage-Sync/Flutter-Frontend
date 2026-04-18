import 'package:dio/dio.dart';

import '../../../models/api_models.dart';
import '../dio_client.dart';

class StaffApi {
  final Dio _dio = DioClient.instance;

  Future<List<TriageItem>> getQueue() async {
    final response = await _dio.get<dynamic>('/api/dashboard/staff/patients/');

    final data = response.data;
    final listData = data is List
        ? data
        : data is Map<String, dynamic> && data['results'] is List
        ? data['results'] as List<dynamic>
        : <dynamic>[];

    return listData
        .whereType<Map<String, dynamic>>()
        .map(TriageItem.fromJson)
        .toList();
  }

  Future<TriageItem> updatePatientStatus(int patientId, String status) async {
    final response = await _dio.patch<Map<String, dynamic>>(
      '/api/dashboard/staff/patient/$patientId/status/',
      data: <String, dynamic>{'status': status},
    );

    return TriageItem.fromJson(response.data ?? <String, dynamic>{});
  }
}
