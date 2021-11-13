import 'package:flutter/material.dart';
import 'package:salon/models/artist.dart';
import 'package:salon/models/category.dart';
import 'package:salon/models/service.dart';
import 'package:salon/repository.dart';

class ArtistProvider with ChangeNotifier {
  Artist artist;
  Stat stat;

  TabController controller;
  ScrollController scrollcontroller;
  SingleTickerProviderStateMixin vsync;

  ArtistProvider.instance(
    this.artist, {
    this.vsync,
  })  : stat = Stat.Loading,
        controller = TabController(length: 2, vsync: vsync, initialIndex: 0),
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
    return scrollcontroller.hasClients &&
        scrollcontroller.offset > (220 - kToolbarHeight);
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

    if (artist == null)
      stat = Stat.Error;
    else {
      if (!artist.isDone)
        stat = Stat.Undone;
      else {
        await artist.getData();
        //selectCategory(artist.categories.first);
        stat = Stat.Done;
      }
    }
    controller.addListener(tabListener);
    notifyListeners();
  }
}
