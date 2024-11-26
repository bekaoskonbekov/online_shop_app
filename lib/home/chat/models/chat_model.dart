import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_example_file/home/chat/models/message_model.dart';
import 'package:my_example_file/home/user_info/models/user_model.dart';

class ChatModel {
  String chatId;
  final List<String> participants;
  final DateTime createdAt;
  DateTime lastMessageAt;
  String? lastMessage;
  List<MessageModel> messages;
  UserModel? otherUser;
  String otherUserId; 

  ChatModel({
    required this.chatId,
    required this.participants,
    required this.createdAt,
    required this.lastMessageAt,
    this.lastMessage,
    this.messages = const [],
    this.otherUser,
    required this.otherUserId,
  });

 factory ChatModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    var chat = ChatModel.fromMap(data)..chatId = doc.id;
    chat.otherUserId = chat.participants.firstWhere((id) => id != FirebaseAuth.instance.currentUser?.uid);
    return chat;
  }

  Map<String, dynamic> toMap() {
    return {
      'chatId': chatId,
      'participants': participants,
      'createdAt': Timestamp.fromDate(createdAt),
      'lastMessageAt': Timestamp.fromDate(lastMessageAt),
      'lastMessage': lastMessage,
    };
  }

    factory ChatModel.fromMap(Map<String, dynamic> map) {
    return ChatModel(
      chatId: map['chatId'] ?? '',
      participants: List<String>.from(map['participants'] ?? []),
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      lastMessageAt: (map['lastMessageAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      lastMessage: map['lastMessage'],
      otherUserId: '', 
    );
  }


  void updateLastMessage(MessageModel message) {
    lastMessage = message.content;
    lastMessageAt = message.timestamp;
    messages.insert(0, message);
  }

  void setOtherUser(UserModel user) {
    otherUser = user;
  }
}