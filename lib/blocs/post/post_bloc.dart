import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_example_file/blocs/post/post_event.dart';
import 'package:my_example_file/blocs/post/post_state.dart';
import 'package:my_example_file/core/helpers/chace_helper.dart';
import 'package:my_example_file/home/posts/repositories/post_repository.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  final PostRepository _postRepository;

  PostBloc({required PostRepository postRepository})
      : _postRepository = postRepository,
        super(PostInitial()) {
    on<CreatePost>(_onCreatePost);
    on<GetPosts>(_onGetPosts);
    on<LikePost>(_onLikePost);
    on<AddComment>(_onAddComment);
    on<GetComments>(_onGetComments);
    on<DeleteComment>(_onDeleteComment);
    on<DeletePost>(_onDeletePost);
  }

 Future<void> _onCreatePost(CreatePost event, Emitter<PostState> emit) async {
  emit(PostLoading());
  try {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      emit(const PostError('User is not authenticated'));
      return;
    }

    List<Map<String, dynamic>> formattedCategories =
        event.category.map((category) {
      return _formatCategory(category);
    }).toList();
    List<Map<String, dynamic>> formattedLocations =
        event.location.map((location) {
      return _formatLocation(location);
    }).toList();

    final post = await _postRepository.createPost(
      userId: currentUser.uid,
      imageUrls: event.imageUrls,
      caption: event.caption,
      location: formattedLocations,
      name: event.name,
      price: event.price,
      category: formattedCategories,
      socialMediaLink: event.socialMediaLink,
      currency: event.currency,
      transactionType: event.transactionType,
      phoneNumber: event.phoneNumber,
    );

    if (post != null) {
      await CacheHelper.setString(CacheKey.postId, post.postId);
      emit(PostCreated(post));
      add(GetPosts());
    } else {
      emit(const PostError('Failed to create post'));
    }
  } catch (e) {
    emit(PostError(e.toString()));
  }
}

Map<String, dynamic> _formatLocation(Map<String, dynamic> location) {
  return {
    'id': location['id'],
    'name': location['name'],
    'subLocation': (location['subLocation'] as List<dynamic>?)
            ?.map((subcategory) {
          return _formatLocation(subcategory);
        }).toList() ??
        [],
  };
}
Map<String, dynamic> _formatCategory(Map<String, dynamic> category) {
  return {
    'id': category['id'],
    'name': category['name'],
    'subcategories': (category['subcategories'] as List<dynamic>?)
            ?.map((subcategory) {
          return _formatCategory(subcategory);
        }).toList() ??
        [],
  };
}
 Future<void> _onGetPosts(GetPosts event, Emitter<PostState> emit) async {
  emit(PostLoading());
  try {
    final posts = await _postRepository.getPosts();
    if (posts.isNotEmpty) {
      await CacheHelper.setString(CacheKey.postId, posts.first.postId);
      emit(PostsLoaded(posts));
    } else {
      emit(const PostsLoaded([]));
    }
  } catch (e) {
    emit(PostError(e.toString()));
  }
}
  Future<void> _onLikePost(LikePost event, Emitter<PostState> emit) async {
    try {
      await _postRepository.likePost(event.postId, event.userId);
      final updatedPosts = await _postRepository.getPosts();
      emit(PostsLoaded(updatedPosts));
    } catch (e) {
      emit(PostError(e.toString()));
    }
  }

  Future<void> _onAddComment(AddComment event, Emitter<PostState> emit) async {
    try {
      await _postRepository.addComment(event.postId, event.userId, event.text);
      add(GetComments(event.postId));
    } catch (e) {
      emit(PostError(e.toString()));
    }
  }

  Future<void> _onGetComments(
      GetComments event, Emitter<PostState> emit) async {
    emit(PostLoading());
    try {
      final comments = await _postRepository.getComments(event.postId);
      emit(CommentsLoaded(comments));
    } catch (e) {
      emit(PostError(e.toString()));
    }
  }

  Future<void> _onDeleteComment(
      DeleteComment event, Emitter<PostState> emit) async {
    try {
      await _postRepository.deleteComment(event.postId, event.commentId);
      add(GetComments(event.postId));
    } catch (e) {
      emit(PostError(e.toString()));
    }
  }

  Future<void> _onDeletePost(DeletePost event, Emitter<PostState> emit) async {
    try {
      await _postRepository.deletePost(event.postId);
      final updatedPosts = await _postRepository.getPosts();
      emit(PostsLoaded(updatedPosts));
    } catch (e) {
      emit(PostError(e.toString()));
    }
  }
}
