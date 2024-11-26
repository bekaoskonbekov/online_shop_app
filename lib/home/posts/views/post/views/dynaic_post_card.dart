import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:my_example_file/blocs/chat/chat_bloc.dart';
import 'package:my_example_file/blocs/chat/chat_event.dart';
import 'package:my_example_file/blocs/chat/chat_state.dart';
import 'package:my_example_file/blocs/post/post_bloc.dart';
import 'package:my_example_file/blocs/post/post_event.dart';
import 'package:my_example_file/blocs/profile/profile_bloc.dart';
import 'package:my_example_file/blocs/profile/profile_event.dart';
import 'package:my_example_file/blocs/profile/profile_state.dart';
import 'package:my_example_file/home/chat/repositories/chat_repository.dart';
import 'package:my_example_file/home/user_info/repositoris/user_info_repository.dart';
import 'package:my_example_file/home/chat/views/chat_screen.dart';
import 'package:my_example_file/home/posts/views/post/widgets/comment_bottom_sheet.dart';
import 'package:my_example_file/home/posts/models/post_model.dart';
import 'package:my_example_file/home/user_info/models/user_model.dart';

class DynamicPostCard extends StatefulWidget {
  final PostModel post;
  final UserModel currentUser;
  final bool isListView;
  const DynamicPostCard({
    Key? key,
    required this.post,
    required this.currentUser,
    this.isListView = true,
  }) : super(key: key);

  @override
  _DynamicPostCardState createState() => _DynamicPostCardState();
}

class _DynamicPostCardState extends State<DynamicPostCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _likeAnimationController;
  bool _isLiked = false;
  int _currentPage = 0;
  @override
  void initState() {
    super.initState();
    _likeAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 50),
    );
    _isLiked = widget.post.likes.contains(widget.currentUser.uid);
  }

  @override
  void dispose() {
    _likeAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChatBloc(
          chatRepository: RepositoryProvider.of<ChatRepository>(context)),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.isListView) _buildHeader(),
            _buildImage(),
            _buildActions(),
            _buildCaption(),
            _buildTimestamp(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return BlocProvider(
      create: (context) => EditProfileBloc(
        editrepository: RepositoryProvider.of<EditProfileRepository>(context),
      )..add(GetProfileRequested(uid: widget.post.userId)),
      child: BlocBuilder<EditProfileBloc, EditProfileState>(
        builder: (context, state) {
          if (state is ProfileLoaded) {
            final userProfileData = state.profileData;
            return Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage(userProfileData.photoUrl),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userProfileData.username,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        if (widget.post.location.isNotEmpty)
                          Text(
                            widget.post.location.first.name,
                            style: const TextStyle(
                                fontSize: 12,
                                color: Color.fromARGB(255, 1, 140, 255)),
                          ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.more_vert),
                    onPressed: () {
                      // Пост параметрлерин ишке ашыруу үчүн кээ бир параметрлерди же менюну көрсөтүү
                    },
                  ),
                ],
              ),
            );
          } else if (state is EditProfileLoading) {
            return const Padding(
              padding: EdgeInsets.all(8.0),
              child: Center(child: CircularProgressIndicator()),
            );
          } else {
            return const ListTile(
              leading: CircleAvatar(child: Icon(Icons.error)),
              title: Text('Белгисиз колдонуучу'),
              subtitle: Text(''),
            );
          }
        },
      ),
    );
  }

Widget _buildImage() {
  return GestureDetector(
    onDoubleTap: _handleLikeAnimation,
    child: ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          SizedBox(
            height: 300,
            child: widget.post.imageUrls.length == 1
              ? _buildSingleImage(widget.post.imageUrls[0])
              : _buildMultipleImages(),
          ),
          if (widget.post.imageUrls.length > 1)
            _buildPageIndicator(),
        ],
      ),
    ),
  );
}

Widget _buildSingleImage(String imageUrl) {
  return Image.network(
    imageUrl,
    fit: BoxFit.cover,
    width: double.infinity,
    loadingBuilder: (context, child, loadingProgress) {
      if (loadingProgress == null) return child;
      return Center(child: CircularProgressIndicator());
    },
    errorBuilder: (context, error, stackTrace) {
      return Center(child: Icon(Icons.error));
    },
  );
}

