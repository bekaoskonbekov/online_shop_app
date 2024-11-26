import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_example_file/home/chat/repositories/chat_repository.dart';
import 'chat_event.dart';
import 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatRepository _chatRepository;

  ChatBloc({required ChatRepository chatRepository})
      : _chatRepository = chatRepository,
        super(ChatInitial()) {
    on<CreateChatRequested>(_onCreateChatRequested);
    on<ChatExistsRequested>(_onChatExistsRequested);
    on<FetchChatsRequested>(_onFetchChatsRequested);
    on<SendMessageRequested>(_onSendMessageRequested);
    on<FetchMessagesRequested>(_onFetchMessagesRequested);
    on<FetchUserRequested>(_onFetchUserRequested);  // Жаңы окуяны каттайбыз
  }

  void _onCreateChatRequested(CreateChatRequested event, Emitter<ChatState> emit) async {
    emit(ChatLoading());
    try {
      final chatId = await _chatRepository.createChat(event.otherUserId);
      emit(ChatCreated(chatId));
    } catch (e) {
      emit(ChatError(e.toString()));
    }
  }

  void _onChatExistsRequested(ChatExistsRequested event, Emitter<ChatState> emit) async {
    emit(ChatLoading());
    try {
      final existingChatId = await _chatRepository.chatExists(event.otherUserId);
      emit(ChatExistsResult(existingChatId));
    } catch (e) {
      emit(ChatError(e.toString()));
    }
  }

  void _onFetchChatsRequested(FetchChatsRequested event, Emitter<ChatState> emit) async {
    emit(ChatLoading());
    try {
      final chats = await _chatRepository.fetchChats(event.userId);
      emit(ChatsLoaded(chats));
    } catch (e) {
      emit(ChatError(e.toString()));
    }
  }

  void _onSendMessageRequested(SendMessageRequested event, Emitter<ChatState> emit) async {
    emit(ChatLoading());
    try {
      await _chatRepository.sendMessage(event.chatId, event.content);
      emit(MessageSent());
    } catch (e) {
      emit(ChatError(e.toString()));
    }
  }

  void _onFetchMessagesRequested(FetchMessagesRequested event, Emitter<ChatState> emit) async {
    emit(ChatLoading());
    try {
      final messages = await _chatRepository.fetchMessages(event.chatId);
      emit(MessagesLoaded(messages));
    } catch (e) {
      emit(ChatError(e.toString()));
    }
  }

  // Жаңы иштетүүчү функция кошуу
  void _onFetchUserRequested(FetchUserRequested event, Emitter<ChatState> emit) async {
  emit(ChatLoading());

  // Алгач, userId'нин бош эместигин текшеребиз
  if (event.otherUserId.isEmpty) {
    emit(ChatError('User ID is empty'));
    return;
  }

  try {
    final user = await _chatRepository.fetchUserData(event.otherUserId);
    emit(UserLoaded(user));
  } catch (e) {
    emit(ChatError('Error fetching user data: $e'));
  }
}

}
