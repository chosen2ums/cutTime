import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salon/components/order/order_confirmation.dart';
import 'package:salon/helper/helper.dart';
import 'package:salon/helper/loading.dart';
import 'package:salon/models/order.dart';
import 'package:salon/provider/app_provider.dart' as app;
import 'package:salon/provider/order_provider.dart';

import 'selected_service_widget.dart';
import 'service_select_widget.dart';
import 'time_select_widget.dart';

class NewOrderWidget extends StatelessWidget {
  final Order order;
  final Function change;
  NewOrderWidget({
    this.order,
    this.change,
    Key key,
  }) : super(key: key);

  Widget build(BuildContext context) {
    app.AppProvider provider = Provider.of(context);
    return ChangeNotifierProvider(
      create: (_) => OrderProvider.instance(
        order,
        context: context,
        categories: provider.categories,
        salons: provider.salons.where((e) => e.isDone).toList(),
      ),
      child: Consumer<OrderProvider>(
        builder: (context, val, child) {
          return AnimatedSwitcher(
            duration: Duration(milliseconds: 300),
            transitionBuilder: (child, animation) => SlideTransition(
              position: Tween<Offset>(
                begin: Offset(0, 1),
                end: Offset(0, 0),
              ).animate(animation),
              child: child,
            ),
            child: !val.confirmState
                ? WillPopScope(
                    onWillPop: Helper.of(context).onWillPop,
                    child: Stack(
                      children: [
                        SingleChildScrollView(
                          child: Column(
                            children: [
                              SizedBox(height: 30),
                              AnimatedSwitcher(
                                duration: Duration(milliseconds: 300),
                                transitionBuilder: (child, animation) => SizeTransition(
                                  sizeFactor: animation,
                                  child: child,
                                ),
                                child: val.order.services.last.service != null
                                    ? SelectedServiceWidget(val.order.services.last.service)
                                    : ServiceSelectWidget(),
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
                    ),
                  )
                : OrderConfirmation(change),
          );
        },
      ),
    );
  }
}
