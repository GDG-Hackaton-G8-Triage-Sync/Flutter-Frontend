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
      accessToken: (json['access_token'] ?? '') as String,
      refreshToken: (json['refresh_token'] ?? '') as String,
      role: (json['role'] ?? 'patient') as String,
      userId: (json['user_id'] ?? 0) as int,
      name: (json['name'] ?? '') as String,
      email: (json['email'] ?? '') as String,
      gender: json['gender'] as String?,
      age: json['age'] as int?,
      bloodType: json['blood_type'] as String?,
      healthHistory: json['health_history'] as String?,
      allergies: json['allergies'] as String?,
      currentMedications: json['current_medications'] as String?,
      badHabits: json['bad_habits'] as String?,
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
      bp: (json['bp'] ?? '') as String,
      heartRate: (json['heart_rate'] ?? '') as String,
      temperature: (json['temperature'] ?? '') as String,
      recordedAt:
          DateTime.tryParse((json['recorded_at'] ?? '') as String) ??
          DateTime.now(),
      recordedBy: (json['recorded_by'] ?? '') as String,
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
    return TriageItem(
      id: (json['id'] ?? 0) as int,
      description: (json['description'] ?? '') as String,
      priority: (json['priority'] ?? 5) as int,
      urgencyScore: (json['urgency_score'] ?? 0) as int,
      condition: (json['condition'] ?? 'Unknown') as String,
      status: (json['status'] ?? 'waiting') as String,
      createdAt:
          DateTime.tryParse((json['created_at'] ?? '') as String) ??
          DateTime.now(),
      patientName: json['patient_name'] as String?,
      photoName: json['photo_name'] as String?,
      verifiedBy: json['verified_by'] as String?,
      verifiedAt: json['verified_at'] != null
          ? DateTime.tryParse(json['verified_at'] as String)
          : null,
      gender: json['gender'] as String?,
      age: json['age'] as int?,
      bloodType: json['blood_type'] as String?,
      healthHistory: json['health_history'] as String?,
      allergies: json['allergies'] as String?,
      currentMedications: json['current_medications'] as String?,
      badHabits: json['bad_habits'] as String?,
      reasoning: json['reasoning'] as String?,
      confidence: (json['confidence'] as num?)?.toDouble(),
      vitals: json['vitals'] != null
          ? Vitals.fromJson(json['vitals'] as Map<String, dynamic>)
          : null,
      startedAt: json['started_at'] != null
          ? DateTime.tryParse(json['started_at'] as String)
          : null,
      completedAt: json['completed_at'] != null
          ? DateTime.tryParse(json['completed_at'] as String)
          : null,
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
      totalPatients: (json['total_patients'] ?? 0) as int,
      waiting: (json['waiting'] ?? 0) as int,
      inProgress: (json['in_progress'] ?? 0) as int,
      completed: (json['completed'] ?? 0) as int,
      criticalCases: (json['critical_cases'] ?? 0) as int,
    );
  }
}

class TrendPoint {
  TrendPoint({required this.time, required this.value});
  final String time;
  final double value;

  factory TrendPoint.fromJson(Map<String, dynamic> json) {
    return TrendPoint(
      time: (json['time'] ?? '') as String,
      value: (json['value'] ?? 0.0).toDouble(),
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
    final conditionsRaw =
        (json['common_conditions'] ?? <dynamic>[]) as List<dynamic>;
    final waitTrendRaw =
        (json['wait_time_trend'] ?? <dynamic>[]) as List<dynamic>;
    final slaTrendRaw =
        (json['sla_breach_trend'] ?? <dynamic>[]) as List<dynamic>;

    return AdminAnalytics(
      avgUrgencyScore: (json['avg_urgency_score'] ?? 0) as int,
      peakHour: (json['peak_hour'] ?? '-') as String,
      commonConditions: conditionsRaw.map((e) => e.toString()).toList(),
      waitTimeTrend: waitTrendRaw
          .map((e) => TrendPoint.fromJson(e as Map<String, dynamic>))
          .toList(),
      slaBreachTrend: slaTrendRaw
          .map((e) => TrendPoint.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
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
      id: (json['id'] ?? 0) as int,
      name: (json['name'] ?? '') as String,
      email: (json['email'] ?? '') as String,
      role: (json['role'] ?? 'patient') as String,
      gender: json['gender'] as String?,
      age: json['age'] as int?,
      bloodType: json['blood_type'] as String?,
      healthHistory: json['health_history'] as String?,
      allergies: json['allergies'] as String?,
      currentMedications: json['current_medications'] as String?,
      badHabits: json['bad_habits'] as String?,
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
      position: (json['position'] ?? 0) as int,
      totalWaiting: (json['total_waiting'] ?? 0) as int,
      estimatedWaitMins: (json['estimated_wait_mins'] ?? 0) as int,
      aiConfidence: (json['ai_confidence'] as num? ?? 0.0).toDouble(),
      message: (json['message'] ?? '') as String,
    );
  }
}
