import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salon/models/media.dart';
import 'package:salon/models/post.dart';
import 'package:salon/provider/app_provider.dart' as app;
import 'package:salon/repository.dart';
import 'package:shape_of_view/shape_of_view.dart';
import 'package:timeago/timeago.dart' as time;
import 'package:transparent_image/transparent_image.dart';

class PostPhoto extends StatefulWidget {
  final String timeago;
  final Post post;
  final int access;
  PostPhoto(this.post, {this.access}) : timeago = time.format(post.created, locale: 'mn');

  @override
  _PostPhotoState createState() => _PostPhotoState();
}

class _PostPhotoState extends State<PostPhoto> {
  int currentPage = 0;

  final PageController ctrl = PageController(viewportFraction: 1);

  @override
  void initState() {
    super.initState();
    ctrl.addListener(() {
      int next = ctrl.page.round();

      if (currentPage != next) {
        if (this.mounted)
          setState(() {
            currentPage = next;
          });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    app.AppProvider provider = Provider.of(context);
    return Container(
      height: MediaQuery.of(context).size.width * 1.4,
      width: MediaQuery.of(context).size.width,
      child: Stack(
        children: [
          PageView.builder(
            controller: ctrl,
            itemCount: widget.post.photos.length,
            itemBuilder: (context, int currentIdx) {
              bool active = currentIdx == currentPage;
              return _buildStoryPage(
                widget.post.photos[currentIdx],
                active,
                widget.post.photos.length,
                currentIdx + 1,
              );
            },
          ),
          Positioned(
            top: 5,
            left: 10,
            child: InkWell(
              onTap: () => widget.access == 0 ? null : provider.showPostOwner(context, widget.post.owner),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black38,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: <Widget>[
                    ShapeOfView(
                      shape: CircleShape(),
                      child: CachedNetworkImage(
                        key: Key('${widget.post.owner.logo?.id}'),
                        imageUrl: widget.post.owner.logo?.path ?? repo.empty,
                        fit: BoxFit.cover,
                        height: 40,
                        width: 40,
                      ),
                    ),
                    SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          widget.post.owner.name,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          widget.timeago,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white60,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStoryPage(Media data, bool active, int lngth, int indx) {
    return Stack(
      children: [
        InkWell(
          onTap: () {},
          child: Hero(
            tag: data.id,
            child: CachedNetworkImage(
              imageUrl: data.path,
              placeholder: (context, url) => Image.memory(kTransparentImage),
              height: MediaQuery.of(context).size.width * 1.4,
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.cover,
            ),
          ),
        ),
        lngth > 1
            ? Positioned(
                top: 5,
                right: 5,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    color: Colors.black38,
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  child: Text(
                    "$indx/$lngth",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
              )
            : Container(),
      ],
    );
  }
}
