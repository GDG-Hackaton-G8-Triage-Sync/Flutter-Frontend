import 'package:dio/dio.dart';

import '../../../features/shared/models/admin_models.dart';
import '../dio_client.dart';

class AdminApi {
  final Dio _dio = DioClient.instance;

  Future<SystemOverview> getOverview() async {
    final response = await _dio.get<dynamic>('/api/admin/overview/');
    return SystemOverview.fromJson(response.data as Map<String, dynamic>);
  }

  Future<Analytics> getAnalytics() async {
    final response = await _dio.get<dynamic>('/api/admin/analytics/');
    return Analytics.fromJson(response.data as Map<String, dynamic>);
  }

  Future<List<User>> getUsers() async {
    final response = await _dio.get<dynamic>('/api/admin/users/');

    final data = response.data;
    final listData = data is List
        ? data
        : data is Map<String, dynamic> && data['results'] is List
        ? data['results'] as List<dynamic>
        : <dynamic>[];

    return listData
        .whereType<Map<String, dynamic>>()
        .map(User.fromJson)
        .toList();
  }
}
