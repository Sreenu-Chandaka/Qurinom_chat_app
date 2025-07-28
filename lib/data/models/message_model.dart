class MessageModel {
  final String id;
  final String chatId;
  final String senderId;
  final String content;
  final String messageType;
  final String? fileUrl;
  final DateTime timestamp;
  final String? senderName;
  
  
  final List<String>? deletedBy;
  final String? status;
  final DateTime? deliveredAt;
  final DateTime? seenAt;
  final List<String>? seenBy;
  final List<dynamic>? reactions;
  final DateTime? sentAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  MessageModel({
    required this.id,
    required this.chatId,
    required this.senderId,
    required this.content,
    required this.messageType,
    this.fileUrl,
    required this.timestamp,
    this.senderName,
    
    this.deletedBy,
    this.status,
    this.deliveredAt,
    this.seenAt,
    this.seenBy,
    this.reactions,
    this.sentAt,
    this.createdAt,
    this.updatedAt,
  });

  
  factory MessageModel.fromApiResponse(Map<String, dynamic> json) {
    try {
      DateTime timestamp;
      
      
      if (json['sentAt'] != null) {
        timestamp = DateTime.tryParse(json['sentAt'].toString()) ?? DateTime.now();
      } else if (json['createdAt'] != null) {
        timestamp = DateTime.tryParse(json['createdAt'].toString()) ?? DateTime.now();
      } else if (json['timestamp'] != null) {
        timestamp = DateTime.tryParse(json['timestamp'].toString()) ?? DateTime.now();
      } else {
        timestamp = DateTime.now();
      }

      return MessageModel(
        id: json['_id']?.toString() ?? '',
        chatId: json['chatId']?.toString() ?? '',
        senderId: json['senderId']?.toString() ?? '',
        content: json['content']?.toString() ?? '',
        messageType: json['messageType']?.toString() ?? 'text',
        fileUrl: json['fileUrl']?.toString(),
        timestamp: timestamp,
        senderName: json['senderName']?.toString(),
        
        deletedBy: (json['deletedBy'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .toList(),
        status: json['status']?.toString(),
        deliveredAt: json['deliveredAt'] != null 
            ? DateTime.tryParse(json['deliveredAt'].toString())
            : null,
        seenAt: json['seenAt'] != null 
            ? DateTime.tryParse(json['seenAt'].toString())
            : null,
        seenBy: (json['seenBy'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .toList(),
        reactions: json['reactions'] as List<dynamic>?,
        sentAt: json['sentAt'] != null 
            ? DateTime.tryParse(json['sentAt'].toString())
            : null,
        createdAt: json['createdAt'] != null 
            ? DateTime.tryParse(json['createdAt'].toString())
            : null,
        updatedAt: json['updatedAt'] != null 
            ? DateTime.tryParse(json['updatedAt'].toString())
            : null,
      );
    } catch (e) {
      print('Error parsing MessageModel from API: $e');
      return MessageModel(
        id: json['_id']?.toString() ?? 'unknown',
        chatId: json['chatId']?.toString() ?? '',
        senderId: json['senderId']?.toString() ?? '',
        content: json['content']?.toString() ?? 'Error loading message',
        messageType: 'text',
        timestamp: DateTime.now(),
      );
    }
  }

  
  factory MessageModel.fromSocketData(Map<String, dynamic> data) {
    try {
      return MessageModel(
        id: data['_id']?.toString() ?? DateTime.now().millisecondsSinceEpoch.toString(),
        chatId: data['chatId']?.toString() ?? '',
        senderId: data['senderId']?.toString() ?? '',
        content: data['content']?.toString() ?? '',
        messageType: data['messageType']?.toString() ?? 'text',
        fileUrl: data['fileUrl']?.toString(),
        timestamp: data['timestamp'] != null 
            ? DateTime.tryParse(data['timestamp'].toString()) ?? DateTime.now()
            : DateTime.now(),
        senderName: data['senderName']?.toString(),
      );
    } catch (e) {
      print('Error parsing MessageModel from socket: $e');
      return MessageModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        chatId: data['chatId']?.toString() ?? '',
        senderId: data['senderId']?.toString() ?? '',
        content: data['content']?.toString() ?? 'Error loading message',
        messageType: 'text',
        timestamp: DateTime.now(),
        senderName: data['senderName']?.toString(),
      );
    }
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'chatId': chatId,
      'senderId': senderId,
      'content': content,
      'messageType': messageType,
      'fileUrl': fileUrl,
      'timestamp': timestamp.toIso8601String(),
      'senderName': senderName,
      
      if (deletedBy != null) 'deletedBy': deletedBy,
      if (status != null) 'status': status,
      if (deliveredAt != null) 'deliveredAt': deliveredAt!.toIso8601String(),
      if (seenAt != null) 'seenAt': seenAt!.toIso8601String(),
      if (seenBy != null) 'seenBy': seenBy,
      if (reactions != null) 'reactions': reactions,
      if (sentAt != null) 'sentAt': sentAt!.toIso8601String(),
      if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
      if (updatedAt != null) 'updatedAt': updatedAt!.toIso8601String(),
    };
  }

  
  bool get isDelivered => deliveredAt != null;
  bool get isSeen => seenAt != null;
  bool get isDeleted => deletedBy?.isNotEmpty ?? false;
  bool get hasReactions => reactions?.isNotEmpty ?? false;

  
  MessageModel copyWith({
    String? id,
    String? chatId,
    String? senderId,
    String? content,
    String? messageType,
    String? fileUrl,
    DateTime? timestamp,
    String? senderName,
    List<String>? deletedBy,
    String? status,
    DateTime? deliveredAt,
    DateTime? seenAt,
    List<String>? seenBy,
    List<dynamic>? reactions,
    DateTime? sentAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return MessageModel(
      id: id ?? this.id,
      chatId: chatId ?? this.chatId,
      senderId: senderId ?? this.senderId,
      content: content ?? this.content,
      messageType: messageType ?? this.messageType,
      fileUrl: fileUrl ?? this.fileUrl,
      timestamp: timestamp ?? this.timestamp,
      senderName: senderName ?? this.senderName,
      deletedBy: deletedBy ?? this.deletedBy,
      status: status ?? this.status,
      deliveredAt: deliveredAt ?? this.deliveredAt,
      seenAt: seenAt ?? this.seenAt,
      seenBy: seenBy ?? this.seenBy,
      reactions: reactions ?? this.reactions,
      sentAt: sentAt ?? this.sentAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
