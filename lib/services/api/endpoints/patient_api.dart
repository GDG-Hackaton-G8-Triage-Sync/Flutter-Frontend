import 'package:dio/dio.dart';

import '../../../features/shared/models/patient_models.dart';
import '../dio_client.dart';

class PatientApi {
  final Dio _dio = DioClient.instance;

  Future<TriageResult> submitSymptoms(String description) async {
    final response = await _dio.post<dynamic>(
      '/api/patient/symptoms/',
      data: SymptomSubmission(description: description).toJson(),
    );

    return TriageResult.fromJson(response.data as Map<String, dynamic>);
  }
}
