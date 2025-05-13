import 'dart:async';
import 'dart:convert';
import 'package:web_socket_channel/status.dart' as status;
import 'package:web_socket_channel/web_socket_channel.dart';

class SocketService {
  WebSocketChannel? _channel;
  late final StreamController _broadcast;

  SocketService() {
    _broadcast = StreamController.broadcast();
  }

  void connect() {
    if (_channel != null) {
      print('not connecting!!!');
      return;
    }
    print('connect!!!');

    final wsUrl = Uri.parse(
      'wss://m1wffjfqlh.execute-api.us-east-1.amazonaws.com/Prod',
    );
    _channel = WebSocketChannel.connect(wsUrl);

    _channel!.stream.listen((data) {
      _broadcast.add(data);
    });
  }

  Stream<dynamic> get stream {
    if (_channel == null) {
      throw Exception('WebSocket is not connected. Call connect() first.');
    }
    return _broadcast.stream;
  }

  void sendMessage(String message) {
    if (_channel == null) {
      throw Exception('WebSocket is not connected. Call connect() first.');
    }
    _channel!.sink.add(message);
  }

  void dispose() {
    _channel?.sink.close();
  }
}
