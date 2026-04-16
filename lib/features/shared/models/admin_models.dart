import 'package:freezed_annotation/freezed_annotation.dart';

part 'admin_models.freezed.dart';
part 'admin_models.g.dart';

@freezed
class SystemOverview with _$SystemOverview {
  const factory SystemOverview({
    @JsonKey(name: 'total_patients') required int totalPatients,
    required int waiting,
    @JsonKey(name: 'in_progress') required int inProgress,
    required int completed,
    @JsonKey(name: 'critical_cases') required int criticalCases,
  }) = _SystemOverview;

  factory SystemOverview.fromJson(Map<String, dynamic> json) =>
      _$SystemOverviewFromJson(json);
}

@freezed
class Analytics with _$Analytics {
  const factory Analytics({
    @JsonKey(name: 'average_wait_minutes') required double averageWaitMinutes,
    @JsonKey(name: 'daily_patients') required int dailyPatients,
    @JsonKey(name: 'resolved_today') required int resolvedToday,
  }) = _Analytics;

  factory Analytics.fromJson(Map<String, dynamic> json) =>
      _$AnalyticsFromJson(json);
}

@freezed
class User with _$User {
  const factory User({
    required int id,
    required String name,
    required String email,
    required String role,
    @JsonKey(name: 'is_active') required bool isActive,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
