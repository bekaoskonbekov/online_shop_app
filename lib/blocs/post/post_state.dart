import 'package:equatable/equatable.dart';
import 'package:my_example_file/home/posts/models/post_model.dart';
import 'package:my_example_file/home/posts/models/comment_model.dart';

abstract class PostState extends Equatable {
  const PostState();
  
  @override
  List<Object> get props => [];
}

class PostInitial extends PostState {}

class PostLoading extends PostState {}

class PostsLoaded extends PostState {
  final List<PostModel> posts;

  const PostsLoaded(this.posts);

  @override
  List<Object> get props => [posts];
}

class PostCreated extends PostState {
  final PostModel post;

  const PostCreated(this.post);

  @override
  List<Object> get props => [post];
}

class CommentsLoaded extends PostState {
  final List<Comment> comments;

  const CommentsLoaded(this.comments);

  @override
  List<Object> get props => [comments];
}

class CommentAdded extends PostState {
  final Comment comment;

  const CommentAdded(this.comment);

  @override
  List<Object> get props => [comment];
}

class CommentDeleted extends PostState {
  final String commentId;

  const CommentDeleted(this.commentId);

  @override
  List<Object> get props => [commentId];
}

class PostError extends PostState {
  final String error;

  const PostError(this.error);

  @override
  List<Object> get props => [error];
}