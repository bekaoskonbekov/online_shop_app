import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_example_file/blocs/post/post_bloc.dart';
import 'package:my_example_file/blocs/post/post_event.dart';
import 'package:my_example_file/blocs/post/post_state.dart';
import 'package:my_example_file/blocs/profile/profile_bloc.dart';
import 'package:my_example_file/blocs/profile/profile_event.dart';
import 'package:my_example_file/blocs/profile/profile_state.dart';
import 'package:my_example_file/home/user_info/repositoris/user_info_repository.dart';
import 'package:my_example_file/home/posts/models/comment_model.dart';
import 'package:my_example_file/home/user_info/models/user_model.dart';

class CommentBottomSheet extends StatefulWidget {
  final String postId;
  final UserModel currentUser;

  const CommentBottomSheet({
    Key? key,
    required this.postId,
    required this.currentUser,
  }) : super(key: key);

  @override
  _CommentBottomSheetState createState() => _CommentBottomSheetState();
}

class _CommentBottomSheetState extends State<CommentBottomSheet>
    with SingleTickerProviderStateMixin {
  final TextEditingController _commentController = TextEditingController();
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    context.read<PostBloc>().add(GetComments(widget.postId));
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 50),
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _commentController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, 200 * (1 - _animation.value)),
          child: Opacity(
            opacity: _animation.value,
            child: child,
          ),
        );
      },
      child: Container(
        height: MediaQuery.of(context).size.height * 0.75,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
         
        ),
        child: Column(
          children: [
            Divider(height: 20,indent: 90,endIndent: 90,thickness: 3,),
            Text('Comment'),
            _buildHeader(),
            Expanded(child: _buildCommentList()),
            _buildCommentInput(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.symmetric( horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
         
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              _animationController.reverse().then((_) {
                Navigator.of(context).pop();
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCommentList() {
    return BlocBuilder<PostBloc, PostState>(
      builder: (context, state) {
        if (state is CommentsLoaded) {
          return ListView.builder(
            itemCount: state.comments.length,
            itemBuilder: (context, index) =>
                _buildCommentItem(state.comments[index], index),
          );
        } else if (state is PostLoading) {
          return Center(child: CircularProgressIndicator());
        } else {
          return Center(child: Text('Комментарийлер жүктөлбөй калды'));
        }
      },
    );
  }

  Widget _buildCommentItem(Comment comment, int index) {
    return BlocProvider(
      create: (context) => EditProfileBloc(
        editrepository: RepositoryProvider.of<EditProfileRepository>(context),
      )..add(GetProfileRequested(uid: comment.userId)),
      child: BlocBuilder<EditProfileBloc, EditProfileState>(
        builder: (context, state) {
          if (state is ProfileLoaded) {
            final userProfileData = state.profileData;
            final isCurrentUser = userProfileData.uid == widget.currentUser.uid;
            return AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(200 * (1 - _animation.value), 0),
                  child: Opacity(
                    opacity: _animation.value,
                    child: child,
                  ),
                );
              },
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(userProfileData.photoUrl),
                      radius: 20,
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                userProfileData.username,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                 
                                ),
                              ),
                              if (isCurrentUser)
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Text(
                                     _getTimeAgo(comment.timestamp),
                            style: TextStyle(fontSize: 12),
                                    
                                  ),
                                ),
                            ],
                          ),
                          SizedBox(height: 4),
                          Text(comment.text),
                          SizedBox(height: 4),
                         
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else if (state is EditProfileLoading) {
            return Padding(
              padding: EdgeInsets.all(8.0),
              child: Center(child: CircularProgressIndicator()),
            );
          } else {
            return ListTile(
              leading: CircleAvatar(child: Icon(Icons.error)),
              title: Text('Белгисиз колдонуучу'),
              subtitle: Text(comment.text),
            );
          }
        },
      ),
    );
  }

  Widget _buildCommentInput() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(widget.currentUser.photoUrl),
            radius: 20,
          ),
          SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: _commentController,
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
          SizedBox(width: 12),
          IconButton(
            icon: Icon(Icons.send,),
            onPressed: _sendComment,
          ),
        ],
      ),
    );
  }

  void _sendComment() {
    if (_commentController.text.isNotEmpty) {
      context.read<PostBloc>().add(
            AddComment(
              widget.postId,
              widget.currentUser.uid,
              _commentController.text,
            ),
          );
      _commentController.clear();
    }
  }

  String _getTimeAgo(DateTime timestamp) {
    final difference = DateTime.now().difference(timestamp);
    if (difference.inDays > 7) {
      return '${difference.inDays ~/ 7} апта';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} күн';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} саат';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} мүнөт';
    } else {
      return 'Жаңы эле';
    }
  }
}