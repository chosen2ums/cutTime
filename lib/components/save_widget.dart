import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:like_button/like_button.dart';
import 'package:salon/models/post.dart';

class SaveWidget extends StatelessWidget {
  final Post post;
  SaveWidget(this.post);
  @override
  Widget build(BuildContext context) {
    return LikeButton(
      circleColor: CircleColor(start: Color(0xff00ddff), end: Color(0xff0099cc)),
      bubblesColor: BubblesColor(
        dotPrimaryColor: Theme.of(context).colorScheme.secondaryVariant,
        dotSecondaryColor: Theme.of(context).colorScheme.secondary,
      ),
      padding: EdgeInsets.all(0.5),
      onTap: (isSaved) => post.save(),
      isLiked: post.isSaved,
      likeBuilder: (liked) {
        return Icon(
          post.isSaved ? Ionicons.bookmark : Ionicons.bookmark_outline,
          color: post.isSaved ? Theme.of(context).colorScheme.secondary : Theme.of(context).hintColor,
          size: 25,
        );
      },
    );
  }
}
