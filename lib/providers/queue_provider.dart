import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../features/shared/models/queue_models.dart';

final queueProvider = Provider<List<QueuePatient>>((ref) {
  return [
    QueuePatient(
      id: 1,
      description: "Chest Pain",
      priority: 1,
      urgencyScore: 90,
      condition: "Critical",
      status: "Waiting",
      createdAt: DateTime.now(),
    ),
    QueuePatient(
      id: 2,
      description: "Headache",
      priority: 3,
      urgencyScore: 40,
      condition: "Stable",
      status: "Waiting",
      createdAt: DateTime.now(),
    ),
  ];
});