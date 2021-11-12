import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';
import 'package:salon/components/like_widget.dart';
import 'package:salon/components/post_photo_widget.dart';
import 'package:salon/components/save_widget.dart';
import 'package:salon/models/post.dart';
import 'package:salon/provider/app_provider.dart';

class PostWidget extends StatelessWidget {
  final Post post;
  final int access;
  PostWidget(this.post, {this.access = 1});

  @override
  Widget build(BuildContext context) {
    AppProvider provider = Provider.of(context);
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Column(
        children: [
          post.photos.length == 0 ? Container() : PostPhoto(post, access: access),
          Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.fromLTRB(8, 2, 10, 2),
            child: Row(
              children: <Widget>[
                Visibility(
                  visible: true,
                  child: LikeWidget(post),
                ),
                Visibility(
                  visible: true,
                  child: SaveWidget(post),
                ),
                SizedBox(width: 3),
                Expanded(
                  child: InkWell(
                    onTap: () => provider.showCommentSheet(context, post),
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 3),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Ionicons.chatbubble_ellipses_outline,
                            color: Theme.of(context).hintColor,
                            size: 25,
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              post.body,
                              softWrap: true,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: TextStyle(
                                color: Theme.of(context).hintColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
