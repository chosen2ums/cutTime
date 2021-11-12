import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salon/components/single_salon_widget.dart';
import 'package:salon/models/salon.dart';
import 'package:salon/provider/filter_provider.dart';
import 'package:salon/repository.dart';

class SalonListWidget extends StatefulWidget {
  SalonListWidget({Key key}) : super(key: key);

  @override
  _SalonListWidgetState createState() => _SalonListWidgetState();
}

class _SalonListWidgetState extends State<SalonListWidget> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width * 0.8;
    FilterProvider filter = Provider.of(context);
    double height = width * 0.6;
    return Container(
      height: height,
      width: MediaQuery.of(context).size.width,
      child: PageView.builder(
        controller: filter.pageController,
        itemCount: filter.filtered.length,
        itemBuilder: (BuildContext context, int index) => salonWidget(
          filter.filtered.elementAt(index),
          index,
          Size(width, height),
        ),
      ),
    );
  }

  Widget salonWidget(Salon salon, int indx, Size size) {
    FilterProvider filter = Provider.of(context);
    return AnimatedBuilder(
      animation: filter.pageController,
      builder: (BuildContext context, Widget widget) {
        double right = 10;
        double left = 28;
        double top = 0;
        double bottom = 10;
        if (filter.pageController.position.haveDimensions) {
          right = indx == filter.pageController.page ? 10 : 20;
          left = indx == filter.pageController.page ? 28 : 20;
          top = indx == filter.pageController.page ? 0 : 8;
          bottom = indx == filter.pageController.page ? 10 : 8;
          double pageIndex = (filter.pageController.page - indx).abs();
          if (pageIndex > 1) pageIndex = 1 - pageIndex % 1;
          if (indx == filter.pageController.page) {
            right = 10;
            left = 28;
            top = 0;
            bottom = 10;
          } else {
            right = 10 + 10 * pageIndex;
            left = 28 - 8 * pageIndex;
            top = 0 + 8 * pageIndex;
            bottom = 10 - 2 * pageIndex;
          }
        }
        return Center(
          child: Container(
            margin: EdgeInsets.fromLTRB(left, top, right, bottom),
            child: SingleSalonWidget(
              salon,
              size: size,
              img: size.height * 0.7,
              color: Theme.of(context).colorScheme.background,
              onTap: (salon) {
                if (filter.canPop)
                  repo.app.navi.pop(salon);
                else
                  filter.setTargeted(targeted: indx + 1);
              },
            ),
          ),
        );
      },
    );
  }
}
