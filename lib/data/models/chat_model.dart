class ChatModel {
  final String id;
  final List<ChatUser> participants;
  final String? lastMessage;
  final DateTime lastMessageTime;
  final String? currentUserId;
  final bool isGroupChat;

  ChatModel({
    required this.id,
    required this.participants,
    this.lastMessage,
    required this.lastMessageTime,
    required this.currentUserId,
    this.isGroupChat = false,
  });

  ChatUser? get otherUser {
    try {
      if (participants.length < 2 || currentUserId == null) return null;
      
      
      for (final participant in participants) {
        if (participant.id != currentUserId) {
          return participant;
        }
      }
      
      return participants.isNotEmpty ? participants.first : null;
    } catch (e) {
      print('ChatModel: Error getting other user: $e');
      return participants.isNotEmpty ? participants.first : null;
    }
  }

  factory ChatModel.fromJson(Map<String, dynamic> json, String currentUserId) {
    try {
      print('ChatModel: Starting to parse JSON');
      
      
      final String chatId = json['_id']?.toString() ?? '';
      final bool isGroupChat = json['isGroupChat'] ?? false;
      
      print('ChatModel: Chat ID: $chatId, isGroupChat: $isGroupChat');
      
      
      List<ChatUser> participantsList = [];
      if (json.containsKey('participants') && json['participants'] is List) {
        final participantsArray = json['participants'] as List;
        print('ChatModel: Found ${participantsArray.length} participants');
        
        for (int i = 0; i < participantsArray.length; i++) {
          try {
            final participantData = participantsArray[i];
            if (participantData is Map<String, dynamic>) {
              final participant = ChatUser.fromJson(participantData);
              participantsList.add(participant);
              print('ChatModel: Successfully parsed participant ${i + 1}: ${participant.name ?? participant.email}');
            }
          } catch (e) {
            print('ChatModel: Error parsing participant $i: $e');
            continue; 
          }
        }
      }
      
      
      String? lastMessageContent;
      DateTime lastMessageTime = DateTime.now();
      
      if (json.containsKey('lastMessage')) {
        final lastMessageRaw = json['lastMessage'];
        if (lastMessageRaw is Map<String, dynamic>) {
          lastMessageContent = lastMessageRaw['content']?.toString();
          if (lastMessageRaw.containsKey('timestamp')) {
            final timestampStr = lastMessageRaw['timestamp']?.toString();
            if (timestampStr != null) {
              lastMessageTime = DateTime.tryParse(timestampStr) ?? DateTime.now();
            }
          }
        } else if (lastMessageRaw is String) {
          lastMessageContent = lastMessageRaw;
        }
      }
      
      
      if (json.containsKey('updatedAt')) {
        final updatedAtStr = json['updatedAt']?.toString();
        if (updatedAtStr != null) {
          final parsedTime = DateTime.tryParse(updatedAtStr);
          if (parsedTime != null) {
            lastMessageTime = parsedTime;
          }
        }
      }
      
      final chatModel = ChatModel(
        id: chatId,
        participants: participantsList,
        lastMessage: lastMessageContent,
        lastMessageTime: lastMessageTime,
        currentUserId: currentUserId,
        isGroupChat: isGroupChat,
      );
      
      print('ChatModel: Successfully created ChatModel');
      return chatModel;
      
    } catch (e, stackTrace) {
      print('ChatModel: Error in fromJson: $e');
      print('ChatModel: StackTrace: $stackTrace');
      
      
      return ChatModel(
        id: json['_id']?.toString() ?? 'unknown',
        participants: [],
        lastMessage: null,
        lastMessageTime: DateTime.now(),
        currentUserId: currentUserId,
      );
    }
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'participants': participants.map((e) => e.toJson()).toList(),
      'lastMessage': lastMessage,
      'lastMessageTime': lastMessageTime.toIso8601String(),
      'currentUserId': currentUserId,
      'isGroupChat': isGroupChat,
    };
  }
}

class ChatUser {
  final String id;
  final String? name;
  final String? email;
  final String? phone;
  final String? profile;
  final bool isOnline;
  final String role;

  ChatUser({
    required this.id,
    this.name,
    this.email,
    this.phone,
    this.profile,
    this.isOnline = false,
    this.role = 'user',
  });

  factory ChatUser.fromJson(Map<String, dynamic> json) {
    try {
      print('ChatUser: Starting to parse user JSON');
      
      final String userId = json['_id']?.toString() ?? '';
      final String? userName = json['name']?.toString();
      final String? userEmail = json['email']?.toString();
      final String? userPhone = json['phone']?.toString();
      final String? userProfile = json['profile']?.toString();
      final bool userIsOnline = json['isOnline'] ?? false;
      final String userRole = json['role']?.toString() ?? 'user';
      
      print('ChatUser: Parsed user - ID: $userId, Name: $userName, Email: $userEmail');
      
      
      
      
      return ChatUser(
        id: userId,
        name: userName,
        email: userEmail,
        phone: userPhone,
        profile: userProfile,
        isOnline: userIsOnline,
        role: userRole,
      );
      
    } catch (e, stackTrace) {
      print('ChatUser: Error parsing user: $e');
      print('ChatUser: StackTrace: $stackTrace');
      
      return ChatUser(
        id: json['_id']?.toString() ?? 'unknown',
        name: null,
        email: null,
      );
    }
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'profile': profile,
      'isOnline': isOnline,
      'role': role,
    };
  }
}
