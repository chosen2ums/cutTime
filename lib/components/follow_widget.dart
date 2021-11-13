import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';
import 'package:salon/components/single_leader_widget.dart';
import 'package:salon/models/follow.dart';
import 'package:salon/provider/app_provider.dart' as app;

class FollowWidget extends StatefulWidget {
  final String head;
  FollowWidget({this.head = 'Following', Key key}) : super(key: key);

  @override
  FollowWidgetState createState() => FollowWidgetState();
}

class FollowWidgetState extends State<FollowWidget> {
  List<Follow> follow = List.empty();
  @override
  Widget build(BuildContext context) {
    app.AppProvider provider = Provider.of(context);
    follow = provider.salons
        .where((e) => e.isFollow == true)
        .toList()
        .map((e) => Follow(salon: e))
        .toList();
    return Visibility(
      visible: follow.length != 0,
      child: Container(
        height: 140,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 10),
              child: Text(
                '${widget.head} ${follow.length}',
                style: TextStyle(
                  color: Theme.of(context).hintColor.withOpacity(0.75),
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  shadows: [
                    Shadow(
                      blurRadius: 5,
                      color: Colors.black12,
                      offset: Offset(0, 3),
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              child: ListView.separated(
                shrinkWrap: true,
                cacheExtent: 10000,
                itemCount: follow.length,
                padding: EdgeInsets.all(10),
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) =>
                    AnimationConfiguration.staggeredList(
                  position: index,
                  duration: Duration(milliseconds: 200),
                  child: FadeInAnimation(
                      child: SingleLeaderWidget(follow.elementAt(index))),
                ),
                separatorBuilder: (context, index) => SizedBox(width: 10),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
