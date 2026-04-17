import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../services/websocket/websocket_manager.dart';
import '../models/websocket_models.dart';

final webSocketManagerProvider = Provider<WebSocketManager>((ref) {
  final manager = WebSocketManager();
  ref.onDispose(manager.dispose);
  return manager;
});

final webSocketMessagesProvider = StreamProvider<Map<String, dynamic>>((ref) {
  final manager = ref.watch(webSocketManagerProvider);
  return manager.messages;
});

final patientUpdatesProvider = StreamProvider<PatientUpdateData>((ref) {
  return ref
      .watch(webSocketManagerProvider)
      .messages
      .where((msg) {
        return msg['type'] == 'patient_update' ||
            msg['type'] == 'triage_update';
      })
      .map(
        (msg) =>
            PatientUpdateData.fromJson(msg['data'] as Map<String, dynamic>),
      );
});
