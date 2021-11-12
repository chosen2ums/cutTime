import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';
import 'package:salon/models/post.dart';
import 'package:salon/provider/app_provider.dart' as app;
import 'package:salon/repository.dart';

import 'single_post_widget.dart';

class FavoriteWidget extends StatefulWidget {
  FavoriteWidget({Key key}) : super(key: key);

  @override
  _FavoriteWidgetState createState() => _FavoriteWidgetState();
}

class _FavoriteWidgetState extends State<FavoriteWidget> {
  List<Post> bookmarks = List.empty();

  @override
  Widget build(BuildContext context) {
    double cross = (MediaQuery.of(context).size.width / 2).floorToDouble();
    app.AppProvider provider = Provider.of(context);
    bookmarks = provider.posts.where((e) => e.isSaved == true).toList();
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 10),
          child: Text(
            'Favorites ${bookmarks.length}',
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
        bookmarks.length == 0
            ? Center(child: Text('empty'))
            : GridView.builder(
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  childAspectRatio: 8 / 11,
                  crossAxisSpacing: 2,
                  mainAxisSpacing: 2,
                  maxCrossAxisExtent: cross,
                ),
                shrinkWrap: true,
                cacheExtent: 1000000,
                itemCount: bookmarks.length,
                physics: ClampingScrollPhysics(),
                padding: EdgeInsets.only(top: 15),
                itemBuilder: (ctx, index) {
                  return AnimationConfiguration.staggeredGrid(
                    position: index,
                    columnCount: bookmarks.length ~/ 2,
                    child: FadeInAnimation(
                      child: SinglePostWidget(
                        bookmarks.elementAt(index),
                        bookmarks
                            .elementAt(index)
                            .photos
                            .map<Widget>(
                              (e) => CachedNetworkImage(
                                key: Key('${e.id}-$e'),
                                imageUrl: e?.path ?? repo.empty,
                                height: double.infinity,
                                width: double.infinity,
                                filterQuality: FilterQuality.low,
                                fit: BoxFit.cover,
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  );
                },
              ),
      ],
    );
  }
}
