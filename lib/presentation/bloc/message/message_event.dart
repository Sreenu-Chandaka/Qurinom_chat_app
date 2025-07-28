
import 'package:equatable/equatable.dart';

abstract class MessageEvent extends Equatable {
  const MessageEvent();

  @override
  List<Object> get props => [];
}

class LoadMessages extends MessageEvent {
  final String chatId;

  const LoadMessages(this.chatId);

  @override
  List<Object> get props => [chatId];
}

class SendMessage extends MessageEvent {
  final String chatId;
  final String senderId;
  final String content;
  final String messageType;
  final String fileUrl; // Remove the ? symbol

  const SendMessage({
    required this.chatId,
    required this.senderId,
    required this.content,
    required this.messageType,
    this.fileUrl = '', // Provide a default value
  });

  @override
  List<Object> get props => [chatId, senderId, content, messageType, fileUrl];
}
class ConnectSocket extends MessageEvent {}

class DisconnectSocket extends MessageEvent {}

class JoinChat extends MessageEvent {
  final String chatId;

  const JoinChat(this.chatId);

  @override
  List<Object> get props => [chatId];
}
