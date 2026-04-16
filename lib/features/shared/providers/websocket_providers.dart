import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../services/websocket/websocket_manager.dart';
import '../models/websocket_models.dart';

final webSocketManagerProvider = Provider<WebSocketManager>((ref) {
  final manager = WebSocketManager();
  ref.onDispose(() {
    unawaited(manager.dispose());
  });
  return manager;
});

final webSocketMessagesProvider = StreamProvider<Map<String, dynamic>>((ref) {
  final manager = ref.watch(webSocketManagerProvider);
  unawaited(manager.connect());
  return manager.messages;
});

final patientUpdatesProvider = StreamProvider<PatientUpdateData>((ref) {
  final manager = ref.watch(webSocketManagerProvider);
  unawaited(manager.connect());

  return manager.messages
      .where(
        (msg) =>
            msg['type'] == 'patient_update' || msg['type'] == 'triage_update',
      )
      .map((msg) {
        final data = msg['data'];
        if (data is Map<String, dynamic>) {
          return PatientUpdateData.fromJson(data);
        }
        throw const FormatException('Invalid websocket patient update payload');
      });
});
