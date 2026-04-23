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
      name: json['patient_name'] as String?,
      gender: json['gender'] as String?,
      age: (json['age'] as num?)?.toInt(),
      bloodType: json['blood_type'] as String?,
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
      'patient_name': instance.name,
      'gender': instance.gender,
      'age': instance.age,
      'blood_type': instance.bloodType,
    };
