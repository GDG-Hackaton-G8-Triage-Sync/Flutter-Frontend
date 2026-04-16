import 'package:freezed_annotation/freezed_annotation.dart';

part 'queue_models.freezed.dart';
part 'queue_models.g.dart';

@freezed
class QueuePatient with _$QueuePatient {
  const factory QueuePatient({
    required int id,
    required String description,
    required int priority,
    @JsonKey(name: 'urgency_score') required int urgencyScore,
    required String condition,
    required String status,
    @JsonKey(name: 'created_at') required DateTime createdAt,
  }) = _QueuePatient;

  factory QueuePatient.fromJson(Map<String, dynamic> json) =>
      _$QueuePatientFromJson(json);
}

@freezed
class StatusUpdateRequest with _$StatusUpdateRequest {
  const factory StatusUpdateRequest({required String status, String? notes}) =
      _StatusUpdateRequest;

  factory StatusUpdateRequest.fromJson(Map<String, dynamic> json) =>
      _$StatusUpdateRequestFromJson(json);
}