Widget _buildMultipleImages() {
  return PageView.builder(
    itemCount: widget.post.imageUrls.length,
    onPageChanged: (index) {
      setState(() {
        _currentPage = index;
      });
    },
    itemBuilder: (context, index) {
      return _buildSingleImage(widget.post.imageUrls[index]);
    },
  );
}

Widget _buildPageIndicator() {
  return Positioned(
    bottom: 10,
    child: DotsIndicator(
      dotsCount: widget.post.imageUrls.length,
      position: _currentPage,
      decorator: DotsDecorator(
        activeColor: const Color.fromARGB(255, 58, 243, 33),
        color: Colors.white.withOpacity(0.5),
        size: const Size.square(6.0),
        activeSize: const Size(8.0, 8.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4.0),
        ),
      ),
    ),
  );
}
  Widget _buildActions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25,vertical: 4),
      child: Row(
        children: [
          if(widget.isListView)
          Expanded(
            child: Row(
              children: [
                _buildActionColumn(
                  count: widget.post.likes.length,
                  icon: Icons.favorite,
                  isActive: _isLiked,
                  onTap: _handleLikeAnimation,
                ),
                const SizedBox(width: 30),
                if(widget.isListView)
                _buildActionColumn(
                  count: widget.post.comments.length,
                  icon: Icons.comment_outlined,
                  onTap: () => _showCommentBottomSheet(context),
                ),
                const SizedBox(width: 30),
                if(widget.isListView)
                _buildActionColumn(
                  count: 0,
                  icon: Icons.send_outlined,
                  onTap: () => _onChatRequested(context),
                ),
              ],
            ),
          ),
          Row(
            children: [
              Text(
                widget.post.price.toString(),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
              SizedBox(width: 4),
              Text(widget.post.currency,   style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),)
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionColumn({
    int? count,
    required IconData icon,
    required VoidCallback onTap,
    bool isActive = false,
  }) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,size: 26,
            color: isActive ? Colors.red : null,
          ),
          if (count != null)
            Text(
              '$count',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCaption() {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Text(
          widget.post.caption,
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            wordSpacing: 3,
            letterSpacing: 1,
            
          ),
        ));
  }

  Widget _buildTimestamp() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      child: Text(
        _getTimeAgo(widget.post.timestamp),
        style: TextStyle(color: Colors.grey[600], fontSize: 12),
      ),
    );
  }

  void _handleLikeAnimation() {
    setState(() {
      _isLiked = !_isLiked;
    });
    if (_isLiked) {
      _likeAnimationController.forward();
    } else {
      _likeAnimationController.reverse();
    }
    context
        .read<PostBloc>()
        .add(LikePost(widget.post.postId, widget.currentUser.uid));
  }

  void _showCommentBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => CommentBottomSheet(
        postId: widget.post.postId,
        currentUser: widget.currentUser,
      ),
    );
  }

  void _onChatRequested(BuildContext context) {
    context.read<ChatBloc>().add(ChatExistsRequested(widget.post.userId));
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BlocListener<ChatBloc, ChatState>(
          listener: (context, state) {
            if (state is ChatExistsResult) {
              if (state.chatId != null) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatScreen(
                      currentUser: widget.currentUser,
                      chatId: state.chatId!,
                      otherUserId: widget.post.userId,
                    ),
                  ),
                );
              } else {
                context
                    .read<ChatBloc>()
                    .add(CreateChatRequested(widget.post.userId));
              }
            } else if (state is ChatCreated) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatScreen(
                    currentUser: widget.currentUser,
                    chatId: state.chatId,
                    otherUserId: widget.post.userId,
                  ),
                ),
              );
            } else if (state is ChatError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Ката: ${state.message}')),
              );
            }
          },
          child: const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          ),
        ),
      ),
    );
  }

  String _getTimeAgo(DateTime timestamp) {
    final difference = DateTime.now().difference(timestamp);
    if (difference.inDays > 7) {
      return DateFormat('d MMMM').format(timestamp);
    } else if (difference.inDays > 0) {
      return '${difference.inDays} күн мурун';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} саат мурун';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} мүнөт мурун';
    } else {
      return 'Жаңы гана';
    }
  }
}
