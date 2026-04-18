import 'dart:async';
import 'dart:convert';

import 'package:web_socket_channel/web_socket_channel.dart';

import '../../models/api_models.dart';

/// Manages a persistent WebSocket connection to the mock server (ws://localhost:3002).
/// Emits [TriageItem] events whenever the server broadcasts a queue_update.
class WebSocketManager {
  WebSocketManager._();
  static final WebSocketManager instance = WebSocketManager._();

  static const _wsUrl = 'ws://localhost:3002';
  static const _reconnectDelay = Duration(seconds: 3);

  WebSocketChannel? _channel;
  StreamController<TriageItem>? _controller;
  bool _intentionallyClosed = false;
  Timer? _reconnectTimer;

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
      final Map<String, dynamic> json =
          jsonDecode(raw as String) as Map<String, dynamic>;
      if (json['type'] == 'queue_update') {
        final data = json['data'] as Map<String, dynamic>;
        final item = TriageItem.fromJson(data);
        _controller?.add(item);
      }
    } catch (_) {
      // Ignore malformed messages
    }
  }

  void _onError(Object error) {
    _channel = null;
    if (!_intentionallyClosed) {
      _scheduleReconnect();
    }
  }

  void _onDone() {
    _channel = null;
    if (!_intentionallyClosed) {
      _scheduleReconnect();
    }
  }

  void _scheduleReconnect() {
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
    _channel?.sink.close();
    _channel = null;
  }

  /// Dispose the manager (close stream controller). Call on app shutdown.
  void dispose() {
    disconnect();
    _controller?.close();
    _controller = null;
  }
}
