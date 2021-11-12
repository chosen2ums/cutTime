import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';
import 'package:salon/provider/artist_state_provider.dart';
import 'package:shape_of_view/shape_of_view.dart';

class PhotoWidget extends StatefulWidget {
  final File file;
  PhotoWidget(this.file, {Key key}) : super(key: key);

  @override
  _PhotoWidgetState createState() => _PhotoWidgetState();
}

class _PhotoWidgetState extends State<PhotoWidget> {
  @override
  Widget build(BuildContext context) {
    ArtistStateProvider val = Provider.of(context);
    return Stack(
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          height: double.infinity,
          child: ShapeOfView(
            shape: RoundRectShape(borderRadius: BorderRadius.circular(13)),
            child: Image.file(
              widget.file,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
        ),
        Positioned(
          top: 0,
          right: 15,
          child: IconButton(
            onPressed: () => val.removePhoto(widget.file),
            visualDensity: VisualDensity.compact,
            padding: EdgeInsets.zero,
            icon: Icon(
              Ionicons.close_circle,
              color: Colors.grey[200],
            ),
          ),
        ),
      ],
    );
  }
}
