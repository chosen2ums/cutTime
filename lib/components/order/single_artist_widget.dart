import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:salon/models/artist.dart';
import 'package:salon/repository.dart';
import 'package:shape_of_view/shape_of_view.dart';

typedef Value = Function(Artist);

class SingleArtistWidget extends StatefulWidget {
  final Artist artist;
  final bool selected;
  final Value onTap;
  SingleArtistWidget(this.artist, {this.onTap, this.selected, Key key}) : super(key: key);

  @override
  _SingleArtistWidgetState createState() => _SingleArtistWidgetState();
}

class _SingleArtistWidgetState extends State<SingleArtistWidget> {
  @override
  Widget build(BuildContext context) {
    String title;
    Color color = Colors.white;

    if (widget.artist.isFollow) {
      title = 'Following';
      color = Theme.of(context).colorScheme.secondary;
    } else if (widget.artist.history != 0) {
      title = 'Recent';
      color = Theme.of(context).colorScheme.secondaryVariant;
    }

    if (widget.selected) color = Theme.of(context).colorScheme.secondary;

    return InkWell(
      onTap: () => widget.onTap(widget.artist),
      child: Container(
        width: 65,
        child: Stack(
          children: [
            Positioned(
              left: 0,
              right: 0,
              top: 0,
              child: ShapeOfView(
                shape: CircleShape(
                  borderColor: color,
                  borderWidth: widget.selected ? 2 : 1,
                ),
                child: CachedNetworkImage(
                  imageUrl: widget.artist.avatar?.path ?? repo.empty,
                  fit: BoxFit.cover,
                  height: 65,
                  width: 65,
                ),
              ),
            ),
            title != null
                ? Positioned(
                    top: 55,
                    left: 5,
                    right: 5,
                    child: Container(
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 3),
                      child: Text(
                        title,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: 10),
                      ),
                    ),
                  )
                : Container(),
            Positioned(
              top: 75,
              bottom: 0,
              right: 0,
              left: 0,
              child: Text(
                widget.artist.name,
                maxLines: 2,
                softWrap: true,
                textAlign: TextAlign.center,
                style: TextStyle(
                  height: 1,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: widget.selected ? color : Theme.of(context).hintColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
