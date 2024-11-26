import 'package:equatable/equatable.dart';
import 'package:my_example_file/home/chat/models/chat_model.dart';
import 'package:my_example_file/home/chat/models/message_model.dart';
import 'package:my_example_file/home/user_info/models/user_model.dart';

abstract class ChatState extends Equatable {
  const ChatState();

  @override
  List<Object> get props => [];
}

class ChatInitial extends ChatState {}

class ChatLoading extends ChatState {}

class ChatError extends ChatState {
  final String message;

  const ChatError(this.message);

  @override
  List<Object> get props => [message];
}



class ChatsLoaded extends ChatState {
  final List<ChatModel> chats;

  const ChatsLoaded(this.chats);

  @override
  List<Object> get props => [chats];
}

class MessageSent extends ChatState {}

class MessagesLoaded extends ChatState {
  final List<MessageModel> messages;

  const MessagesLoaded(this.messages);

  @override
  List<Object> get props => [messages];
}

class ChatExistsResult extends ChatState {
  final String? chatId;

  const ChatExistsResult(this.chatId);
}
class ChatCreated extends ChatState {
  final String chatId;

  const ChatCreated(this.chatId);

  @override
  List<Object> get props => [chatId];
}

class UserLoaded extends ChatState {
  final UserModel user;

  const UserLoaded(this.user);

  @override
  List<Object> get props => [user];
}