import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_example_file/home/posts/models/category_model.dart';
import 'package:my_example_file/home/posts/models/comment_model.dart';
import 'package:my_example_file/home/posts/models/location_model.dart';

class PostModel {
  final String postId;
  final String userId;
  final String caption;
  final List<String> imageUrls;
  final DateTime timestamp;
  final List<String> likes;
  final List<Comment> comments;
  final List<LocationModel> location;
  final String name;
  final int price;
  final List<CategoryModel> category;
  final String socialMediaLink;
  final String currency;
  final String transactionType;
  final String phoneNumber;

  PostModel({
    required this.postId,
    required this.userId,
    required this.caption,
    required this.imageUrls,
    required this.timestamp,
    this.likes = const [],
    this.comments = const [],
    this.location = const [],
    this.name = '',
    this.price = 0,
    this.category = const [],
    this.socialMediaLink = '',
    this.currency = '',
    this.transactionType = '',
    this.phoneNumber = '',
  });

  factory PostModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return PostModel(
      postId: doc.id,
      userId: data['userId'] ?? '',
      caption: data['caption'] ?? '',
      imageUrls: List<String>.from(data['imageUrls'] ?? []),
      timestamp: (data['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
      likes: List<String>.from(data['likes'] ?? []),
      comments: (data['comments'] as List<dynamic>?)
          ?.map((c) => Comment.fromMap(c as Map<String, dynamic>))
          .toList() ??
          [],
      location: (data['location'] as List<dynamic>?)
          ?.map((l) => LocationModel.fromMap(l as Map<String, dynamic>))
          .toList() ??
          [],
      name: data['name'] ?? '',
      price: (data['price'] as int?)?.toInt() ?? 0,
      category: (data['category'] as List<dynamic>?)
          ?.map((c) => CategoryModel.fromMap(c as Map<String, dynamic>))
          .toList() ??
          [],
      socialMediaLink: data['socialMediaLink'] ?? '',
      currency: data['currency'] ?? '',
      transactionType: data['transactionType'] ?? '',
      phoneNumber: data['phoneNumber'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'caption': caption,
      'imageUrls': imageUrls,
      'timestamp': Timestamp.fromDate(timestamp),
      'likes': likes,
      'comments': comments.map((comment) => comment.toMap()).toList(),
      'location': location.map((loc) => loc.toMap()).toList(),
      'name': name,
      'price': price,
      'category': category.map((cat) => cat.toMap()).toList(),
      'socialMediaLink': socialMediaLink,
      'currency': currency,
      'transactionType': transactionType,
      'phoneNumber': phoneNumber,
    };
  }
}
