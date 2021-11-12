import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salon/models/order.dart';
import 'package:salon/provider/app_provider.dart' as app;

import 'single_order_widget.dart';

class OrderWidget extends StatefulWidget {
  final Function change;
  OrderWidget({this.change, Key key}) : super(key: key);

  @override
  _OrderWidgetState createState() => _OrderWidgetState();
}

class _OrderWidgetState extends State<OrderWidget> {
  String filter;
  @override
  Widget build(BuildContext context) {
    app.AppProvider provider = Provider.of(context);
    List<Order> orders = provider.orders.where((element) => element.status != 'creating').toList();
    if (filter != null) orders = orders.where((element) => element.status == filter).toList();
    if (filter != null && filter == 'pending')
      orders.sort(
        (a, b) => a.services.first.begin.compareTo(b.services.first.begin),
      );
    else
      orders.sort(
        (a, b) => b.services.first.begin.compareTo(a.services.first.begin),
      );
    return WillPopScope(
      onWillPop: () async {
        widget.change();
        return false;
      },
      child: Column(
        children: [
          SizedBox(height: 10),
          orders.isEmpty
              ? Text("Захиалга хоосон байна.")
              : Expanded(
                  child: ListView.separated(
                    shrinkWrap: true,
                    cacheExtent: 10000000,
                    itemCount: orders.length,
                    scrollDirection: Axis.vertical,
                    padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                    itemBuilder: (context, index) => SingleOrderWidget(orders.elementAt(index)),
                    separatorBuilder: (context, index) => SizedBox(height: 5),
                  ),
                ),
        ],
      ),
    );
  }
}
