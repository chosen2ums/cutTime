import 'package:flutter/material.dart';
import 'package:salon/models/category.dart';
import 'package:salon/models/salon.dart';
import 'package:salon/models/service.dart';
import 'package:salon/repository.dart';

class SalonProvider with ChangeNotifier {
  Stat stat;
  Salon salon;
  TabController controller;
  ScrollController scrollcontroller;
  SingleTickerProviderStateMixin vsync;
  SalonProvider.instance(
    this.salon, {
    this.vsync,
  })  : stat = Stat.Loading,
        controller = TabController(length: 3, vsync: vsync, initialIndex: 0),
        scrollcontroller = ScrollController() {
    conf();
  }
  double depend = 0;
  Category category;
  Service service;

  int tabindex = 0;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  selectCategory(category) {
    this.category = category;
    notifyListeners();
  }

  selectService(service) {
    this.service = service;
    notifyListeners();
  }

  bool get isSliverAppBarExpanded {
    return scrollcontroller.hasClients && scrollcontroller.offset > (220 - kToolbarHeight);
  }

  listener() {
    depend = scrollcontroller.offset;
    notifyListeners();
  }

  onTabSelected(int index) {
    controller.animateTo(index);
    scrollcontroller.animateTo(
      0,
      curve: Curves.ease,
      duration: Duration(milliseconds: 200),
    );
  }

  tabListener() {
    if (controller.index != tabindex) setTabIndex(controller.index);
  }

  setTabIndex(val) {
    tabindex = val;
    notifyListeners();
  }

  conf() async {
    scrollcontroller..addListener(listener);
    if (salon == null)
      stat = Stat.Error;
    else {
      if (!salon.isDone)
        stat = Stat.Undone;
      else {
        await salon.getData();
        selectCategory(salon.categories.first);
        stat = Stat.Done;
      }
    }
    controller.addListener(tabListener);
    notifyListeners();
  }
}
