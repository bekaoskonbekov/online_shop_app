import 'package:equatable/equatable.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object> get props => [];
}



class FetchChatsRequested extends ChatEvent {
  final String userId;

  const FetchChatsRequested(this.userId);

  @override
  List<Object> get props => [userId];
}

class SendMessageRequested extends ChatEvent {
  final String chatId;
  final String content;
  final String type;

  const SendMessageRequested(this.chatId, this.content, {this.type = 'text'});

  @override
  List<Object> get props => [chatId, content, type];
}

class FetchMessagesRequested extends ChatEvent {
  final String chatId;

  const FetchMessagesRequested(this.chatId);

  @override
  List<Object> get props => [chatId];
}

class CreateChatRequested extends ChatEvent {
  final String otherUserId;

  const CreateChatRequested(this.otherUserId);

  @override
  List<Object> get props => [otherUserId];
}

class ChatExistsRequested extends ChatEvent {
  final String otherUserId;

  const ChatExistsRequested(this.otherUserId);

  @override
  List<Object> get props => [otherUserId];
}
class FetchUserRequested extends ChatEvent {
  final String otherUserId;

  const FetchUserRequested(this.otherUserId);

  @override
  List<Object> get props => [otherUserId];
}



 
