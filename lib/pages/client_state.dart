import 'dart:math';

import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';
import 'package:salon/components/not_found_widget.dart';
import 'package:salon/pages/client/book.dart';
import 'package:salon/pages/client/home.dart';
import 'package:salon/pages/client/nearby.dart';
import 'package:salon/pages/client/profile.dart';
// import 'package:salon/pages/client/shop.dart';
import 'package:salon/provider/app_provider.dart' as app;
import 'package:salon/provider/home_provider.dart';
import 'package:salon/repository.dart';

class Client extends StatefulWidget {
  @override
  _ClientState createState() => _ClientState();
}

class _ClientState extends State<Client> {
  int page = 0;
  Widget child;

  nomad(page) {
    if (this.mounted)
      setState(
        () {
          this.page = page;
          switch (page) {
            case 0:
              child = Home();
              break;
            case 1:
              child = Book();
              break;
            case 2:
              child = Nearby();
              break;
            //TODO Inventory waiter

            // case 3:
            //   child = Shop();
            //   break;
            case 3:
              child = Profile();
              break;
            default:
              child = NotFoundWidget();
          }
        },
      );
  }

  pageListener(val) {
    if (val is int) {
      nomad(val);
      repo.app.storage.remove('page');
    }
  }

  @override
  void initState() {
    child = Home();
    repo.app.clientStateCreated();
    repo.app.storage.listenKey('page', pageListener);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    repo.statusBar = MediaQuery.of(context).padding.top;
    app.AppProvider provider = Provider.of(context);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => HomeProvider.instance()),
      ],
      child: Scaffold(
        body: this.child,
        resizeToAvoidBottomInset: true,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Theme.of(context).colorScheme.secondary,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          selectedFontSize: 14,
          unselectedFontSize: 14,
          iconSize: 25,
          elevation: 0,
          selectedIconTheme: IconThemeData(size: 25),
          unselectedItemColor: Theme.of(context).hintColor,
          currentIndex: this.page,
          onTap: provider.lock ? null : this.nomad,
          selectedLabelStyle: TextStyle(fontWeight: FontWeight.w300),
          unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w300),
          items: [
            BottomNavigationBarItem(
              // icon: Image.asset('assets/img/home${page == 0 ? '_selected' : ''}.png', height: 26),
              icon: Transform.rotate(angle: 90 * pi / 180, child: Icon(page == 0 ? Ionicons.albums : Ionicons.albums_outline)),
              label: 'тренд',
            ),
            BottomNavigationBarItem(
              // icon: Image.asset('assets/img/list-view${page == 2 ? '_selected' : ''}.png', height: 26),
              icon: Icon(page == 1 ? Ionicons.calendar : Ionicons.calendar_outline),
              label: 'захиалга',
            ),
            BottomNavigationBarItem(
              // icon: Image.asset('assets/img/track${page == 1 ? '_selected' : ''}.png', height: 26),
              icon: Icon(page == 2 ? Ionicons.radio : Ionicons.radio_outline),
              label: 'ойрхон',
            ),

            // BottomNavigationBarItem(
            //   icon: Icon(page == 3
            //       ? Ionicons.storefront
            //       : Ionicons.storefront_outline),
            //   label: 'Shop',
            // ),
            BottomNavigationBarItem(
              // icon: Image.asset('assets/img/boy${page == 3 ? '_selected' : ''}.png', height: 26),
              icon: Icon(page == 3 ? Ionicons.options : Ionicons.options_outline),
              label: 'миний',
            ),
          ],
        ),
      ),
    );
  }
}
