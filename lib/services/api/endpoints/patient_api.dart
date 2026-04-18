import 'package:dio/dio.dart';

import '../../../models/api_models.dart';
import '../dio_client.dart';

class PatientApi {
  final Dio _dio = DioClient.instance;

  Future<TriageItem> submitSymptoms(String description) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/api/triage/',
      data: <String, dynamic>{'description': description},
    );

    return TriageItem.fromJson(response.data ?? <String, dynamic>{});
  }
}
