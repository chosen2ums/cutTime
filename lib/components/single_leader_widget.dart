import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salon/models/follow.dart';
import 'package:salon/provider/app_provider.dart' as app;
import 'package:salon/repository.dart';
import 'package:shape_of_view/shape_of_view.dart';

class SingleLeaderWidget extends StatelessWidget {
  final Follow follow;
  SingleLeaderWidget(this.follow, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    app.AppProvider provider = Provider.of(context);
    return GestureDetector(
      onTap: () => follow.show(provider, context),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          ShapeOfView(
            shape: CircleShape(),
            child: CachedNetworkImage(
              imageUrl: follow.avatar?.path ?? repo.empty,
              fit: BoxFit.cover,
              width: 65,
              height: 65,
            ),
          ),
          SizedBox(height: 4),
          Text(
            follow.name.substring(0, 1).toUpperCase() + follow.name.substring(1).toLowerCase(),
            maxLines: 2,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Theme.of(context).hintColor),
          ),
          Text(
            follow.type.toLowerCase(),
            maxLines: 1,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.secondary),
          ),
        ],
      ),
    );
  }
}
