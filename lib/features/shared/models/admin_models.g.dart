// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SystemOverviewImpl _$$SystemOverviewImplFromJson(Map<String, dynamic> json) =>
    _$SystemOverviewImpl(
      totalPatients: (json['total_patients'] as num).toInt(),
      waiting: (json['waiting'] as num).toInt(),
      inProgress: (json['in_progress'] as num).toInt(),
      completed: (json['completed'] as num).toInt(),
      criticalCases: (json['critical_cases'] as num).toInt(),
    );

Map<String, dynamic> _$$SystemOverviewImplToJson(
  _$SystemOverviewImpl instance,
) => <String, dynamic>{
  'total_patients': instance.totalPatients,
  'waiting': instance.waiting,
  'in_progress': instance.inProgress,
  'completed': instance.completed,
  'critical_cases': instance.criticalCases,
};

_$AnalyticsImpl _$$AnalyticsImplFromJson(Map<String, dynamic> json) =>
    _$AnalyticsImpl(
      averageWaitMinutes: (json['average_wait_minutes'] as num).toDouble(),
      dailyPatients: (json['daily_patients'] as num).toInt(),
      resolvedToday: (json['resolved_today'] as num).toInt(),
    );

Map<String, dynamic> _$$AnalyticsImplToJson(_$AnalyticsImpl instance) =>
    <String, dynamic>{
      'average_wait_minutes': instance.averageWaitMinutes,
      'daily_patients': instance.dailyPatients,
      'resolved_today': instance.resolvedToday,
    };

_$UserImpl _$$UserImplFromJson(Map<String, dynamic> json) => _$UserImpl(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  email: json['email'] as String,
  role: json['role'] as String,
  isActive: json['is_active'] as bool,
);

Map<String, dynamic> _$$UserImplToJson(_$UserImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'role': instance.role,
      'is_active': instance.isActive,
    };
