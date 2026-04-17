// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SystemOverviewImpl _$$SystemOverviewImplFromJson(Map<String, dynamic> json) =>
    _$SystemOverviewImpl(
      totalPatients: json['totalPatients'] as int,
      waiting: json['waiting'] as int,
      inProgress: json['inProgress'] as int,
      completed: json['completed'] as int,
      criticalCases: json['criticalCases'] as int,
    );

Map<String, dynamic> _$$SystemOverviewImplToJson(
  _$SystemOverviewImpl instance,
) => <String, dynamic>{
  'totalPatients': instance.totalPatients,
  'waiting': instance.waiting,
  'inProgress': instance.inProgress,
  'completed': instance.completed,
  'criticalCases': instance.criticalCases,
};
