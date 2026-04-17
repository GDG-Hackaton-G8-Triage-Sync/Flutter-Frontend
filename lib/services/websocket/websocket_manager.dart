import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/io.dart';
import 'dart:async';
import 'dart:convert';
import '../../core/utils/env_loader.dart';
import '../secure_storage/secure_storage_service.dart';

class WebSocketManager {
  static final WebSocketManager _instance = WebSocketManager._internal();
  factory WebSocketManager() => _instance;
  WebSocketManager._internal();

  WebSocketChannel? _channel;
  final StreamController<Map<String, dynamic>> _messageController =
      StreamController.broadcast();
  Timer? _heartbeatTimer;
  bool _reconnecting = false;
  int _reconnectAttempts = 0;

  Stream<Map<String, dynamic>> get messages => _messageController.stream;

  Future<void> connect() async {
    if (_channel != null) return;

    final token = await SecureStorageService().getAccessToken();
    if (token == null) return;

    final wsUrl = Uri.parse(
      '${EnvLoader.apiUrl.replaceFirst('http', 'ws')}/ws/triage/',
    );
    _channel = IOWebSocketChannel.connect(wsUrl);

    // Send auth message
    _channel!.sink.add(jsonEncode({'token': token}));

    // Listen to incoming messages
    _channel!.stream.listen(
      (data) {
        _messageController.add(jsonDecode(data as String));
        _resetHeartbeat();
      },
      onError: (error) {
        _attemptReconnection();
      },
      onDone: () {
        _attemptReconnection();
      },
    );

    _startHeartbeat();
  }

  void _startHeartbeat() {
    _heartbeatTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      _channel?.sink.add('ping');
    });
  }

  void _resetHeartbeat() {
    _heartbeatTimer?.cancel();
    _startHeartbeat();
  }

  void _attemptReconnection() {
    if (_reconnecting) return;
    _reconnecting = true;
    final delay = Duration(
      seconds: [1, 2, 4, 8, 15, 30][_reconnectAttempts.clamp(0, 5)],
    );
    Future.delayed(delay, () async {
      await disconnect();
      await connect();
      _reconnectAttempts++;
      _reconnecting = false;
    });
  }

  Future<void> disconnect() async {
    _heartbeatTimer?.cancel();
    await _channel?.sink.close();
    _channel = null;
  }

  void dispose() {
    disconnect();
    _messageController.close();
  }
}
