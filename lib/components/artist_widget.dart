import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salon/helper/loading.dart';
import 'package:salon/models/artist.dart';
import 'package:salon/provider/artist_provider.dart';
import 'package:salon/repository.dart';

class ArtistWidget extends StatefulWidget {
  final Artist artist;
  ArtistWidget(this.artist, {Key key}) : super(key: key);

  @override
  ArtistWidgetState createState() => ArtistWidgetState();
}

class ArtistWidgetState extends State<ArtistWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height - repo.statusBar,
      child: ChangeNotifierProvider(
        create: (_) => ArtistProvider.instance(widget.artist),
        child: Consumer<ArtistProvider>(
          builder: (context, value, child) {
            switch (value.stat) {
              case Stat.Loading:
                return Loading(20);
                break;
              case Stat.Error:
                return Loading(20);
                break;
              case Stat.Undone:
                return Loading(20);
                break;
              case Stat.Done:
                return child;
                break;
              default:
                return Loading(20);
            }
          },
          child: Material(
            child: Text('Done b'),
          ),
        ),
      ),
    );
  }
}
