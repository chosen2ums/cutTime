import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';
import 'package:salon/components/single_service_widget.dart';
import 'package:salon/models/category.dart';
import 'package:salon/models/order.dart';
import 'package:salon/models/service.dart';
import 'package:salon/provider/app_provider.dart' as app;
import 'package:salon/provider/salon_provider.dart';
import 'package:salon/repository.dart';

class SalonSingleCategoryWidget extends StatefulWidget {
  final Category category;
  final List<Service> services;
  SalonSingleCategoryWidget(
    this.category, {
    this.services,
    Key key,
  }) : super(key: key);

  @override
  _SalonSingleCategoryWidgetState createState() =>
      _SalonSingleCategoryWidgetState();
}

class _SalonSingleCategoryWidgetState extends State<SalonSingleCategoryWidget> {
  bool collapsed = false;
  void change() {
    setState(() {
      collapsed = !collapsed;
    });
  }

  @override
  Widget build(BuildContext context) {
    SalonProvider val = Provider.of(context);
    app.AppProvider provider = Provider.of(context);
    return Column(
      children: [
        InkWell(
          onTap: change,
          child: Padding(
            padding: EdgeInsets.fromLTRB(30, 10, 10, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.category.monName ??
                      widget.category.engName + " ${widget.services.length}",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context)
                        .hintColor
                        .withOpacity(collapsed ? 0.5 : 0.25),
                  ),
                ),
                Icon(
                  collapsed
                      ? Ionicons.chevron_up_outline
                      : Ionicons.chevron_down_outline,
                  color: Theme.of(context)
                      .colorScheme
                      .secondaryVariant
                      .withOpacity(0.5),
                )
              ],
            ),
          ),
        ),
        SizedBox(height: 5),
        collapsed
            ? ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                itemCount: widget.services.length,
                physics: ClampingScrollPhysics(),
                itemBuilder: (context, index) =>
                    AnimationConfiguration.staggeredList(
                  position: index,
                  duration: Duration(milliseconds: 200),
                  child: FadeInAnimation(
                    child: SingleServiceWidget(
                      widget.services.elementAt(index),
                      onTap: val.selectService,
                      checked: val.service == widget.services.elementAt(index),
                      order: (value) async {
                        Order order = Order(
                          client: repo.app.user,
                          salon: val.salon,
                          service: value,
                        );
                        provider.order(order);
                      },
                    ),
                  ),
                ),
              )
            : Container(),
      ],
    );
  }
}
