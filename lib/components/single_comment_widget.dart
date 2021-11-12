import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';
import 'package:salon/models/comment.dart';
import 'package:salon/provider/app_provider.dart' as app;
import 'package:salon/repository.dart';
import 'package:shape_of_view/shape_of_view.dart';
import 'package:timeago/timeago.dart' as time;

typedef Value = dynamic Function(Comment);

class SingleCommentWidget extends StatefulWidget {
  final Comment comment;
  final String timeago;
  final Value delete;
  SingleCommentWidget(this.comment, {this.delete})
      : timeago = time.format(comment.created, locale: 'mn');
  @override
  _SingleCommentWidgetState createState() => _SingleCommentWidgetState();
}

class _SingleCommentWidgetState extends State<SingleCommentWidget> {
  int maxlines = 2;

  handleShow() {
    setState(() {
      if (maxlines == 2)
        maxlines = 30;
      else
        maxlines = 2;
    });
  }

  @override
  Widget build(BuildContext context) {
    app.AppProvider provider = Provider.of(context);
    return InkWell(
      onTap: handleShow,
      child: Padding(
        padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
        child: Row(
          children: [
            ShapeOfView(
              shape: CircleShape(
                borderWidth: 1,
                borderColor: Colors.white,
              ),
              child: CachedNetworkImage(
                width: 40,
                height: 40,
                imageUrl: widget.comment.owner.avatar?.path ?? repo.empty,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${widget.comment.owner.name}',
                    style: TextStyle(
                      color: Theme.of(context).hintColor.withOpacity(0.4),
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    '${widget.comment.comment}'.trim(),
                    maxLines: maxlines,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      color: Theme.of(context).hintColor.withOpacity(0.8),
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            widget.comment.owner.id == provider.user.id
                ? IconButton(
                    onPressed: () => widget.delete(widget.comment),
                    icon: Icon(Ionicons.remove_circle_outline),
                    color: Colors.red[200],
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
