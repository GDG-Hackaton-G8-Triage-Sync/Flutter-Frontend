import 'package:flutter_frontend/services/websocket_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_frontend/services/api/endpoints/staff_api.dart';
import '../../shared/models/queue_models.dart';

final staffApiProvider = Provider((ref) => StaffApi());

final queueProvider = StateNotifierProvider<QueueNotifier, List<QueuePatient>>(
  (ref) => QueueNotifier(ref.read(staffApiProvider)),
);

class QueueNotifier extends StateNotifier<List<QueuePatient>> {
  final StaffApi api;

  QueueNotifier(this.api) : super([]) {
    fetchQueue();
  }
  void connectSocket(String token) {
  final socket = SocketService();

  socket.connect(token, (event) {
    final type = event['type'];
    final data = event['data'];

    if (type == 'TRIAGE_CREATED') {
      addPatient(QueuePatient.fromJson(data));
    }

    if (type == 'TRIAGE_UPDATED') {
      updatePatient(QueuePatient.fromJson(data));
    }
  });
}

  Future<void> fetchQueue() async {
    try {
      final data = await api.getQueue();
      state = data;
    } catch (e) {
      print("Error fetching queue: $e");
    }
  }

  void updatePatient(QueuePatient updated) {
    state = [
      for (final p in state)
        if (p.id == updated.id) updated else p
    ];
  }

  void addPatient(QueuePatient newPatient) {
    state = [newPatient, ...state];
  }
}