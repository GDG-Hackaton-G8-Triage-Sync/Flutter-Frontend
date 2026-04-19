import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/patient_status_provider.dart';

class PatientStatusScreen extends ConsumerWidget {
  const PatientStatusScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final status = ref.watch(patientStatusProvider);

    String message;
    Color color;
    IconData icon;

    switch (status) {
      case PatientStatus.loading:
        message = "Submitting symptoms...";
        color = Colors.orange;
        icon = Icons.hourglass_bottom;
        break;

      case PatientStatus.processing:
        message = "Doctor is reviewing...";
        color = Colors.blue;
        icon = Icons.medical_services;
        break;

      case PatientStatus.completed:
        message = "Diagnosis completed!";
        color = Colors.green;
        icon = Icons.check_circle;
        break;

      case PatientStatus.failed:
        message = "Submission failed!";
        color = Colors.red;
        icon = Icons.error;
        break;

      default:
        message = "Waiting for submission...";
        color = Colors.grey;
        icon = Icons.info;
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Patient Status")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Queue Position: #3",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 10),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                "HIGH URGENCY",
                style: TextStyle(color: Colors.white),
              ),
            ),

            const SizedBox(height: 20),

            Icon(icon, size: 90, color: color),

            const SizedBox(height: 20),

            Text(
              message,
              style: TextStyle(fontSize: 20, color: color),
            ),

            const SizedBox(height: 30),

            const Column(
              children: [
                Text("📌 Submitted", style: TextStyle(color: Colors.green)),
                SizedBox(height: 5),
                Text("⏳ Processing", style: TextStyle(color: Colors.orange)),
                SizedBox(height: 5),
                Text("⏳ Awaiting Doctor Review"),
              ],
            ),
          ],
        ),
      ),
    );
  }
}