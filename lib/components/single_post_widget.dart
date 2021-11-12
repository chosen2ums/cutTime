import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:salon/models/post.dart';

import 'like_widget.dart';

class SinglePostWidget extends StatefulWidget {
  final Post post;
  final List<Widget> photos;
  SinglePostWidget(this.post, this.photos);

  @override
  _SinglePostWidgetState createState() => _SinglePostWidgetState();
}

class _SinglePostWidgetState extends State<SinglePostWidget> {
  int pos = 0;
  Timer timer;

  @override
  void initState() {
    setState(() {
      timer = Timer.periodic(new Duration(seconds: 3), (timer) {
        setState(() {
          pos = (pos + 1) % widget.post.photos.length;
        });
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    timer = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => print('single post'),
      child: Stack(
        children: [
          AnimatedSwitcher(
            duration: Duration(seconds: 1),
            switchInCurve: Curves.easeOutSine,
            switchOutCurve: Curves.easeOutSine,
            child: widget.photos[pos],
          ),
          widget.post.photos.length > 1
              ? Positioned(
                  top: 2,
                  right: 2,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(2)),
                      color: Colors.black38,
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                    child: Text(
                      "${pos % widget.post.photos.length + 1}/${widget.post.photos.length}",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                      ),
                    ),
                  ),
                )
              : Container(),
          Positioned(
            left: 0,
            right: 0,
            bottom: 10,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                LikeWidget(widget.post, color: Colors.white),
                Text('${widget.post.likes.length}', style: TextStyle(color: Colors.white, shadows: [Shadow(color: Colors.black26)])),
                SizedBox(width: 15),
                Icon(
                  Ionicons.chatbubble_ellipses_outline,
                  color: Colors.white,
                  size: 25,
                ),
                Text('${widget.post.comments.length}', style: TextStyle(color: Colors.white, shadows: [Shadow(color: Colors.black26)])),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
