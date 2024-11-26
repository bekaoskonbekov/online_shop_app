import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_example_file/blocs/chat/chat_bloc.dart';
import 'package:my_example_file/blocs/chat/chat_event.dart';
import 'package:my_example_file/blocs/chat/chat_state.dart';
import 'package:my_example_file/home/chat/repositories/chat_repository.dart';
import 'package:my_example_file/home/user_info/models/user_model.dart';
import 'package:my_example_file/home/chat/models/message_model.dart';

class ChatScreen extends StatelessWidget {
  final UserModel currentUser;
  final String chatId;
  final String otherUserId;

  const ChatScreen({
    Key? key,
    required this.currentUser,
    required this.chatId,
    required this.otherUserId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChatBloc(
        chatRepository: ChatRepository(),
      )..add(FetchMessagesRequested(chatId))
        ..add(FetchUserRequested(otherUserId)),
      child: _ChatScreenContent(
        currentUser: currentUser,
        chatId: chatId,
        otherUserId: otherUserId,
      ),
    );
  }
}

class _ChatScreenContent extends StatefulWidget {
  final UserModel currentUser;
  final String chatId;
  final String otherUserId;

  const _ChatScreenContent({
    Key? key,
    required this.currentUser,
    required this.chatId,
    required this.otherUserId,
  }) : super(key: key);

  @override
  _ChatScreenContentState createState() => _ChatScreenContentState();
}

class _ChatScreenContentState extends State<_ChatScreenContent> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
   UserModel? otherUser;

  @override
  void initState() {
    super.initState();
    _listenToUserChanges();
  }

  void _listenToUserChanges() {
    context.read<ChatBloc>().stream.listen((state) {
      if (state is UserLoaded && mounted) {
        setState(() {
          otherUser = state.user;
        });
      }
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Column(
        children: [
          Expanded(child: _buildMessageList()),
          _buildMessageComposer(),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: otherUser != null
          ? Row(
              children: [
                CircleAvatar(
                  backgroundImage: otherUser?.photoUrl != null
                      ? NetworkImage(otherUser!.photoUrl)
                      : const AssetImage('assets/images/default_avatar.png') as ImageProvider,
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(otherUser?.username ?? 'unknown',
                        style: const TextStyle(fontSize: 16)),
                    Text('online', style: const TextStyle(fontSize: 12)),
                  ],
                ),
              ],
            )
          : Text('Loading...'),
    );
  }

  Widget _buildMessageList() {
    return BlocConsumer<ChatBloc, ChatState>(
      listener: (context, state) {
        if (state is ChatError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      builder: (context, state) {
        if (state is ChatLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is MessagesLoaded) {
          final messages = state.messages;
          return ListView.builder(
            controller: _scrollController,
            reverse: true,
            itemCount: messages.length,
            itemBuilder: (context, index) {
              return _buildMessageItem(messages[index]);
            },
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

Widget _buildMessageItem(MessageModel message) {
  final isSentByMe = message.senderId == widget.currentUser.uid;
  return Align(
    alignment: isSentByMe ? Alignment.centerRight : Alignment.centerLeft,
    child: Container(
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      decoration: BoxDecoration(
        color: isSentByMe ? const Color.fromARGB(255, 3, 197, 39) : const Color.fromARGB(20, 255, 255, 255),
        borderRadius: BorderRadius.circular(20),
       
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(message.content),
          const SizedBox(height: 5),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                DateFormat('HH:mm').format(message.timestamp),
                style: TextStyle(fontSize: 10,),
              ),
              const SizedBox(width: 5),
              if (isSentByMe) _buildMessageStatus(message.isRead),
            ],
          ),
        ],
      ),
    ),
  );
}

Widget _buildMessageStatus(bool isRead) { 
  if (isRead) {
    return const Icon(Icons.done_all, size: 14, color: Colors.blue);
  } else {
    return const Icon(Icons.done, size: 14, color: Colors.grey);
  }
}

  Widget _buildMessageComposer() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
     
      child: Row(
        children: <Widget>[
          IconButton(
            icon: const Icon(Icons.emoji_emotions_outlined),
            onPressed: () {
              // TODO: Implement emoji picker
            },
          ),
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'typing ...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.attach_file),
            onPressed: () {
              // TODO: Implement file attachment
            },
          ),
          IconButton(
            icon: const Icon(Icons.camera_alt),
            onPressed: () {
              // TODO: Implement image capture
            },
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: _handleSubmitted,
          ),
        ],
      ),
    );
  }

  void _handleSubmitted() {
    if (_messageController.text.isNotEmpty) {
      context.read<ChatBloc>().add(SendMessageRequested(
            widget.chatId,
            _messageController.text,
          ));
      _messageController.clear();
      
    }
  }
}

enum MessageStatus { sent, delivered, read }