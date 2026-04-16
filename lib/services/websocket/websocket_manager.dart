import 'dart:async';
import 'dart:convert';

import 'package:web_socket_channel/web_socket_channel.dart';

import '../../core/utils/env_loader.dart';
import '../secure_storage/secure_storage_service.dart';

class WebSocketManager {
  WebSocketManager._internal();

  static final WebSocketManager _instance = WebSocketManager._internal();

  factory WebSocketManager() => _instance;

  final StreamController<Map<String, dynamic>> _messageController =
      StreamController<Map<String, dynamic>>.broadcast();
  final SecureStorageService _storage = SecureStorageService();

  WebSocketChannel? _channel;
  StreamSubscription<dynamic>? _channelSubscription;
  Timer? _heartbeatTimer;

  bool _isConnecting = false;
  bool _isReconnecting = false;
  bool _isDisposed = false;
  int _reconnectAttempts = 0;

  Stream<Map<String, dynamic>> get messages => _messageController.stream;

  Future<void> connect() async {
    if (_isDisposed || _isConnecting || _channel != null) {
      return;
    }

    _isConnecting = true;
    try {
      final token = await _storage.getAccessToken();
      if (token == null || token.isEmpty) {
        return;
      }

      final wsUrl = _buildWebSocketUrl();
      _channel = WebSocketChannel.connect(wsUrl);
      _channel?.sink.add(jsonEncode({'type': 'auth', 'token': token}));

      _channelSubscription = _channel?.stream.listen(
        (dynamic data) {
          final decoded = _decodeIncoming(data);
          if (decoded != null) {
            _messageController.add(decoded);
            _resetHeartbeat();
          }
        },
        onError: (_) => _attemptReconnection(),
        onDone: _attemptReconnection,
        cancelOnError: true,
      );

      _reconnectAttempts = 0;
      _startHeartbeat();
    } finally {
      _isConnecting = false;
    }
  }

  Uri _buildWebSocketUrl() {
    final base = EnvLoader.apiUrl
        .replaceFirst('https://', 'wss://')
        .replaceFirst('http://', 'ws://');
    return Uri.parse('$base/ws/triage/');
  }

  Map<String, dynamic>? _decodeIncoming(dynamic data) {
    if (data is String) {
      try {
        final decoded = jsonDecode(data);
        if (decoded is Map<String, dynamic>) {
          return decoded;
        }
      } catch (_) {
        return {'type': 'raw', 'data': data};
      }
    }

    if (data is Map<String, dynamic>) {
      return data;
    }

    return null;
  }

  void _startHeartbeat() {
    _heartbeatTimer?.cancel();
    _heartbeatTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      _channel?.sink.add(jsonEncode({'type': 'ping'}));
    });
  }

  void _resetHeartbeat() {
    _startHeartbeat();
  }

  void _attemptReconnection() {
    if (_isDisposed || _isReconnecting) {
      return;
    }

    _isReconnecting = true;
    final retrySchedule = <int>[1, 2, 4, 8, 15, 30];
    final index = _reconnectAttempts.clamp(0, retrySchedule.length - 1);
    final delay = Duration(seconds: retrySchedule[index]);

    Future<void>.delayed(delay, () async {
      if (_isDisposed) {
        _isReconnecting = false;
        return;
      }

      _reconnectAttempts++;
      await disconnect();
      await connect();
      _isReconnecting = false;
    });
  }

  Future<void> disconnect() async {
    _heartbeatTimer?.cancel();
    _heartbeatTimer = null;

    await _channelSubscription?.cancel();
    _channelSubscription = null;

    await _channel?.sink.close();
    _channel = null;
  }

  Future<void> dispose() async {
    _isDisposed = true;
    await disconnect();
    await _messageController.close();
  }
}
