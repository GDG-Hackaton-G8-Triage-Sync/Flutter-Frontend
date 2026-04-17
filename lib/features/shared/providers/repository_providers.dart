import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/patient_models.dart';
import '../models/queue_models.dart';
import '../models/admin_models.dart';

// Stub for symptom submission
final triageRepositoryProvider = FutureProvider.family<TriageResult, String>((
  ref,
  description,
) async {
  await Future.delayed(const Duration(seconds: 1));
  return TriageResult(
    id: 999,
    priority: 3,
    urgencyScore: 65,
    condition: "Sample Condition",
    status: "processed",
    createdAt: DateTime.now(),
  );
});

// Stub for patient status
final patientStatusProvider = FutureProvider<PatientJourney>((ref) async {
  await Future.delayed(const Duration(milliseconds: 500));
  return PatientJourney(
    queuePosition: 5,
    urgencyLevel: "Medium",
    estimatedWaitMinutes: 45,
    timeline: [
      TimelineStep(
        time: DateTime.now().subtract(const Duration(minutes: 10)),
        description: "Symptoms submitted",
      ),
      TimelineStep(time: DateTime.now(), description: "AI triage completed"),
    ],
  );
});

// Stub for staff queue
final staffQueueProvider = FutureProvider<List<QueuePatient>>((ref) async {
  await Future.delayed(const Duration(milliseconds: 500));
  return [
    QueuePatient(
      id: 1,
      description: "Chest pain",
      priority: 1,
      urgencyScore: 95,
      condition: "Cardiac Event",
      status: "waiting",
      createdAt: DateTime.now(),
    ),
    QueuePatient(
      id: 2,
      description: "Headache",
      priority: 3,
      urgencyScore: 60,
      condition: "Migraine",
      status: "waiting",
      createdAt: DateTime.now(),
    ),
  ];
});

// Stub for admin overview
final adminOverviewProvider = FutureProvider<SystemOverview>((ref) async {
  await Future.delayed(const Duration(milliseconds: 500));
  return SystemOverview(
    totalPatients: 42,
    waiting: 15,
    inProgress: 20,
    completed: 7,
    criticalCases: 3,
  );
});
