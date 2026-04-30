int _readInt(Map<String, dynamic> json, List<String> keys, [int fallback = 0]) {
  for (final key in keys) {
    final value = json[key];
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) {
      final parsed = int.tryParse(value);
      if (parsed != null) return parsed;
    }
  }
  return fallback;
}

double _readDouble(
  Map<String, dynamic> json,
  List<String> keys, [
  double fallback = 0.0,
]) {
  for (final key in keys) {
    final value = json[key];
    if (value is num) return value.toDouble();
    if (value is String) {
      final parsed = double.tryParse(value);
      if (parsed != null) return parsed;
    }
  }
  return fallback;
}

String _readString(
  Map<String, dynamic> json,
  List<String> keys, [
  String fallback = '',
]) {
  for (final key in keys) {
    final value = json[key];
    if (value == null) continue;
    final text = value.toString();
    if (text.isNotEmpty) return text;
  }
  return fallback;
}

String? _readNullableString(Map<String, dynamic> json, List<String> keys) {
  for (final key in keys) {
    final value = json[key];
    if (value == null) continue;
    final text = value.toString();
    if (text.isNotEmpty) return text;
  }
  return null;
}

DateTime? _readDateTime(Map<String, dynamic> json, List<String> keys) {
  for (final key in keys) {
    final value = json[key];
    if (value is DateTime) return value;
    if (value is String && value.isNotEmpty) {
      final parsed = DateTime.tryParse(value);
      if (parsed != null) return parsed;
    }
  }
  return null;
}

class AuthResponse {
  AuthResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.role,
    required this.userId,
    required this.name,
    required this.email,
    this.gender,
    this.age,
    this.bloodType,
    this.healthHistory,
    this.allergies,
    this.currentMedications,
    this.badHabits,
  });

  final String accessToken;
  final String refreshToken;
  final String role;
  final int userId;
  final String name;
  final String email;
  final String? gender;
  final int? age;
  final String? bloodType;
  final String? healthHistory;
  final String? allergies;
  final String? currentMedications;
  final String? badHabits;

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      accessToken: _readString(json, <String>['access_token', 'access']),
      refreshToken: _readString(json, <String>['refresh_token', 'refresh']),
      role: _readString(json, <String>['role'], 'patient'),
      userId: _readInt(json, <String>['user_id', 'id']),
      name: _readString(json, <String>['name', 'username']),
      email: _readString(json, <String>['email']),
      gender: _readNullableString(json, <String>['gender']),
      age: json.containsKey('age') ? _readInt(json, <String>['age']) : null,
      bloodType: _readNullableString(json, <String>['blood_type']),
      healthHistory: _readNullableString(json, <String>['health_history']),
      allergies: _readNullableString(json, <String>['allergies']),
      currentMedications: _readNullableString(
        json,
        <String>['current_medications'],
      ),
      badHabits: _readNullableString(json, <String>['bad_habits']),
    );
  }
}

class Vitals {
  Vitals({
    required this.bp,
    required this.heartRate,
    required this.temperature,
    required this.recordedAt,
    required this.recordedBy,
  });

  final String bp;
  final String heartRate;
  final String temperature;
  final DateTime recordedAt;
  final String recordedBy;

  factory Vitals.fromJson(Map<String, dynamic> json) {
    return Vitals(
      bp: _readString(json, <String>['bp']),
      heartRate: _readString(json, <String>['heart_rate']),
      temperature: _readString(json, <String>['temperature']),
      recordedAt:
          _readDateTime(json, <String>['recorded_at']) ?? DateTime.now(),
      recordedBy: _readString(json, <String>['recorded_by']),
    );
  }
}

class TriageItem {
  TriageItem({
    required this.id,
    required this.description,
    required this.priority,
    required this.urgencyScore,
    required this.condition,
    required this.status,
    required this.createdAt,
    this.patientName,
    this.photoName,
    this.verifiedBy,
    this.verifiedAt,
    this.gender,
    this.age,
    this.bloodType,
    this.healthHistory,
    this.allergies,
    this.currentMedications,
    this.badHabits,
    this.reasoning,
    this.confidence,
    this.vitals,
    this.startedAt,
    this.completedAt,
  });

