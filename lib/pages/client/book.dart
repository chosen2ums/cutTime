import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salon/components/order/new_order_widget.dart';
import 'package:salon/components/order_widget.dart';
import 'package:salon/models/order.dart';
import 'package:salon/provider/app_provider.dart' as app;
import 'package:salon/repository.dart';

// ignore: must_be_immutable
class Book extends StatefulWidget {
  Book({Key key}) : super(key: key);

  @override
  _BookState createState() => _BookState();
}

class _BookState extends State<Book> with SingleTickerProviderStateMixin {
  Order order;
  TabController controller;

  void switchTab() => controller.animateTo(
        (controller.index - 1).abs(),
        duration: Duration(milliseconds: 200),
        curve: Curves.easeInOut,
      );

  @override
  void initState() {
    controller = TabController(initialIndex: 0, vsync: this, length: 2);
    order = repo.app.demoorder ?? Order(client: repo.app.user);
    repo.app.demoorder = null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    app.AppProvider provider = Provider.of(context);
    return Material(
      child: Column(
        children: [
          SizedBox(height: repo.statusBar),
          provider.lock
              ? Container()
              : TabBar(
                  controller: controller,
                  physics: provider.lock ? NeverScrollableScrollPhysics() : AlwaysScrollableScrollPhysics(),
                  labelPadding: EdgeInsets.symmetric(vertical: 12),
                  labelColor: Theme.of(context).colorScheme.secondary,
                  indicatorColor: Theme.of(context).colorScheme.secondary,
                  labelStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                  unselectedLabelColor: Theme.of(context).hintColor.withOpacity(0.5),
                  indicatorWeight: 1.2,
                  tabs: [
                    Text('Шинэ захиалга'),
                    Text('Захиалгын түүх'),
                  ],
                ),
          Expanded(
            child: TabBarView(
              controller: controller,
              physics: provider.lock ? NeverScrollableScrollPhysics() : AlwaysScrollableScrollPhysics(),
              children: [
                NewOrderWidget(
                  order: order,
                  change: switchTab,
                ),
                OrderWidget(change: switchTab),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
