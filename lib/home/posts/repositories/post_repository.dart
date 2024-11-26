// ignore_for_file: unnecessary_null_comparison

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_example_file/home/posts/models/comment_model.dart';
import 'package:my_example_file/home/posts/models/post_model.dart';

class PostRepository {
  final FirebaseFirestore _firestore;

  PostRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

 Future<PostModel?> createPost({
  required String userId,
  required List<String> imageUrls,
  required String caption,
  List<Map<String, dynamic>> location = const [],
  String name = '',
  int price = 0,
  List<Map<String, dynamic>> category = const [],
  String socialMediaLink = '',
  required String currency,
  required String transactionType,
  String phoneNumber = '',
}) async {
  try {
    final docRef = await _firestore.collection('posts').add({
      'userId': userId,
      'imageUrls': imageUrls,
      'caption': caption,
      'timestamp': FieldValue.serverTimestamp(),
      'likes': [],
      'comments': [],
      'location': location,
      'name': name,
      'price': price,
      'category': category,
      'socialMediaLink': socialMediaLink,
      'currency': currency,
      'transactionType': transactionType,
      'phoneNumber': phoneNumber,
    });
    final doc = await docRef.get();
    return PostModel.fromFirestore(doc);
  } catch (e) {
    print('Error creating post: $e');
    return null;
  }
}
 Future<List<PostModel>> getPosts() async {
  try {
    final querySnapshot = await _firestore
        .collection('posts') // Коллекциянын туура аталышын колдонуңуз
        .orderBy('timestamp', descending: true)
        .get();

    return querySnapshot.docs
        .map((doc) => PostModel.fromFirestore(doc))
        .where((post) => post != null) // Null жооптор алынбайт
        .map((post) => post) // Null эмес жооптор алынат
        .toList();
  } catch (e) {
    print('Error getting posts: $e');
    return [];
  }
}

  Future<void> likePost(String postId, String userId) async {
    try {
      final postRef = _firestore.collection('posts').doc(postId);
      await _firestore.runTransaction((transaction) async {
        final postDoc = await transaction.get(postRef);
        if (!postDoc.exists) {
          throw Exception('Post does not exist!');
        }

        final likes = List<String>.from(postDoc.data()!['likes'] ?? []);

        if (likes.contains(userId)) {
          likes.remove(userId);
        } else {
          likes.add(userId);
        }

        transaction.update(postRef, {'likes': likes});
      });
    } catch (e) {
      print('Error liking post: $e');
    }
  }

  Future<void> addComment(String postId, String userId, String text) async {
    try {
      final comment = Comment(
        commentId: '',
        userId: userId,
        text: text,
        timestamp: DateTime.now(),
      );

      final postRef = _firestore.collection('posts').doc(postId);
      await postRef.update({
        'comments': FieldValue.arrayUnion([comment.toMap()])
      });
    } catch (e) {
      print('Error adding comment: $e');
    }
  }

  Future<List<Comment>> getComments(String postId) async {
    try {
      final postDoc = await _firestore.collection('posts').doc(postId).get();
      final comments =
          List<Map<String, dynamic>>.from(postDoc.data()!['comments'] ?? []);
      return comments.map((comment) => Comment.fromMap(comment)).toList();
    } catch (e) {
      print('Error getting comments: $e');
      return [];
    }
  }

  Future<void> deleteComment(String postId, String commentId) async {
    try {
      final postRef = _firestore.collection('posts').doc(postId);
      await _firestore.runTransaction((transaction) async {
        final postDoc = await transaction.get(postRef);
        if (!postDoc.exists) {
          throw Exception('Post does not exist!');
        }

        final comments =
            List<Map<String, dynamic>>.from(postDoc.data()!['comments'] ?? []);
        comments.removeWhere((comment) => comment['commentId'] == commentId);

        transaction.update(postRef, {'comments': comments});
      });
    } catch (e) {
      print('Error deleting comment: $e');
    }
  }

  Future<void> deletePost(String postId) async {
    try {
      await _firestore.collection('posts').doc(postId).delete();
    } catch (e) {
      print('Error deleting post: $e');
    }
  }
}
