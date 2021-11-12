import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';
import 'package:salon/provider/salon_provider.dart';
import 'package:salon/repository.dart';

import 'single_post_widget.dart';

class SalonPostsWidget extends StatefulWidget {
  SalonPostsWidget({Key key}) : super(key: key);

  @override
  _SalonPostsWidgetState createState() => _SalonPostsWidgetState();
}

class _SalonPostsWidgetState extends State<SalonPostsWidget> {
  @override
  Widget build(BuildContext context) {
    SalonProvider val = Provider.of(context);
    double cross = (MediaQuery.of(context).size.width / 2).floorToDouble();
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        childAspectRatio: 8 / 11,
        crossAxisSpacing: 1,
        mainAxisSpacing: 1,
        maxCrossAxisExtent: cross,
      ),
      shrinkWrap: true,
      cacheExtent: 1000000,
      itemCount: val.salon.posts.length,
      physics: ClampingScrollPhysics(),
      padding: EdgeInsets.zero,
      itemBuilder: (ctx, index) {
        return AnimationConfiguration.staggeredGrid(
          position: index,
          columnCount: val.salon.posts.length ~/ 2,
          child: FadeInAnimation(
            child: SinglePostWidget(
              val.salon.posts[index],
              val.salon.posts[index].photos
                  .map<Widget>(
                    (e) => CachedNetworkImage(
                      key: Key('${e.id}'),
                      imageUrl: e?.path ?? repo.empty,
                      height: double.infinity,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      filterQuality: FilterQuality.low,
                    ),
                  )
                  .toList(),
            ),
          ),
        );
      },
    );
  }
}
