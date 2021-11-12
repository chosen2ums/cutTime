import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salon/models/order.dart';
import 'package:salon/provider/order_provider.dart';

import 'artist_select_widget.dart';
import 'salon_select_widget.dart';
import 'select_service_widget.dart';

class ServiceSelectWidget extends StatefulWidget {
  ServiceSelectWidget({Key key}) : super(key: key);

  @override
  _ServiceSelectWidgetState createState() => _ServiceSelectWidgetState();
}

class _ServiceSelectWidgetState extends State<ServiceSelectWidget> {
  @override
  Widget build(BuildContext context) {
    OrderProvider val = Provider.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Visibility(
          visible: val.order.type != Type.SALON,
          child: SalonSelectWidget(),
        ),
        ArtistSelectWidget(),
        AnimatedSwitcher(
          duration: Duration(milliseconds: 250),
          transitionBuilder: (child, animation) => SizeTransition(
            sizeFactor: animation,
            child: child,
          ),
          child: val.order.salon != null ? SelectServiceWidget() : Container(),
        ),
      ],
    );
  }
}
