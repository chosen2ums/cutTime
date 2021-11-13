import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';
import 'package:salon/provider/artist_provider.dart';
import 'package:salon/repository.dart';

import 'single_post_widget.dart';

class ArtistPostsWidget extends StatefulWidget {
  ArtistPostsWidget({Key key}) : super(key: key);

  @override
  _ArtistPostsWidgetState createState() => _ArtistPostsWidgetState();
}

class _ArtistPostsWidgetState extends State<ArtistPostsWidget> {
  @override
  Widget build(BuildContext context) {
    ArtistProvider val = Provider.of(context);
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
      itemCount: val.artist.posts.length,
      physics: ClampingScrollPhysics(),
      padding: EdgeInsets.zero,
      itemBuilder: (ctx, index) {
        return AnimationConfiguration.staggeredGrid(
          position: index,
          columnCount: val.artist.posts.length ~/ 2,
          child: FadeInAnimation(
            child: SinglePostWidget(
              val.artist.posts[index],
              val.artist.posts[index].photos
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
