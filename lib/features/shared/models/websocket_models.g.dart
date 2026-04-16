// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'websocket_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WebSocketMessageImpl _$$WebSocketMessageImplFromJson(
  Map<String, dynamic> json,
) => _$WebSocketMessageImpl(
  type: json['type'] as String,
  data: json['data'] as Map<String, dynamic>?,
);

Map<String, dynamic> _$$WebSocketMessageImplToJson(
  _$WebSocketMessageImpl instance,
) => <String, dynamic>{'type': instance.type, 'data': instance.data};

_$PatientUpdateDataImpl _$$PatientUpdateDataImplFromJson(
  Map<String, dynamic> json,
) => _$PatientUpdateDataImpl(
  id: (json['id'] as num).toInt(),
  status: json['status'] as String,
  priority: (json['priority'] as num).toInt(),
  urgencyScore: (json['urgency_score'] as num).toInt(),
  updatedAt: DateTime.parse(json['updated_at'] as String),
);

Map<String, dynamic> _$$PatientUpdateDataImplToJson(
  _$PatientUpdateDataImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'status': instance.status,
  'priority': instance.priority,
  'urgency_score': instance.urgencyScore,
  'updated_at': instance.updatedAt.toIso8601String(),
};