  final int id;
  final String description;
  final int priority;
  final int urgencyScore;
  final String condition;
  final String status;
  final DateTime createdAt;
  final String? patientName;
  final String? photoName;
  final String? verifiedBy;
  final DateTime? verifiedAt;
  final String? gender;
  final int? age;
  final String? bloodType;
  final String? healthHistory;
  final String? allergies;
  final String? currentMedications;
  final String? badHabits;
  final String? reasoning;
  final double? confidence;
  final Vitals? vitals;
  final DateTime? startedAt;
  final DateTime? completedAt;

  factory TriageItem.fromJson(Map<String, dynamic> json) {
    final vitals = json['vitals'];

    return TriageItem(
      id: _readInt(json, <String>['id', 'submission_id', 'patient_id']),
      description: _readString(json, <String>['description', 'symptoms']),
      priority: _readInt(json, <String>['priority'], 5),
      urgencyScore: _readInt(json, <String>['urgency_score']),
      condition: _readString(json, <String>['condition'], 'Unknown'),
      status: _readString(json, <String>['status', 'new_status'], 'waiting'),
      createdAt:
          _readDateTime(json, <String>['created_at', 'timestamp']) ??
          DateTime.now(),
      patientName: _readNullableString(json, <String>['patient_name', 'name']),
      photoName: _readNullableString(json, <String>['photo_name']),
      verifiedBy: _readNullableString(
        json,
        <String>['verified_by', 'verified_by_user'],
      ),
      verifiedAt: _readDateTime(json, <String>['verified_at']),
      gender: _readNullableString(json, <String>['gender']),
      age: json.containsKey('age') ? _readInt(json, <String>['age']) : null,
      bloodType: _readNullableString(json, <String>['blood_type']),
      healthHistory: _readNullableString(json, <String>['health_history']),
      allergies: _readNullableString(json, <String>['allergies']),
      currentMedications: _readNullableString(
        json,
        <String>['current_medications'],
      ),
      badHabits: _readNullableString(json, <String>['bad_habits']),
      reasoning: _readNullableString(json, <String>['reasoning', 'reason']),
      confidence: json.containsKey('confidence')
          ? _readDouble(json, <String>['confidence'])
          : null,
      vitals: vitals is Map<String, dynamic> ? Vitals.fromJson(vitals) : null,
      startedAt: _readDateTime(json, <String>['started_at']),
      completedAt: _readDateTime(
        json,
        <String>['completed_at', 'processed_at'],
      ),
    );
  }
}

class AdminOverview {
  AdminOverview({
    required this.totalPatients,
    required this.waiting,
    required this.inProgress,
    required this.completed,
    required this.criticalCases,
  });

  final int totalPatients;
  final int waiting;
  final int inProgress;
  final int completed;
  final int criticalCases;

  factory AdminOverview.fromJson(Map<String, dynamic> json) {
    return AdminOverview(
      totalPatients: _readInt(json, <String>['total_patients']),
      waiting: _readInt(json, <String>['waiting', 'waiting_patients']),
      inProgress: _readInt(
        json,
        <String>['in_progress', 'in_progress_patients'],
      ),
      completed: _readInt(json, <String>['completed', 'completed_today']),
      criticalCases: _readInt(json, <String>['critical_cases']),
    );
  }
}

class TrendPoint {
  TrendPoint({required this.time, required this.value});
  final String time;
  final double value;

  factory TrendPoint.fromJson(Map<String, dynamic> json) {
    return TrendPoint(
      time: _readString(json, <String>['time', 'date']),
      value: _readDouble(json, <String>['value', 'count']),
    );
  }
}

class AdminAnalytics {
  AdminAnalytics({
    required this.avgUrgencyScore,
    required this.peakHour,
    required this.commonConditions,
    required this.waitTimeTrend,
    required this.slaBreachTrend,
  });

  final int avgUrgencyScore;
  final String peakHour;
  final List<String> commonConditions;
  final List<TrendPoint> waitTimeTrend;
  final List<TrendPoint> slaBreachTrend;

