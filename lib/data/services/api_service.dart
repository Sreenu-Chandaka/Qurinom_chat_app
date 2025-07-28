import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://45.129.87.38:6065';
  
  Map<String, String> get headers => {
    'Content-Type': 'application/json',
  };

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
    required String role,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/user/login'),
        headers: headers,
        body: jsonEncode({
          'email': email,
          'password': password,
          'role': role,
        }),
      );

      print('=== LOGIN DEBUG ===');
      print('Login response status: ${response.statusCode}');
      print('Login response body: ${response.body}');
      print('Login response headers: ${response.headers}');
      print('==================');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        try {
          return jsonDecode(response.body);
        } catch (jsonError) {
          print('Login JSON decode error: $jsonError');
          throw Exception('Invalid JSON response from login: $jsonError');
        }
      } else {
        throw Exception('Login failed: HTTP ${response.statusCode} - ${response.body}');
      }
    } catch (e, stackTrace) {
      print('Login error: $e');
      print('Login stackTrace: $stackTrace');
      rethrow;
    }
  }

  Future<List<dynamic>> getUserChats(String userId) async {
    try {
      print('Getting user chats for user ID: $userId');
      print('Headers: $headers');
      
      final url = Uri.parse('$baseUrl/chats/user-chats/$userId');
      print('Request URL: $url');
      
      final response = await http.get(url, headers: headers);
      
      print('=== GET CHATS DEBUG ===');
      print('Response status code: ${response.statusCode}');
      print('Response headers: ${response.headers}');
      print('Raw response body: ${response.body}');
      print('Response body type: ${response.body.runtimeType}');
      print('Response body length: ${response.body.length}');
      print('======================');
      
      if (response.statusCode >= 200 && response.statusCode < 300) {
        if (response.body.isEmpty) {
          print('Response body is empty');
          return [];
        }
        
        dynamic decodedData;
        try {
          decodedData = jsonDecode(response.body);
          print('Decoded data type: ${decodedData.runtimeType}');
        } catch (jsonError) {
          print('JSON decode error: $jsonError');
          throw Exception('Invalid JSON response: $jsonError');
        }
        
        if (decodedData is Map<String, dynamic>) {
          if (decodedData.containsKey('chats')) {
            final chatsData = decodedData['chats'];
            if (chatsData is List) {
              print('Found ${chatsData.length} chats');
              return chatsData;
            } else if (chatsData == null) {
              return [];
            } else {
              return [];
            }
          } else {
            print('Available keys: ${decodedData.keys.toList()}');
            return [];
          }
        } else if (decodedData is List) {
          return decodedData;
        } else {
          return [];
        }
      } else {
        throw Exception('Failed to get chats: HTTP ${response.statusCode} - ${response.body}');
      }
    } catch (e, stackTrace) {
      print('getUserChats error: $e');
      print('getUserChats stackTrace: $stackTrace');
      rethrow;
    }
  }

  Future<List<dynamic>> getChatMessages(String chatId) async {
    try {
      print('Getting messages for chat ID: $chatId');
      
      final response = await http.get(
        Uri.parse('$baseUrl/messages/get-messagesformobile/$chatId'),
        headers: headers,
      );

      print('=== GET MESSAGES DEBUG ===');
      print('Messages response status: ${response.statusCode}');
      print('Messages response body: ${response.body}');
      print('Messages response headers: ${response.headers}');
      print('==========================');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        if (response.body.isEmpty) {
          return [];
        }
        
        final data = jsonDecode(response.body);
        
        if (data is Map<String, dynamic>) {
          return data['messages'] ?? [];
        } else if (data is List) {
          return data;
        } else {
          return [];
        }
      } else {
        throw Exception('Failed to get messages: HTTP ${response.statusCode} - ${response.body}');
      }
    } catch (e, stackTrace) {
      print('getChatMessages error: $e');
      print('getChatMessages stackTrace: $stackTrace');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> sendMessage({
    required String chatId,
    required String senderId,
    required String content,
    required String messageType,
    String? fileUrl,
  }) async {
    try {
      print('=== SEND MESSAGE DEBUG START ===');
      print('Sending message to chat: $chatId');
      print('Sender ID: $senderId');
      print('Content: $content');
      print('Message type: $messageType');
      print('File URL: $fileUrl');
      
      final requestBody = jsonEncode({
        'chatId': chatId,
        'senderId': senderId,
        'content': content,
        'messageType': messageType,
        'fileUrl': fileUrl ?? '',
      });
      
      print('Request body: $requestBody');
      print('Request headers: $headers');
      print('Request URL: $baseUrl/messages/sendMessage');
      
      final response = await http.post(
        Uri.parse('$baseUrl/messages/sendMessage'),
        headers: headers,
        body: requestBody,
      );

      print('=== SEND MESSAGE RESPONSE ===');
      print('Response status code: ${response.statusCode}');
      print('Response status code type: ${response.statusCode.runtimeType}');
      print('Response headers: ${response.headers}');
      print('Response body: ${response.body}');
      print('Response body type: ${response.body.runtimeType}');
      print('Response body length: ${response.body.length}');
      
      // Check specific status codes
      print('Is status code 200? ${response.statusCode == 200}');
      print('Is status code 201? ${response.statusCode == 201}');
      print('Is status code >= 200? ${response.statusCode >= 200}');
      print('Is status code < 300? ${response.statusCode < 300}');
      print('Is in success range? ${response.statusCode >= 200 && response.statusCode < 300}');
      print('=============================');

      // Handle ALL possible success status codes
      if (response.statusCode >= 200 && response.statusCode < 300) {
        print('✅ SUCCESS: Status code is in success range');
        
        if (response.body.isEmpty) {
          print('⚠️ WARNING: Response body is empty but status is success');
          return {'status': 'sent', 'message': 'Empty response body'};
        }
        
        try {
          final decodedResponse = jsonDecode(response.body);
          print('✅ SUCCESS: JSON decoded successfully');
          print('Decoded response type: ${decodedResponse.runtimeType}');
          return decodedResponse is Map<String, dynamic> ? decodedResponse : {};
        } catch (jsonError) {
          print('❌ ERROR: JSON decode failed: $jsonError');
          // If JSON decode fails but status is success, return basic info
          return {
            'status': 'sent',
            'rawResponse': response.body,
            'error': 'JSON decode failed but message was sent'
          };
        }
      } else {
        print('❌ ERROR: Status code ${response.statusCode} is not in success range');
        throw Exception('Failed to send message: HTTP ${response.statusCode} - ${response.body}');
      }
    } catch (e, stackTrace) {
      print('❌ SEND MESSAGE ERROR: $e');
      print('❌ SEND MESSAGE STACK TRACE: $stackTrace');
      rethrow;
    }
  }
}