// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'queue_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$QueuePatientImpl _$$QueuePatientImplFromJson(Map<String, dynamic> json) =>
    _$QueuePatientImpl(
      id: (json['id'] as num).toInt(),
      description: json['description'] as String,
      priority: (json['priority'] as num).toInt(),
      urgencyScore: (json['urgency_score'] as num).toInt(),
      condition: json['condition'] as String,
      status: json['status'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$$QueuePatientImplToJson(_$QueuePatientImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'description': instance.description,
      'priority': instance.priority,
      'urgency_score': instance.urgencyScore,
      'condition': instance.condition,
      'status': instance.status,
      'created_at': instance.createdAt.toIso8601String(),
    };

_$StatusUpdateRequestImpl _$$StatusUpdateRequestImplFromJson(
  Map<String, dynamic> json,
) => _$StatusUpdateRequestImpl(
  status: json['status'] as String,
  notes: json['notes'] as String?,
);

Map<String, dynamic> _$$StatusUpdateRequestImplToJson(
  _$StatusUpdateRequestImpl instance,
) => <String, dynamic>{'status': instance.status, 'notes': instance.notes};
