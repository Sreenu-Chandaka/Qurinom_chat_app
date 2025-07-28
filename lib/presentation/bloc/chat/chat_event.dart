
import 'package:equatable/equatable.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object> get props => [];
}

class LoadChats extends ChatEvent {
  final String userId;

  const LoadChats(this.userId);

  @override
  List<Object> get props => [userId];
}

class RefreshChats extends ChatEvent {
  final String userId;

  const RefreshChats(this.userId);

  @override
  List<Object> get props => [userId];
}
