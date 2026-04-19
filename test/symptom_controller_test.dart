import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:patient_app/features/patient/providers/symptom_controller.dart';

void main() {
  test('submitSymptoms returns patient ID', () async {
    final container = ProviderContainer();

    final controller =
        container.read(symptomControllerProvider.notifier);

    final result = await controller.submitSymptoms("fever and headache");

    expect(result.contains("PATIENT_"), true);
  });
}