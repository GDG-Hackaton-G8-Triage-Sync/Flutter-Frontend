// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'queue_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$QueuePatientImpl _$$QueuePatientImplFromJson(Map<String, dynamic> json) =>
    _$QueuePatientImpl(
      id: json['id'] as int,
      description: json['description'] as String,
      priority: json['priority'] as int,
      urgencyScore: json['urgencyScore'] as int,
      condition: json['condition'] as String,
      status: json['status'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$QueuePatientImplToJson(_$QueuePatientImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'description': instance.description,
      'priority': instance.priority,
      'urgencyScore': instance.urgencyScore,
      'condition': instance.condition,
      'status': instance.status,
      'createdAt': instance.createdAt.toIso8601String(),
    };
