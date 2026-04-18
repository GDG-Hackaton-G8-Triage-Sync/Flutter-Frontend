import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';

import 'package:web_socket_channel/web_socket_channel.dart';

import '../../models/api_models.dart';

/// Manages a persistent WebSocket connection to the mock server (ws://localhost:3002).
/// Emits [TriageItem] events whenever the server broadcasts a queue_update.
class WebSocketManager {
  WebSocketManager._();
  static final WebSocketManager instance = WebSocketManager._();

  static String get _wsUrl {
    const envUrl = String.fromEnvironment('WS_URL', defaultValue: '');
    if (envUrl.isNotEmpty) {
      return envUrl;
    }
    if (kIsWeb) {
      return 'ws://localhost:3002';
    }
    if (Platform.isAndroid) {
      return 'ws://10.0.2.2:3002';
    }
    return 'ws://localhost:3002';
  }

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

  void _doConnect() {
    try {
      _channel = WebSocketChannel.connect(Uri.parse(_wsUrl));
      _startHeartbeat();

      _channel!.stream.listen(
        _onMessage,
        onError: _onError,
        onDone: _onDone,
        cancelOnError: false,
      );
    } catch (e) {
      _scheduleReconnect();
    }
  }

  void _onMessage(dynamic raw) {
    try {
      if (raw is! String) {
        return;
      }

      final Map<String, dynamic> json = jsonDecode(raw) as Map<String, dynamic>;

      final type = json['type'];
      if (type == 'queue_update' ||
          type == 'status_update' ||
          type == 'patient_created' ||
          type == 'priority_override') {
        final data = json['data'] as Map<String, dynamic>;
        final item = TriageItem.fromJson(data);
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
        _channel?.sink.add('{"type":"ping"}');
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
