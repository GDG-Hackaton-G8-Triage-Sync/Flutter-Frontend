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
  StreamController<Map<String, dynamic>>? _eventController;
  bool _intentionallyClosed = false;
  bool _authFailureBlocked = false;
  bool _isConnecting = false;
  Timer? _reconnectTimer;
  Timer? _heartbeatTimer;

  /// Stream of incoming [TriageItem] updates from the server.
  Stream<TriageItem> get updates {
    _controller ??= StreamController<TriageItem>.broadcast();
    return _controller!.stream;
  }

  /// Stream of all incoming JSON WebSocket events.
  Stream<Map<String, dynamic>> get events {
    _eventController ??= StreamController<Map<String, dynamic>>.broadcast();
    return _eventController!.stream;
  }

  /// Connect to the WebSocket server. Safe to call multiple times.
  void connect() {
    _authFailureBlocked = false;
    if (_channel != null || _isConnecting) return;
    _intentionallyClosed = false;
    _doConnect();
  }

  Future<void> _doConnect() async {
    if (_isConnecting || _channel != null || _authFailureBlocked) {
      return;
    }

    _isConnecting = true;
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
        _isConnecting = false;
        return;
      }

      _startHeartbeat();
      _isConnecting = false;

      _channel!.stream.listen(
        _onMessage,
        onError: _onError,
        onDone: _onDone,
        cancelOnError: false,
      );
    } catch (e) {
      debugPrint('WebSocket connect error: $e');
      _isConnecting = false;
      _scheduleReconnect();
    }
  }

  void _onMessage(dynamic raw) {
    try {
      if (raw is! String) {
        return;
      }

      final Map<String, dynamic> json = jsonDecode(raw) as Map<String, dynamic>;
      _eventController?.add(json);

      final item = _tryParseTriageItem(json);
      if (item != null) {
        _controller?.add(item);
      }
    } catch (_) {
      // Ignore malformed messages
    }
  }

  TriageItem? _tryParseTriageItem(Map<String, dynamic> message) {
    final type =
        (message['type'] ?? message['event_type'] ?? '')
            .toString()
            .toLowerCase();

    final triageTypes = <String>{
      'triage_created',
      'patient_created',
      'triage_updated',
      'status_changed',
      'priority_update',
      'critical_alert',
      'sla_breach',
      'triage_event',
    };

    if (!triageTypes.contains(type)) {
      return null;
    }

    final rawData = message['data'];
    Map<String, dynamic>? triageJson;

    if (rawData is Map<String, dynamic>) {
      final nested = rawData['triage_item'];
      if (nested is Map<String, dynamic>) {
        triageJson = nested;
      } else {
        triageJson = rawData;
      }
    } else if (message['triage_item'] is Map<String, dynamic>) {
      triageJson = message['triage_item'] as Map<String, dynamic>;
    } else {
      triageJson = message;
    }

    final id = triageJson['id'] ?? triageJson['submission_id'] ?? triageJson['patient_id'];
    if (id == null) {
      return null;
    }

    return TriageItem.fromJson(triageJson);
  }

  void _onError(Object error) {
    _stopHeartbeat();
    _channel = null;
    _isConnecting = false;
    if (_isAuthFailure(error)) {
      _authFailureBlocked = true;
      debugPrint('WebSocket auth failure detected; reconnect disabled until login.');
      disconnect();
      return;
    }
    if (!_intentionallyClosed) {
      _scheduleReconnect();
    }
  }

  void _onDone() {
    _stopHeartbeat();
    _channel = null;
    _isConnecting = false;
    if (!_intentionallyClosed) {
      _scheduleReconnect();
    }
  }

  void _scheduleReconnect() {
    if (_authFailureBlocked) {
      return;
    }
    _stopHeartbeat();
    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(_reconnectDelay, () {
      if (!_intentionallyClosed && !_authFailureBlocked) {
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
    _isConnecting = false;
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

  bool _isAuthFailure(Object error) {
    final text = error.toString().toLowerCase();
    return text.contains('4001') ||
        text.contains('401') ||
        text.contains('unauthorized') ||
        text.contains('token expired') ||
        text.contains('invalid token') ||
        text.contains('authentication failed') ||
        text.contains('reject');
  }

  /// Dispose the manager (close stream controller). Call on app shutdown.
  void dispose() {
    disconnect();
    _controller?.close();
    _controller = null;
    _eventController?.close();
    _eventController = null;
  }
}
