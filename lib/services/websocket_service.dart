import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';

class SocketService {
  late WebSocketChannel channel;

  void connect(String token, Function(Map<String, dynamic>) onEvent) {
    channel = WebSocketChannel.connect(
      Uri.parse('ws://localhost:3002/ws/v1/updates/'),
    );

    channel.sink.add(jsonEncode({
      "type": "AUTH",
      "token": token,
    }));

    channel.stream.listen((message) {
      final data = jsonDecode(message);
      onEvent(data);
    });
  }
}