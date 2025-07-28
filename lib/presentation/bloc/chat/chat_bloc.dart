import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/repositories/chat_repository.dart';
import 'chat_event.dart';
import 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatRepository chatRepository;

  ChatBloc({required this.chatRepository}) : super(ChatInitial()) {
    on<LoadChats>(_onLoadChats);
    on<RefreshChats>(_onRefreshChats);
  }

  Future<void> _onLoadChats(
    LoadChats event,
    Emitter<ChatState> emit,
  ) async {
    emit(ChatLoading());
    try {
      final chats = await chatRepository.getUserChats(event.userId);
      emit(ChatLoaded(chats));
    } catch (e) {
      emit(ChatError(e.toString()));
    }
  }

  Future<void> _onRefreshChats(
    RefreshChats event,
    Emitter<ChatState> emit,
  ) async {
    try {
      final chats = await chatRepository.getUserChats(event.userId);
      emit(ChatLoaded(chats));
    } catch (e) {
      emit(ChatError(e.toString()));
    }
  }
}
