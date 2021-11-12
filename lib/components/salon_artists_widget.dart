import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salon/components/order/single_artist_widget.dart';
import 'package:salon/provider/app_provider.dart' as app;
import 'package:salon/provider/salon_provider.dart';

class SalonArtistsWidget extends StatefulWidget {
  SalonArtistsWidget({Key key}) : super(key: key);

  @override
  _SalonArtistsWidgetState createState() => _SalonArtistsWidgetState();
}

class _SalonArtistsWidgetState extends State<SalonArtistsWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 10,
          ),
          child: Text(
            "Артистууд",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).hintColor.withOpacity(0.8),
            ),
          ),
        ),
        buildEmployeesWidget(),
      ],
    );
  }

  Widget buildEmployeesWidget() {
    app.AppProvider provider = Provider.of(context);
    SalonProvider val = Provider.of(context);
    if (val.salon.artists.length == 0) {
      return Padding(
        padding: EdgeInsets.only(left: 15),
        child: Text(
          "Артист олдсонгүй",
          style: TextStyle(
            color: Theme.of(context).hintColor.withOpacity(0.6),
            fontSize: 13,
          ),
        ),
      );
    } else
      return Container(
        height: 115,
        width: double.infinity,
        child: ListView.separated(
          padding: EdgeInsets.symmetric(horizontal: 10),
          scrollDirection: Axis.horizontal,
          itemCount: val.salon.artists.length,
          cacheExtent: 999999,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () => provider.showArtist(
                context,
                val.salon.artists.elementAt(index),
              ),
              child: SingleArtistWidget(
                val.salon.artists.elementAt(index),
                onTap: (val) => print(val.name),
                selected: false,
              ),
            );
          },
          separatorBuilder: (context, index) => SizedBox(width: 15),
        ),
      );
  }
}
