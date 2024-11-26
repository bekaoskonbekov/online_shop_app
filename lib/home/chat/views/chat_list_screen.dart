import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:my_example_file/blocs/chat/chat_bloc.dart';
import 'package:my_example_file/blocs/chat/chat_event.dart';
import 'package:my_example_file/blocs/chat/chat_state.dart';
import 'package:my_example_file/home/chat/repositories/chat_repository.dart';
import 'package:my_example_file/home/chat/models/chat_model.dart';
import 'package:my_example_file/home/user_info/models/user_model.dart';
import 'chat_screen.dart';

class ChatListScreen extends StatelessWidget {
  final UserModel currentUser;

  const ChatListScreen({Key? key, required this.currentUser}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChatBloc(chatRepository: ChatRepository())
        ..add(FetchChatsRequested(currentUser.uid)),
      child: _ChatListView(currentUser: currentUser),
    );
  }
}

class _ChatListView extends StatelessWidget {
  final UserModel currentUser;

  const _ChatListView({Key? key, required this.currentUser}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Chats'),
      ),
      body: BlocBuilder<ChatBloc, ChatState>(
        builder: (context, state) {
          if (state is ChatLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ChatsLoaded) {
            return _buildChatList(context, state.chats);
          } else if (state is ChatError) {
            return Center(child: Text('Error: ${state.message}'));
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildChatList(BuildContext context, List<ChatModel> chats) {
    if (chats.isEmpty) {
      return const Center(child: Text('No chats available.'));
    }
    return ListView.builder(
      itemCount: chats.length,
      itemBuilder: (context, index) => _buildChatListItem(context, chats[index]),
    );
  }

  Widget _buildChatListItem(BuildContext context, ChatModel chat) {
    final otherUser = chat.otherUser;
    if (otherUser == null) {
      return const SizedBox.shrink(); // Или можно показать заглушку
    }
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(otherUser.photoUrl),
      ),
      title: Text(otherUser.username),
      subtitle: Text(chat.lastMessage ?? 'No messages yet'),
      trailing: Text(
        DateFormat('HH:mm').format(chat.lastMessageAt),
        style: const TextStyle(color: Colors.grey, fontSize: 12),
      ),
      onTap: () => _navigateToChatScreen(context, chat),
    );
  }

void _navigateToChatScreen(BuildContext context, ChatModel chat) {
  if (chat.chatId.isEmpty || chat.otherUserId.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Chat data is incomplete.')),
    );
    return;
  }
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => ChatScreen(
        currentUser: currentUser,
        chatId: chat.chatId,
        otherUserId: chat.otherUserId,
      ),
    ),
  );
}
}