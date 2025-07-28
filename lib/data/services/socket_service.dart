// lib/data/services/socket_service.dart
import 'package:socket_io_client/socket_io_client.dart' as IO;
class SocketService {
  IO.Socket? _socket;
  bool _isConnected = false;

  void connect() {
    if (_isConnected) return;

    _socket = IO.io('http://45.129.87.38:6065', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    _socket!.connect();

    _socket!.onConnect((_) {
      print('Socket connected');
      _isConnected = true;
    });

    _socket!.onDisconnect((_) {
      print('Socket disconnected');
      _isConnected = false;
    });
  }

  void disconnect() {
    if (_isConnected) {
      _socket?.disconnect();
      _isConnected = false;
    }
  }

  void joinChat(String chatId) {
    if (_isConnected) {
      _socket?.emit('joinChat', chatId);
    }
  }

  void sendMessage(Map<String, dynamic> messageData) {
    if (_isConnected) {
      _socket?.emit('sendMessage', messageData);
    }
  }

  void onNewMessage(Function(dynamic) callback) {
    _socket?.on('newMessage', callback);
  }

  bool get isConnected => _isConnected;
}
