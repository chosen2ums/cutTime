import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:like_button/like_button.dart';
import 'package:salon/models/post.dart';

class LikeWidget extends StatelessWidget {
  final Post post;
  final Color color;
  LikeWidget(this.post, {this.color});
  @override
  Widget build(BuildContext context) {
    return LikeButton(
      circleColor: CircleColor(start: Color(0xff00ddff), end: Color(0xff0099cc)),
      bubblesColor: BubblesColor(
        dotPrimaryColor: Theme.of(context).colorScheme.secondary,
        dotSecondaryColor: Theme.of(context).colorScheme.secondaryVariant,
      ),
      padding: EdgeInsets.all(0.5),
      onTap: (isLiked) => post.like(),
      isLiked: post.isLiked,
      likeBuilder: (liked) {
        return Icon(
          post.isLiked ? Ionicons.heart : Ionicons.heart_outline,
          color: post.isLiked
              ? Colors.redAccent
              : this.color == null
                  ? Theme.of(context).hintColor
                  : color,
          size: 26,
        );
      },
    );
  }
}
