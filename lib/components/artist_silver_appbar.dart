import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';
import 'package:salon/models/artist.dart';
import 'package:salon/provider/artist_provider.dart';
import 'package:salon/repository.dart';
import 'package:shape_of_view/shape_of_view.dart';

class ArtistSliverAppbar extends StatefulWidget {
  final Artist artist;
  ArtistSliverAppbar(this.artist, {Key key}) : super(key: key);

  @override
  _ArtistSliverAppbarState createState() => _ArtistSliverAppbarState();
}

class _ArtistSliverAppbarState extends State<ArtistSliverAppbar> {
  @override
  Widget build(BuildContext context) {
    ArtistProvider value = Provider.of(context);
    return SliverAppBar(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      expandedHeight: 220,
      elevation: 0,
      pinned: true,
      floating: true,
      centerTitle: false,
      leading: Padding(
        padding: EdgeInsets.only(left: 10),
        child: InkWell(
          onTap: () => repo.app.navi.pop(),
          child: Icon(Ionicons.arrow_back_outline),
        ),
      ),
      leadingWidth: 35,
      automaticallyImplyLeading: false,
      title: value.isSliverAppBarExpanded
          ? Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ShapeOfView(
                  shape: CircleShape(),
                  child: CachedNetworkImage(
                    imageUrl: value.artist.avatar?.path ?? repo.empty,
                    fit: BoxFit.cover,
                    height: 40,
                    width: 40,
                  ),
                ),
                SizedBox(width: 10),
                Text(
                  value.artist.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Spacer(),
                ShapeOfView(
                  shape: RoundRectShape(
                    borderColor: Theme.of(context).colorScheme.secondary,
                    borderRadius: BorderRadius.circular(10),
                    borderWidth: 2,
                  ),
                  elevation: 0,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        widget.artist.follow().then((val) => setState(() {}));
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: widget.artist.isFollow
                            ? Theme.of(context).colorScheme.secondary
                            : Colors.transparent,
                      ),
                      width: 90,
                      padding: EdgeInsets.symmetric(vertical: 5),
                      alignment: Alignment.center,
                      child: Text(
                        '${widget.artist.isFollow ? 'following' : 'follow'}',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: widget.artist.isFollow
                              ? Colors.white
                              : Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )
          : Container(),
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          padding: EdgeInsets.only(bottom: value.depend * 0.5),
          margin: EdgeInsets.only(bottom: 30),
          child: Stack(
            children: [
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                bottom: 50,
                child: CachedNetworkImage(
                  imageUrl: value.artist.salon.cover?.path ?? repo.empty,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                left: 40 + (value.depend / 220) * 35,
                right: 10,
                bottom: 0,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        bottom: (value.depend / 220) * kToolbarHeight,
                      ),
                      child: ShapeOfView(
                        shape: CircleShape(),
                        child: CachedNetworkImage(
                          imageUrl: value.artist.avatar?.path ?? repo.empty,
                          fit: BoxFit.cover,
                          height: 100 - (value.depend / 220) * 70,
                          width: 100 - (value.depend / 220) * 70,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(
                            bottom: (value.depend / 220) * kToolbarHeight + 5,
                            left: 10),
                        child: Text(
                          value.artist.name,
                          maxLines: 2,
                          overflow: TextOverflow.visible,
                          softWrap: true,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 50,
                right: 10,
                child: Padding(
                  padding: EdgeInsets.only(
                    bottom: (value.depend / 220) * kToolbarHeight + 13,
                  ),
                  child: ShapeOfView(
                    shape: RoundRectShape(
                      borderColor: Theme.of(context).colorScheme.secondary,
                      borderRadius: BorderRadius.circular(10),
                      borderWidth: 2,
                    ),
                    elevation: 0,
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          widget.artist.follow().then((val) => setState(() {}));
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: widget.artist.isFollow
                              ? Theme.of(context).colorScheme.secondary
                              : Colors.transparent,
                        ),
                        width: 90,
                        padding: EdgeInsets.symmetric(vertical: 5),
                        alignment: Alignment.center,
                        child: Text(
                          '${widget.artist.isFollow ? 'following' : 'follow'}',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: widget.artist.isFollow
                                ? Colors.white
                                : Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
