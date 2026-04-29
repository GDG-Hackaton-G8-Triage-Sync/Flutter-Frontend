import 'package:dio/dio.dart';

import 'package:flutter_frontend/core/models/api_models.dart';
import 'package:flutter_frontend/core/network/dio_client.dart';

class PatientApi {
  final Dio _dio = DioClient.instance;

  Future<TriageItem> submitSymptoms(String description) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/api/v1/triage/',
      data: <String, dynamic>{'description': description},
    );

    return TriageItem.fromJson(response.data ?? <String, dynamic>{});
  }
}
