import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:provider/provider.dart';
import 'package:salon/components/salon_about_widget.dart';
import 'package:salon/components/salon_posts_widget.dart';
import 'package:salon/components/salon_sliver_appbar.dart';
import 'package:salon/components/sliver_persistent_header.dart';
import 'package:salon/helper/error.dart';
import 'package:salon/helper/loading.dart';
import 'package:salon/models/category.dart';
import 'package:salon/models/salon.dart';
import 'package:salon/provider/salon_provider.dart';
import 'package:salon/repository.dart';

import 'salon_services_widget.dart';

class SalonWidget extends StatefulWidget {
  final Salon salon;
  SalonWidget(
    this.salon, {
    Key key,
  }) : super(key: key);

  @override
  _SalonWidgetState createState() => _SalonWidgetState();
}

class _SalonWidgetState extends State<SalonWidget> with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: ChangeNotifierProvider(
        create: (_) => SalonProvider.instance(
          widget.salon,
          vsync: this,
        ),
        child: Consumer<SalonProvider>(
          builder: (context, value, child) {
            switch (value.stat) {
              case Stat.Loading:
                return Loading(20);
                break;
              case Stat.Error:
                return Error(detail: 'Server');
                break;
              case Stat.Undone:
                return Error(detail: 'This action doesnt allowed');
                break;
              case Stat.Done:
                return child;
                break;
              default:
                return Loading(20);
            }
          },
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            body: Consumer<SalonProvider>(
              builder: (context, value, child) {
                List<Category> categories = value.salon.categories.where((e) => e.level == 2).toList();
                Widget _child = value.tabindex == 0
                    ? SalonPostsWidget()
                    : value.tabindex == 1
                        ? Container()
                        :
                        // SalonProductsWidget(),
                        SalonAboutWidget();
                return CustomScrollView(controller: value.scrollcontroller, slivers: [
                  SalonSliverAppbar(widget.salon),
                  SliverPersistentHeader(
                    pinned: true,
                    delegate: MySliverPersistentHeaderDelegate(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      tabBar: TabBar(
                        controller: value.controller,
                        labelPadding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                        labelColor: Theme.of(context).colorScheme.secondary,
                        labelStyle: TextStyle(fontSize: 16),
                        unselectedLabelColor: Theme.of(context).hintColor.withOpacity(0.8),
                        indicator: UnderlineTabIndicator(borderSide: BorderSide.none),
                        onTap: value.onTabSelected,
                        tabs: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                                padding: EdgeInsets.only(left: 15),
                                child: Text(
                                  'нийтлэл ${value.salon.posts.length}',
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                                )),
                          ),
                          Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'үйлчилгээ ${value.salon.services.length}',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                              )),
                          // Text('Бүтээгдэхүүн'),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Padding(
                              padding: EdgeInsets.only(right: 15),
                              child: Text(
                                'дэлгэрэнгүй',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  value.tabindex == 1
                      ? SliverStickyHeader(
                          header: Container(
                            height: 38,
                            color: Theme.of(context).scaffoldBackgroundColor,
                            child: ListView.separated(
                              shrinkWrap: true,
                              padding: EdgeInsets.symmetric(horizontal: 5),
                              itemCount: categories.length,
                              scrollDirection: Axis.horizontal,
                              physics: AlwaysScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                Category category = categories.elementAt(index);
                                return InkWell(
                                  onTap: () => value.selectCategory(category),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: 10),
                                    alignment: Alignment.center,
                                    child: Text(
                                      category.monName ?? category.engName,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: category == value.category ? FontWeight.w600 : FontWeight.w400,
                                        color: Theme.of(context).hintColor.withOpacity(category == value.category ? 1 : 0.7),
                                      ),
                                    ),
                                  ),
                                );
                              },
                              separatorBuilder: (context, index) => SizedBox(width: 10),
                            ),
                          ),
                          sliver: SalonServicesWidget(),
                        )
                      : SliverToBoxAdapter(child: _child),
                ]);
              },
            ),
          ),
        ),
      ),
    );
  }
}
