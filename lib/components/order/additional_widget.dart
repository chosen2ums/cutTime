import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salon/components/order/select_service_widget.dart';
import 'package:salon/helper/loading.dart';
import 'package:salon/provider/order_provider.dart';

import 'selected_salon_widget.dart';
import 'selected_service_widget.dart';
import 'time_select_widget.dart';

class AdditionalWidget extends StatefulWidget {
  AdditionalWidget({Key key}) : super(key: key);

  @override
  _AdditionalWidgetState createState() => _AdditionalWidgetState();
}

class _AdditionalWidgetState extends State<AdditionalWidget> {
  @override
  Widget build(BuildContext context) {
    OrderProvider val = Provider.of(context);
    return Stack(
      children: [
        SingleChildScrollView(
          child: Column(
            children: [
              AnimatedSwitcher(
                duration: Duration(milliseconds: 300),
                transitionBuilder: (child, animation) => FadeTransition(
                  opacity: Tween(begin: 0.0, end: 1.0).animate(animation),
                  child: child,
                ),
                child: val.order.services.last.service != null ? SelectedServiceWidget(val.order.services.last.service) : SelectedSalonWidget(),
              ),
              AnimatedSwitcher(
                duration: Duration(milliseconds: 300),
                transitionBuilder: (child, animation) => SizeTransition(
                  sizeFactor: animation,
                  child: child,
                ),
                child: val.order.services.last.service != null ? Container() : SelectServiceWidget(),
              ),
              AnimatedSwitcher(
                duration: Duration(milliseconds: 300),
                transitionBuilder: (child, animation) => SizeTransition(
                  sizeFactor: animation,
                  child: child,
                ),
                child: val.order.services.last.service != null ? TimeSelectWidget() : Container(),
              ),
            ],
          ),
        ),
        val.loading
            ? Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                top: 0,
                child: ColoredBox(
                  color: Colors.black12,
                  child: Loading(20),
                ),
              )
            : Container(),
      ],
    );
  }
}
