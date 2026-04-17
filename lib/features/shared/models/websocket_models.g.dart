// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'websocket_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PatientUpdateDataImpl _$$PatientUpdateDataImplFromJson(
  Map<String, dynamic> json,
) => _$PatientUpdateDataImpl(
  id: json['id'] as int,
  status: json['status'] as String,
  priority: json['priority'] as int,
);

Map<String, dynamic> _$$PatientUpdateDataImplToJson(
  _$PatientUpdateDataImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'status': instance.status,
  'priority': instance.priority,
};
