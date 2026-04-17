import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'queue_filter_dashboard.dart';

final queueProvider = Provider<List<Map<String, dynamic>>>((ref) {
  final filter = ref.watch(queueFilterProvider);

  final patients = [
    {
      "name": "John Doe",
      "symptom": "Chest Pain • Age 54",
      "urgency": "Critical",
      "time": "5 min"
    },
    {
      "name": "Sarah Smith",
      "symptom": "Headache • Age 29",
      "urgency": "High",
      "time": "10 min"
    },
    {
      "name": "Michael Brown",
      "symptom": "Fever • Age 40",
      "urgency": "Medium",
      "time": "15 min"
    }
  ];

  if (filter == "All") return patients;

  return patients
      .where((p) => p["urgency"] == filter)
      .toList();
});