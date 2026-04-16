// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'patient_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SymptomSubmissionImpl _$$SymptomSubmissionImplFromJson(
  Map<String, dynamic> json,
) => _$SymptomSubmissionImpl(description: json['description'] as String);

Map<String, dynamic> _$$SymptomSubmissionImplToJson(
  _$SymptomSubmissionImpl instance,
) => <String, dynamic>{'description': instance.description};

_$TriageResultImpl _$$TriageResultImplFromJson(Map<String, dynamic> json) =>
    _$TriageResultImpl(
      id: (json['id'] as num).toInt(),
      priority: (json['priority'] as num).toInt(),
      urgencyScore: (json['urgency_score'] as num).toInt(),
      condition: json['condition'] as String,
      status: json['status'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$$TriageResultImplToJson(_$TriageResultImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'priority': instance.priority,
      'urgency_score': instance.urgencyScore,
      'condition': instance.condition,
      'status': instance.status,
      'created_at': instance.createdAt.toIso8601String(),
    };

_$TimelineStepImpl _$$TimelineStepImplFromJson(Map<String, dynamic> json) =>
    _$TimelineStepImpl(
      time: DateTime.parse(json['time'] as String),
      description: json['description'] as String,
    );

Map<String, dynamic> _$$TimelineStepImplToJson(_$TimelineStepImpl instance) =>
    <String, dynamic>{
      'time': instance.time.toIso8601String(),
      'description': instance.description,
    };

_$PatientJourneyImpl _$$PatientJourneyImplFromJson(Map<String, dynamic> json) =>
    _$PatientJourneyImpl(
      queuePosition: (json['queue_position'] as num).toInt(),
      urgencyLevel: json['urgency_level'] as String,
      estimatedWaitMinutes: (json['estimated_wait_minutes'] as num).toInt(),
      timeline: (json['timeline'] as List<dynamic>)
          .map((e) => TimelineStep.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$PatientJourneyImplToJson(
  _$PatientJourneyImpl instance,
) => <String, dynamic>{
  'queue_position': instance.queuePosition,
  'urgency_level': instance.urgencyLevel,
  'estimated_wait_minutes': instance.estimatedWaitMinutes,
  'timeline': instance.timeline.map((e) => e.toJson()).toList(),
};
