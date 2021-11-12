import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';
import 'package:salon/components/single_salon_widget.dart';
import 'package:salon/models/salon.dart';
import 'package:salon/provider/order_provider.dart';
import 'package:salon/repository.dart';

class SalonSelectWidget extends StatefulWidget {
  SalonSelectWidget({Key key}) : super(key: key);

  @override
  _SalonSelectWidgetState createState() => _SalonSelectWidgetState();
}

class _SalonSelectWidgetState extends State<SalonSelectWidget> {
  @override
  Widget build(BuildContext context) {
    OrderProvider val = Provider.of(context);
    List<Salon> salons = val.filtered.where((e) => (e.artists ?? []).length > 0).toList();
    salons.sort((a, b) => a.compareTo(b));
    double width = MediaQuery.of(context).size.width * 0.6;
    double height = width * 0.7;
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Салон',
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
              InkWell(
                onTap: () async {
                  Salon selectedsalon = await repo.app.navi.pushNamed('/MoreSalon', arguments: true);
                  if (selectedsalon != null) val.setSalon(selectedsalon);
                },
                child: Text(
                  'more',
                  style: TextStyle(color: Theme.of(context).colorScheme.secondaryVariant),
                ),
              )
            ],
          ),
        ),
        Container(
          height: height + 5,
          margin: EdgeInsets.only(bottom: 15),
          child: ListView.separated(
            itemCount: salons.length,
            physics: BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.fromLTRB(10, 0, 10, 5),
            itemBuilder: (context, index) => AnimationConfiguration.staggeredList(
              position: index,
              child: SlideAnimation(
                horizontalOffset: 50,
                child: FadeInAnimation(
                  child: SingleSalonWidget(
                    salons.elementAt(index),
                    access: 0,
                    img: width / 2,
                    onTap: val.setSalon,
                    size: Size(width, height),
                    selected: (val.order.salon?.id ?? -1) == salons.elementAt(index).id,
                  ),
                ),
              ),
            ),
            separatorBuilder: (context, index) => SizedBox(width: 2),
          ),
        ),
      ],
    );
  }
}
