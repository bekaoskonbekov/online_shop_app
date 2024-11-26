import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:my_example_file/home/chat/models/chat_model.dart';
import 'package:my_example_file/home/chat/models/message_model.dart';
import 'package:my_example_file/home/user_info/models/user_model.dart';

class ChatRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  ChatRepository({
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
    FirebaseStorage? storage,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance;

  Future<String> createChat(String otherUserId) async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception('Колдонуучу аутентификацияланган эмес');

      final chatDoc = await _firestore.collection('chats').add({
        'participants': [user.uid, otherUserId],
        'createdAt': FieldValue.serverTimestamp(),
        'lastMessageAt': FieldValue.serverTimestamp(),
        'lastMessage': '',
      });

      return chatDoc.id;
    } catch (e) {
      throw Exception('Чат түзүүдө ката кетти: $e');
    }
  }

  Future<String?> chatExists(String otherUserId) async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception('Колдонуучу аутентификацияланган эмес');

      final querySnapshot = await _firestore
          .collection('chats')
          .where('participants', arrayContains: user.uid)
          .get();

      for (var doc in querySnapshot.docs) {
        List<String> participants = List<String>.from(doc['participants']);
        if (participants.contains(otherUserId)) {
          return doc.id;
        }
      }

      return null;
    } catch (e) {
      throw Exception('Чатты текшерүүдө ката кетти: $e');
    }
  }

  Future<List<ChatModel>> fetchChats(String userId) async {
  try {
    final querySnapshot = await _firestore
        .collection('chats')
        .where('participants', arrayContains: userId)
        .orderBy('lastMessageAt', descending: true)
        .get();

    List<ChatModel> chats = [];

    for (var doc in querySnapshot.docs) {
      ChatModel chat = ChatModel.fromFirestore(doc);
      String otherUserId = chat.participants.firstWhere((id) => id != userId);
      chat.otherUserId = otherUserId;
      
      try {
        UserModel otherUser = await fetchUserData(otherUserId);
        chat.setOtherUser(otherUser);
      } catch (e) {
        print('Error fetching user data for $otherUserId: $e');
        // Колдонуучунун маалыматын алууда ката болсо да, чатты кошобуз
      }
      
      chats.add(chat);
    }

    return chats;
  } catch (e) {
    throw Exception('Чаттарды алууда ката кетти: $e');
  }
}

  Future<void> sendMessage(String chatId, String content) async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception('Колдонуучу аутентификацияланган эмес');

      final now = DateTime.now().toUtc();
      final message = {
        'senderId': user.uid,
        'content': content,
        'timestamp': now,
      };
      final chatRef = _firestore.collection('chats').doc(chatId);
      await chatRef.update({
        'messages': FieldValue.arrayUnion([message]),
        'lastMessage': content,
        'lastMessageAt': now,
      });
      await chatRef.update({
        'lastMessageAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Билдирүү жөнөтүүдө ката кетти: $e');
    }
  }

  Future<List<MessageModel>> fetchMessages(String chatId) async {
    try {
      final chatDoc = await _firestore.collection('chats').doc(chatId).get();
      if (!chatDoc.exists) throw Exception('Чат табылган жок');

      List<MessageModel> messages = [];
      List<dynamic> messagesData = chatDoc.data()?['messages'] ?? [];

      for (var messageData in messagesData) {
        messages.add(MessageModel.fromMap(messageData, chatId));
      }

      messages.sort((a, b) => b.timestamp
          .compareTo(a.timestamp)); // Билдирүүлөрдү timestamp боюнча сорттоо

      return messages;
    } catch (e) {
      throw Exception('Билдирүүлөрдү алууда ката кетти: $e');
    }
  }

  Future<void> deleteMessage(String chatId, String messageId) async {
    try {
      await _firestore
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .doc(messageId)
          .delete();
    } catch (e) {
      throw Exception('Билдирүүнү өчүрүүдө ката кетти: $e');
    }
  }

  Future<void> updateMessageReadStatus(
      String chatId, String messageId, bool isRead) async {
    try {
      await _firestore
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .doc(messageId)
          .update({'isRead': isRead});
    } catch (e) {
      throw Exception('Билдирүүнүн окулган статусун жаңыртууда ката кетти: $e');
    }
  }

Future<UserModel> fetchUserData(String userId) async {
  if (userId.isEmpty) {
    throw Exception('User ID is empty');
  }
  
  try {
    final docSnapshot = await _firestore.collection('users').doc(userId).get();
    if (docSnapshot.exists && docSnapshot.data() != null) {
      return UserModel.fromMap(docSnapshot.data()!);
    } else {
      throw Exception('User not found');
    }
  } catch (e) {
    throw Exception('Error retrieving user data: $e');
  }
}

}
