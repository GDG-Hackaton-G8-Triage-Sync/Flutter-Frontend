import 'package:flutter_riverpod/flutter_riverpod.dart';

enum PatientStatus {
  idle,
  loading,
  processing,
  completed,
  failed,
}

class PatientStatusNotifier extends StateNotifier<PatientStatus> {
  PatientStatusNotifier() : super(PatientStatus.idle);

  void setLoading() => state = PatientStatus.loading;

  void setProcessing() => state = PatientStatus.processing;

  void setCompleted() => state = PatientStatus.completed;

  void setFailed() => state = PatientStatus.failed;

  void reset() => state = PatientStatus.idle;
}

final patientStatusProvider =
    StateNotifierProvider<PatientStatusNotifier, PatientStatus>(
  (ref) => PatientStatusNotifier(),
);