

import '../models/chat_model.dart';
import '../services/api_service.dart';

class ChatRepository {
  final ApiService _apiService;

  ChatRepository(this._apiService);

  Future<List<ChatModel>> getUserChats(String userId) async {
    try {
      print('ChatRepository: Getting chats for user: $userId');
      
      final response = await _apiService.getUserChats(userId);
      
      if (response == null) {
        print('ChatRepository: Response is null');
        return [];
      }
      
      print('ChatRepository: Response type: ${response.runtimeType}');
      
      List<ChatModel> chats = [];
      
      if (response is List) {
        print('ChatRepository: Processing ${response.length} chats');
        
        for (int index = 0; index < response.length; index++) {
          try {
            final chatData = response[index];
            if (chatData is Map<String, dynamic>) {
              final chat = ChatModel.fromJson(chatData, userId);
              chats.add(chat);
              print('ChatRepository: Successfully processed chat ${index + 1}');
            } else {
              print('ChatRepository: Chat at index $index is not a Map');
            }
          } catch (e) {
            print('ChatRepository: Error processing chat at index $index: $e');
            continue; 
          }
        }
      } else if (response is Map<String, dynamic>) {
        
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      }
      
      print('ChatRepository: Successfully processed ${chats.length} chats');
      return chats;
      
    } catch (e, stackTrace) {
      print('ChatRepository: Major error in getUserChats: $e');
      print('ChatRepository: StackTrace: $stackTrace');
      return [];
    }
  }
}