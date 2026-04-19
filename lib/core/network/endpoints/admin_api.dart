import 'package:dio/dio.dart';

import 'package:flutter_frontend/core/models/api_models.dart';
import 'package:flutter_frontend/core/network/dio_client.dart';

class AdminApi {
  final Dio _dio = DioClient.instance;

  Future<AdminOverview> getOverview() async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/api/dashboard/admin/overview/',
    );
    return AdminOverview.fromJson(response.data ?? <String, dynamic>{});
  }

  Future<AdminAnalytics> getAnalytics() async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/api/dashboard/admin/analytics/',
    );
    return AdminAnalytics.fromJson(response.data ?? <String, dynamic>{});
  }

  Future<List<AppUser>> getUsers() async {
    final response = await _dio.get<dynamic>('/api/admin/users/');

    final data = response.data;
    final listData = data is List
        ? data
        : data is Map<String, dynamic> && data['results'] is List
        ? data['results'] as List<dynamic>
        : <dynamic>[];

    return listData
        .whereType<Map<String, dynamic>>()
        .map(AppUser.fromJson)
        .toList();
  }
}