  factory AdminAnalytics.fromJson(Map<String, dynamic> json) {
    return AdminAnalytics(
      avgUrgencyScore: _readInt(
        json,
        <String>[
          'avg_urgency_score',
          'average_urgency_score',
          'average_processing_time_minutes',
        ],
      ),
      peakHour: _readString(json, <String>['peak_hour'], '-'),
      commonConditions: _parseConditionList(
        json['common_conditions'],
        json['condition_breakdown'],
      ),
      waitTimeTrend: _parseTrendList(
        json['wait_time_trend'] ?? json['daily_submissions'],
      ),
      slaBreachTrend: _parseTrendList(json['sla_breach_trend']),
    );
  }

  static List<String> _parseConditionList(
    dynamic conditionsRaw,
    dynamic conditionBreakdown,
  ) {
    if (conditionsRaw is List) {
      return conditionsRaw.map((entry) {
        if (entry is Map<String, dynamic>) {
          final condition = _readString(entry, <String>['condition'], 'Unknown');
          final count = _readInt(entry, <String>['count']);
          return count > 0 ? '$condition ($count)' : condition;
        }
        return entry.toString();
      }).toList();
    }

    if (conditionBreakdown is Map) {
      return conditionBreakdown.entries
          .map((entry) => '${entry.key} (${entry.value})')
          .toList();
    }

    return <String>[];
  }

  static List<TrendPoint> _parseTrendList(dynamic raw) {
    if (raw is! List) return <TrendPoint>[];
    return raw
        .whereType<Map<String, dynamic>>()
        .map(TrendPoint.fromJson)
        .toList();
  }
}

class AppUser {
  AppUser({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.gender,
    this.age,
    this.bloodType,
    this.healthHistory,
    this.allergies,
    this.currentMedications,
    this.badHabits,
  });

  final int id;
  final String name;
  final String email;
  final String role;
  final String? gender;
  final int? age;
  final String? bloodType;
  final String? healthHistory;
  final String? allergies;
  final String? currentMedications;
  final String? badHabits;

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      id: _readInt(json, <String>['id']),
      name: _readString(json, <String>['name', 'username']),
      email: _readString(json, <String>['email']),
      role: _readString(json, <String>['role'], 'patient'),
      gender: _readNullableString(json, <String>['gender']),
      age: json.containsKey('age') ? _readInt(json, <String>['age']) : null,
      bloodType: _readNullableString(json, <String>['blood_type']),
      healthHistory: _readNullableString(json, <String>['health_history']),
      allergies: _readNullableString(json, <String>['allergies']),
      currentMedications: _readNullableString(
        json,
        <String>['current_medications'],
      ),
      badHabits: _readNullableString(json, <String>['bad_habits']),
    );
  }
}

class AppNotification {
  AppNotification({
    required this.id,
    required this.type,
    required this.title,
    required this.message,
    required this.isRead,
    required this.createdAt,
    this.metadata = const <String, dynamic>{},
    this.readAt,
  });

  final int id;
  final String type;
  final String title;
  final String message;
  final bool isRead;
  final DateTime createdAt;
  final Map<String, dynamic> metadata;
  final DateTime? readAt;

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    final metadata = json['metadata'];
    return AppNotification(
      id: _readInt(json, <String>['id']),
      type: _readString(json, <String>['notification_type', 'type']),
      title: _readString(json, <String>['title'], 'Notification'),
      message: _readString(json, <String>['message']),
      isRead: json['is_read'] == true,
      createdAt:
          _readDateTime(json, <String>['created_at']) ?? DateTime.now(),
      metadata: metadata is Map<String, dynamic>
          ? metadata
          : const <String, dynamic>{},
      readAt: _readDateTime(json, <String>['read_at']),
    );
  }
}

class WaitingAnalytics {
  final int position;
  final int totalWaiting;
  final int estimatedWaitMins;
  final double aiConfidence;
  final String message;

  WaitingAnalytics({
    required this.position,
    required this.totalWaiting,
    required this.estimatedWaitMins,
    required this.aiConfidence,
    required this.message,
  });

  factory WaitingAnalytics.fromJson(Map<String, dynamic> json) {
    return WaitingAnalytics(
      position: _readInt(json, <String>['position']),
      totalWaiting: _readInt(json, <String>['total_waiting']),
      estimatedWaitMins: _readInt(json, <String>['estimated_wait_mins']),
      aiConfidence: _readDouble(json, <String>['ai_confidence']),
      message: _readString(json, <String>['message']),
    );
  }
}
