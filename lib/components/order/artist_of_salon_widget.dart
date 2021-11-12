import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';
import 'package:salon/components/order/single_artist_widget.dart';
import 'package:salon/provider/order_provider.dart';

class ArtistOfSalonWidget extends StatefulWidget {
  ArtistOfSalonWidget({Key key}) : super(key: key);

  @override
  _ArtistOfSalonWidgetState createState() => _ArtistOfSalonWidgetState();
}

class _ArtistOfSalonWidgetState extends State<ArtistOfSalonWidget> {
  @override
  Widget build(BuildContext context) {
    OrderProvider val = Provider.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.all(15),
          child: Text(
            'Артист',
            style: TextStyle(
              color: Theme.of(context).hintColor.withOpacity(0.75),
              fontSize: 16,
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
        Container(
          height: 110,
          margin: EdgeInsets.only(bottom: 15),
          child: ListView.separated(
            itemCount: val.order.services.last.artists.length,
            physics: BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.fromLTRB(15, 0, 15, 5),
            itemBuilder: (context, index) =>
                AnimationConfiguration.staggeredList(
              position: index,
              duration: Duration(milliseconds: 500),
              child: FadeInAnimation(
                child: SingleArtistWidget(
                  val.order.services.last.artists.elementAt(index),
                  onTap: val.updateArtist,
                  selected: (val.order.services.last.artist?.id ?? -1) ==
                      val.order.services.last.artists.elementAt(index).id,
                ),
              ),
            ),
            separatorBuilder: (context, index) => SizedBox(width: 15),
          ),
        ),
      ],
    );
  }
}
