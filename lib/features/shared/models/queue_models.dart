import 'package:freezed_annotation/freezed_annotation.dart';

part 'queue_models.freezed.dart';
part 'queue_models.g.dart';

@freezed
class QueuePatient with _$QueuePatient {
  factory QueuePatient({
    required int id,
    required String description,
    required int priority,
    required int urgencyScore,
    required String condition,
    required String status,
    required DateTime createdAt,
  }) = _QueuePatient;

  factory QueuePatient.fromJson(Map<String, dynamic> json) =>
      _$QueuePatientFromJson(json);
}
