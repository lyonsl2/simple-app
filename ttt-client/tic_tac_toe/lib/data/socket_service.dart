import 'dart:async';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  late IO.Socket _socket;
  final _controller = StreamController<dynamic>.broadcast();

  Stream<dynamic> get messages => _controller.stream;

  void connect({required String authToken}) {
    print('connect!!!');
    _socket = IO.io('http://10.0.2.2:3000', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
      'auth': {'token': authToken},
    });

    _socket.connect();

    _socket.onConnect((_) {
      print('Socket connected');
    });

    _socket.onDisconnect((_) {
      print('Socket disconnected');
    });

    _socket.on('message', (data) {
      print(data);
      _controller.add(data); // Push incoming data to stream
    });
  }

  void sendMessage(dynamic data) {
    _socket.emit('message', data);
  }

  void disconnect() {
    _socket.disconnect();
    _controller.close();
  }
}
