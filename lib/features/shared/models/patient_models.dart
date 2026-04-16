import 'package:freezed_annotation/freezed_annotation.dart';

part 'patient_models.freezed.dart';
part 'patient_models.g.dart';

@freezed
class SymptomSubmission with _$SymptomSubmission {
  const factory SymptomSubmission({required String description}) =
      _SymptomSubmission;

  factory SymptomSubmission.fromJson(Map<String, dynamic> json) =>
      _$SymptomSubmissionFromJson(json);
}

@freezed
class TriageResult with _$TriageResult {
  const factory TriageResult({
    required int id,
    required int priority,
    @JsonKey(name: 'urgency_score') required int urgencyScore,
    required String condition,
    required String status,
    @JsonKey(name: 'created_at') required DateTime createdAt,
  }) = _TriageResult;

  factory TriageResult.fromJson(Map<String, dynamic> json) =>
      _$TriageResultFromJson(json);
}

@freezed
class TimelineStep with _$TimelineStep {
  const factory TimelineStep({
    required DateTime time,
    required String description,
  }) = _TimelineStep;

  factory TimelineStep.fromJson(Map<String, dynamic> json) =>
      _$TimelineStepFromJson(json);
}

@freezed
class PatientJourney with _$PatientJourney {
  const factory PatientJourney({
    @JsonKey(name: 'queue_position') required int queuePosition,
    @JsonKey(name: 'urgency_level') required String urgencyLevel,
    @JsonKey(name: 'estimated_wait_minutes') required int estimatedWaitMinutes,
    required List<TimelineStep> timeline,
  }) = _PatientJourney;

  factory PatientJourney.fromJson(Map<String, dynamic> json) =>
      _$PatientJourneyFromJson(json);
}
