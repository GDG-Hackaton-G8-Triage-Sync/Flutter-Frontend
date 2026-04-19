import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:patient_app/features/patient/symptom_input/symptom_input_screen.dart';

void main() {
  testWidgets('Symptom input screen loads correctly', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: SymptomInputScreen(),
      ),
    );

    expect(find.text("Describe Symptoms"), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget);
    expect(find.text("Submit"), findsOneWidget);
  });
}