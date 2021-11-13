import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';
import 'package:salon/components/not_found_widget.dart';
import 'package:salon/helper/helper.dart';
import 'package:salon/helper/loading.dart';
import 'package:salon/pages/artist/appointment.dart';
import 'package:salon/pages/artist/artist_account.dart';
import 'package:salon/pages/artist/manage.dart';
import 'package:salon/provider/artist_state_provider.dart';
import 'package:salon/repository.dart';

class Artist extends StatefulWidget {
  @override
  _ArtistState createState() => _ArtistState();
}

class _ArtistState extends State<Artist> {
  int page = 0;
  Widget child;

  nomad(page, ArtistStateProvider value) {
    if (page != this.page) {
      this.page = page;
      switch (page) {
        case 0:
          child = Appointment();
          break;
        case 1:
          child = Manage();
          break;
        case 2:
          value.me.salon?.services?.sort((a, b) => b.mine ? 1 : -1);
          child = ArtistAccount();
          break;
        default:
          child = NotFoundWidget();
      }
      if (this.mounted) setState(() {});
    }
  }

  @override
  void initState() {
    repo.artistApp.stateRun();
    child = Appointment();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    repo.statusBar = MediaQuery.of(context).padding.top;
    ArtistStateProvider val = Provider.of(context);
    return WillPopScope(
      onWillPop: Helper.of(context).onWillPop,
      child: Scaffold(
        body: Stack(
          children: [
            Center(child: this.child),
            val.loading
                ? SafeArea(
                    child: Container(
                      alignment: Alignment.center,
                      color: Colors.black12,
                      child: Loading(15),
                    ),
                  )
                : Container(),
          ],
        ),
        resizeToAvoidBottomInset: true,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        bottomNavigationBar: SizedBox(
          height: 100,
          child: BottomNavigationBar(
            type: BottomNavigationBarType.shifting,
            selectedItemColor: Theme.of(context).colorScheme.secondary,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            selectedFontSize: 14,
            unselectedFontSize: 12,
            iconSize: 22,
            elevation: 0,
            selectedIconTheme: IconThemeData(size: 27),
            unselectedItemColor: Theme.of(context).hintColor,
            currentIndex: this.page,
            onTap: (index) => this.nomad(index, val),
            items: [
              BottomNavigationBarItem(
                icon: Icon(
                    page == 0 ? Ionicons.calendar : Ionicons.calendar_outline),
                label: 'Захиалга',
              ),
              BottomNavigationBarItem(
                icon: Icon(page == 1 ? Ionicons.grid : Ionicons.grid_outline),
                label: 'Пост',
              ),
              BottomNavigationBarItem(
                icon:
                    Icon(page == 2 ? Ionicons.person : Ionicons.person_outline),
                label: 'Профайл',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
