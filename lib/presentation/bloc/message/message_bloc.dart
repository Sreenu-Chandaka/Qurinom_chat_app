import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/message_model.dart';
import '../../../data/repositories/message_repository.dart';
import 'message_event.dart';
import 'message_state.dart';

class MessageBloc extends Bloc<MessageEvent, MessageState> {
  final MessageRepository messageRepository;
  List<MessageModel> _currentMessages = [];

  MessageBloc({required this.messageRepository}) : super(MessageInitial()) {
    on<LoadMessages>(_onLoadMessages);
    on<SendMessage>(_onSendMessage);
    on<ConnectSocket>(_onConnectSocket);
    on<DisconnectSocket>(_onDisconnectSocket);
    on<JoinChat>(_onJoinChat);

    // Listen for new messages from socket
    messageRepository.onNewMessage((data) {
      final newMessage = MessageModel(
        id: data['_id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
        chatId: data['chatId'] ?? '',
        senderId: data['senderId'] ?? '',
        content: data['content'] ?? '',
        messageType: data['messageType'] ?? 'text',
        fileUrl: data['fileUrl'],
        timestamp: DateTime.now(),
        senderName: data['senderName'],
      );
      
      _currentMessages.add(newMessage);
      emit(MessageLoaded(List.from(_currentMessages)));
    });
  }

  Future<void> _onLoadMessages(
    LoadMessages event,
    Emitter<MessageState> emit,
  ) async {
    emit(MessageLoading());
    try {
      final messages = await messageRepository.getChatMessages(event.chatId);
      _currentMessages = messages;
      emit(MessageLoaded(messages));
    } catch (e) {
      emit(MessageError(e.toString()));
    }
  }

  Future<void> _onSendMessage(
    SendMessage event,
    Emitter<MessageState> emit,
  ) async {
    emit(MessageSending(_currentMessages));
    try {
      final message = await messageRepository.sendMessage(
        chatId: event.chatId,
        senderId: event.senderId,
        content: event.content,
        messageType: event.messageType,
        fileUrl: event.fileUrl,
      );
      
      _currentMessages.add(message);
      emit(MessageSent(List.from(_currentMessages)));
    } catch (e) {
      emit(MessageError(e.toString()));
    }
  }

  Future<void> _onConnectSocket(
    ConnectSocket event,
    Emitter<MessageState> emit,
  ) async {
    messageRepository.connectSocket();
  }

  Future<void> _onDisconnectSocket(
    DisconnectSocket event,
    Emitter<MessageState> emit,
  ) async {
    messageRepository.disconnectSocket();
  }

  Future<void> _onJoinChat(
    JoinChat event,
    Emitter<MessageState> emit,
  ) async {
    messageRepository.joinChat(event.chatId);
  }
}
