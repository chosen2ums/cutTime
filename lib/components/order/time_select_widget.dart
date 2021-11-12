import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salon/components/order/artist_of_salon_widget.dart';
import 'package:salon/provider/order_provider.dart';

import 'select_day_widget.dart';
import 'select_time_widget.dart';

class TimeSelectWidget extends StatefulWidget {
  TimeSelectWidget({Key key}) : super(key: key);

  @override
  _TimeSelectWidgetState createState() => _TimeSelectWidgetState();
}

class _TimeSelectWidgetState extends State<TimeSelectWidget> {
  @override
  Widget build(BuildContext context) {
    OrderProvider val = Provider.of(context);
    return Column(
      children: [
        ArtistOfSalonWidget(),
        SizedBox(height: 15),
        val.order.services.length > 1 ? Container() : SelectDayWidget(),
        SizedBox(height: val.order.services.length > 1 ? 0 : 15),
        SelectTimeWidget(),
        SizedBox(height: 20),
        val.order.services.last.begin != null
            ? Container(
                width: double.infinity,
                height: 40,
                margin: EdgeInsets.symmetric(horizontal: 15),
                child: TextButton(
                  onPressed: val.order.services.length != 1 ? val.postDetail : val.setState,
                  style: ButtonStyle(
                    visualDensity: VisualDensity.compact,
                    backgroundColor: MaterialStateProperty.all(
                      Theme.of(context).colorScheme.secondary,
                    ),
                    foregroundColor: MaterialStateProperty.all(Colors.white),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                    ),
                  ),
                  child: Text(
                    val.order.services.length != 1 ? 'Үйлчилгээ нэмэх' : 'Захиалга үүсгэх',
                  ),
                ),
              )
            : Container(),
        SizedBox(height: 20),
      ],
    );
  }
}
