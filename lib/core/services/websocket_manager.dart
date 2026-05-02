import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'package:flutter_frontend/core/config/api_config.dart';
import 'package:flutter_frontend/core/models/api_models.dart';
import 'package:flutter_frontend/core/services/session_service.dart';

/// Manages a persistent WebSocket connection to the updates gateway.
/// Emits [TriageItem] events whenever the server broadcasts a triage event.
class WebSocketManager {
  WebSocketManager._();
  static final WebSocketManager instance = WebSocketManager._();

  static const _reconnectDelay = Duration(seconds: 3);
  static const _heartbeatInterval = Duration(seconds: 20);

  WebSocketChannel? _channel;
  StreamController<TriageItem>? _controller;
  bool _intentionallyClosed = false;
  Timer? _reconnectTimer;
  Timer? _heartbeatTimer;

  /// Stream of incoming [TriageItem] updates from the server.
  Stream<TriageItem> get updates {
    _controller ??= StreamController<TriageItem>.broadcast();
    return _controller!.stream;
  }

  /// Connect to the WebSocket server. Safe to call multiple times.
  void connect() {
    if (_channel != null) return; // already connected
    _intentionallyClosed = false;
    _doConnect();
  }

  Future<void> _doConnect() async {
    try {
      final token = await SessionService().getAccessToken();
      if (token == null || token.isEmpty) {
        throw StateError('Missing access token for WebSocket connection');
      }

      final uri = ApiConfig.websocketUri(token: token);
      _channel = WebSocketChannel.connect(uri);

      // Wait for the handshake to complete with a timeout.
      // This prevents blocking the event loop if the server is unreachable.
      try {
        await _channel!.ready.timeout(
          const Duration(seconds: 5),
          onTimeout: () => throw TimeoutException('WebSocket handshake timed out'),
        );
      } on Exception catch (e) {
        debugPrint('WebSocket handshake failed: $e — will retry');
        _channel?.sink.close();
        _channel = null;
        _scheduleReconnect();
        return;
      }

      _startHeartbeat();

      _channel!.stream.listen(
        _onMessage,
        onError: _onError,
        onDone: _onDone,
        cancelOnError: false,
      );
    } catch (e) {
      debugPrint('WebSocket connect error: $e');
      _scheduleReconnect();
    }
  }

  void _onMessage(dynamic raw) {
    try {
      if (raw is! String) {
        return;
      }

      final Map<String, dynamic> json = jsonDecode(raw) as Map<String, dynamic>;

      final type = (json['type'] ?? json['event_type'] ?? '').toString().toLowerCase();
      if (type == 'triage_created' ||
          type == 'patient_created' ||
          type == 'triage_updated' ||
          type == 'status_changed' ||
          type == 'priority_update' ||
          type == 'critical_alert' ||
          type == 'sla_breach') {
        final data = json['data'] is Map<String, dynamic>
            ? (json['data']['triage_item'] ?? json['data']) as Map<String, dynamic>
            : (json['triage_item'] ?? json);
        final item = TriageItem.fromJson(data as Map<String, dynamic>);
        _controller?.add(item);
      }
    } catch (_) {
      // Ignore malformed messages
    }
  }

  void _onError(Object error) {
    _stopHeartbeat();
    _channel = null;
    if (!_intentionallyClosed) {
      _scheduleReconnect();
    }
  }

  void _onDone() {
    _stopHeartbeat();
    _channel = null;
    if (!_intentionallyClosed) {
      _scheduleReconnect();
    }
  }

  void _scheduleReconnect() {
    _stopHeartbeat();
    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(_reconnectDelay, () {
      if (!_intentionallyClosed) {
        _doConnect();
      }
    });
  }

  /// Disconnect from the WebSocket server.
  void disconnect() {
    _intentionallyClosed = true;
    _reconnectTimer?.cancel();
    _stopHeartbeat();
    _channel?.sink.close();
    _channel = null;
  }

  void _startHeartbeat() {
    _stopHeartbeat();
    _heartbeatTimer = Timer.periodic(_heartbeatInterval, (_) {
      try {
        _channel?.sink.add('{"type":"PING"}');
      } catch (_) {
        _stopHeartbeat();
      }
    });
  }

  void _stopHeartbeat() {
    _heartbeatTimer?.cancel();
    _heartbeatTimer = null;
  }

  /// Dispose the manager (close stream controller). Call on app shutdown.
  void dispose() {
    disconnect();
    _controller?.close();
    _controller = null;
  }
}
