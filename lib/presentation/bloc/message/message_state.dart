
import 'package:equatable/equatable.dart';

import '../../../data/models/message_model.dart';

abstract class MessageState extends Equatable {
  const MessageState();

  @override
  List<Object> get props => [];
}

class MessageInitial extends MessageState {}

class MessageLoading extends MessageState {}

class MessageLoaded extends MessageState {
  final List<MessageModel> messages;

  const MessageLoaded(this.messages);

  @override
  List<Object> get props => [messages];
}

class MessageSending extends MessageState {
  final List<MessageModel> messages;

  const MessageSending(this.messages);

  @override
  List<Object> get props => [messages];
}

class MessageSent extends MessageState {
  final List<MessageModel> messages;

  const MessageSent(this.messages);

  @override
  List<Object> get props => [messages];
}

class MessageError extends MessageState {
  final String message;

  const MessageError(this.message);

  @override
  List<Object> get props => [message];
}
