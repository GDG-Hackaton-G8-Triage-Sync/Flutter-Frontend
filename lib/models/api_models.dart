class AuthResponse {
  AuthResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.role,
    required this.userId,
    required this.name,
    required this.email,
  });

  final String accessToken;
  final String refreshToken;
  final String role;
  final int userId;
  final String name;
  final String email;

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      accessToken: (json['access_token'] ?? '') as String,
      refreshToken: (json['refresh_token'] ?? '') as String,
      role: (json['role'] ?? 'patient') as String,
      userId: (json['user_id'] ?? 0) as int,
      name: (json['name'] ?? '') as String,
      email: (json['email'] ?? '') as String,
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
    this.photoName,
  });

  final int id;
  final String description;
  final int priority;
  final int urgencyScore;
  final String condition;
  final String status;
  final DateTime createdAt;
  final String? photoName;

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
      photoName: json['photo_name'] as String?,
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

class AdminAnalytics {
  AdminAnalytics({
    required this.avgUrgencyScore,
    required this.peakHour,
    required this.commonConditions,
  });

  final int avgUrgencyScore;
  final String peakHour;
  final List<String> commonConditions;

  factory AdminAnalytics.fromJson(Map<String, dynamic> json) {
    final conditionsRaw =
        (json['common_conditions'] ?? <dynamic>[]) as List<dynamic>;
    return AdminAnalytics(
      avgUrgencyScore: (json['avg_urgency_score'] ?? 0) as int,
      peakHour: (json['peak_hour'] ?? '-') as String,
      commonConditions: conditionsRaw.map((e) => e.toString()).toList(),
    );
  }
}

class AppUser {
  AppUser({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
  });

  final int id;
  final String name;
  final String email;
  final String role;

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      id: (json['id'] ?? 0) as int,
      name: (json['name'] ?? '') as String,
      email: (json['email'] ?? '') as String,
      role: (json['role'] ?? 'patient') as String,
    );
  }
}
