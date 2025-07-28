
import '../models/message_model.dart';
import '../services/api_service.dart';

class MessageRepository {
  final ApiService _apiService;

  MessageRepository(this._apiService);

  
  void connectSocket() {
    
    print('Connecting to socket...');
  }

  void disconnectSocket() {
    
    print('Disconnecting from socket...');
  }

  void joinChat(String chatId) {
    
    print('Joining chat: $chatId');
  }

  void onNewMessage(Function(Map<String, dynamic>) callback) {
    
    
    print('Setting up new message listener...');
  }

  Future<List<MessageModel>> getChatMessages(String chatId) async {
    try {
      final response = await _apiService.getChatMessages(chatId);
      
      return response.map<MessageModel>((messageData) {
        if (messageData is Map<String, dynamic>) {
          return MessageModel.fromApiResponse(messageData);
        } else {
          print('Invalid message data format: $messageData');
          return MessageModel(
            id: 'invalid',
            chatId: chatId,
            senderId: '',
            content: 'Invalid message format',
            messageType: 'text',
            timestamp: DateTime.now(),
          );
        }
      }).toList();
    } catch (e) {
      print('Error in MessageRepository.getChatMessages: $e');
      return [];
    }
  }

  Future<MessageModel> sendMessage({
    required String chatId,
    required String senderId,
    required String content,
    required String messageType,
    String? fileUrl,
  }) async {
    try {
      final response = await _apiService.sendMessage(
        chatId: chatId,
        senderId: senderId,
        content: content,
        messageType: messageType,
        fileUrl: fileUrl,
      );
      
      if (response.isNotEmpty) {
        return MessageModel.fromApiResponse(response);
      } else {
        throw Exception('Empty response from sendMessage');
      }
    } catch (e) {
      print('Error in MessageRepository.sendMessage: $e');
      rethrow;
    }
  }
}