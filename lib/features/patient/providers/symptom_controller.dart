import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'patient_status_provider.dart';

class SymptomController extends StateNotifier<void> {
  SymptomController(this.ref) : super(null);

  final Ref ref;

  Future<String> submitSymptoms(String text) async {
    ref.read(patientStatusProvider.notifier).setLoading();

    try {
      await Future.delayed(const Duration(seconds: 2));

      ref.read(patientStatusProvider.notifier).setProcessing();

      await Future.delayed(const Duration(seconds: 2));

      ref.read(patientStatusProvider.notifier).setCompleted();

      return "PATIENT_${DateTime.now().millisecondsSinceEpoch}";
    } catch (e) {
      ref.read(patientStatusProvider.notifier).setFailed();
      rethrow;
    }
  }
}

final symptomControllerProvider =
    StateNotifierProvider<SymptomController, void>(
  (ref) => SymptomController(ref),
);