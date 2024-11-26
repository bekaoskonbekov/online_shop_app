import 'package:flutter/material.dart';

class LikeButton extends StatelessWidget {
  final bool isLiked;
  final VoidCallback onTap;

  const LikeButton({Key? key, required this.isLiked, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return ScaleTransition(scale: animation, child: child);
        },
        child: Icon(
          isLiked ? Icons.favorite : Icons.favorite_border,
          key: ValueKey<bool>(isLiked),
          color: isLiked ? Colors.red : null,
          size: 28,
        ),
      ),
    );
  }
}