import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';
import 'package:salon/models/category.dart';
import 'package:salon/models/service.dart';
import 'package:salon/provider/order_provider.dart';

import '../single_service_widget.dart';

class SelectServiceWidget extends StatefulWidget {
  SelectServiceWidget({Key key}) : super(key: key);

  @override
  _SelectServiceWidgetState createState() => _SelectServiceWidgetState();
}

class _SelectServiceWidgetState extends State<SelectServiceWidget> {
  @override
  Widget build(BuildContext context) {
    OrderProvider val = Provider.of(context);
    List<Service> services = val.category.id == 0
        ? val.order.services.last.services
        : val.order.services.last.services.where((e) => ((e.category?.parent) ?? 0) == ((val.category?.id) ?? 0)).toList();
    List<Category> categories = val.order.salon.categories ?? [];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.all(15),
          child: Text(
            'Үйлчилгээ',
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
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: ClampingScrollPhysics(),
          child: Row(children: List.generate(categories.length, (index) => singleCategory(categories.elementAt(index)))),
        ),
        SizedBox(height: 5),
        services.isEmpty
            ? Padding(
                padding: EdgeInsets.only(left: 15),
                child: Text("Үйлчилгээ олдсонгүй"),
              )
            : ListView.builder(
                itemCount: services.length,
                padding: EdgeInsets.fromLTRB(0, 5, 0, 10),
                cacheExtent: 999999,
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                itemBuilder: (context, index) => AnimationConfiguration.staggeredList(
                  position: index,
                  duration: Duration(milliseconds: 350),
                  child: FadeInAnimation(
                    child: SingleServiceWidget(
                      services.elementAt(index),
                      onTap: val.setService,
                      selected: val.order.services.last.service == services.elementAt(index),
                    ),
                  ),
                ),
              ),
      ],
    );
  }

  Widget singleCategory(Category category) {
    OrderProvider val = Provider.of(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: InkWell(
        onTap: () => val.setCategory(category),
        child: Container(
          padding: EdgeInsets.fromLTRB(5, 3, 5, 2),
          child: Text(
            category.engName,
            style: TextStyle(
              fontSize: 14,
              fontWeight: category == val.category ? FontWeight.bold : FontWeight.w400,
              color: Theme.of(context).hintColor.withOpacity(category == val.category ? 1 : 0.7),
            ),
          ),
        ),
      ),
    );
  }
}
