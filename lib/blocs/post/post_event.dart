import 'package:equatable/equatable.dart';

abstract class PostEvent extends Equatable {
  const PostEvent();

  @override
  List<Object> get props => [];
}

class CreatePost extends PostEvent {
  final List<String> imageUrls;
  final String caption;
  final List<Map<String, dynamic>> location;
  final String name;
  final int price;
  final List<Map<String, dynamic>> category;
   final String socialMediaLink;
  final String currency;
  final String transactionType;
  final String phoneNumber;


  const CreatePost({
    required this.imageUrls,
    required this.caption,
   required this.location,
    this.name = '',
    this.price = 0,
    required this.category,
    this.socialMediaLink = '',
    this.currency = '',
    this.transactionType = '',
    this.phoneNumber = '',
  });

  @override
  List<Object> get props => [
        imageUrls,
        caption,
        location,
        name,
        price,
        category,
        socialMediaLink,
        currency,
        transactionType,
        phoneNumber
      ];
}

class GetPosts extends PostEvent {}

class LikePost extends PostEvent {
  final String postId;
  final String userId;

  const LikePost(this.postId, this.userId);

  @override
  List<Object> get props => [postId, userId];
}

class AddComment extends PostEvent {
  final String postId;
  final String userId;
  final String text;

  const AddComment(this.postId, this.userId, this.text);

  @override
  List<Object> get props => [postId, userId, text];
}

class GetComments extends PostEvent {
  final String postId;

  const GetComments(this.postId);

  @override
  List<Object> get props => [postId];
}

class DeleteComment extends PostEvent {
  final String postId;
  final String commentId;

  const DeleteComment(this.postId, this.commentId);

  @override
  List<Object> get props => [postId, commentId];
}

class DeletePost extends PostEvent {
  final String postId;

  const DeletePost(this.postId);

  @override
  List<Object> get props => [postId];
}