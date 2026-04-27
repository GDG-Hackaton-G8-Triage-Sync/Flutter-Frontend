import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_frontend/core/models/api_models.dart';

class CacheService {
  CacheService._();
  static final CacheService instance = CacheService._();

  static const String _boxName = 'triage_cache';
  static const String _patientsKey = 'recent_patients';

  Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox(_boxName);
  }

  Future<void> cachePatients(List<TriageItem> patients) async {
    final box = Hive.box(_boxName);
    final jsonList = patients.map((p) => jsonEncode({
      'id': p.id,
      'description': p.description,
      'priority': p.priority,
      'urgency_score': p.urgencyScore,
      'condition': p.condition,
      'status': p.status,
      'created_at': p.createdAt.toIso8601String(),
      'patient_name': p.patientName,
      'confidence': p.confidence,
      'reasoning': p.reasoning,
    })).toList();
    await box.put(_patientsKey, jsonList);
  }

  List<TriageItem> getCachedPatients() {
    final box = Hive.box(_boxName);
    final List<dynamic>? jsonList = box.get(_patientsKey);
    if (jsonList == null) return [];

    return jsonList.map((j) {
      final map = jsonDecode(j as String) as Map<String, dynamic>;
      return TriageItem.fromJson(map);
    }).toList();
  }
}
