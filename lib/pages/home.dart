import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salon/components/not_found_widget.dart';
import 'package:salon/components/splash_screen.dart';
import 'package:salon/provider/app_provider.dart' as app;

import 'artist_state.dart';
import 'client_state.dart';
import 'login_state.dart';

class HomeKey extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: AnimatedSwitcher(
        duration: Duration(milliseconds: 200),
        transitionBuilder: (child, animation) => SlideTransition(
          position: Tween<Offset>(
            begin: Offset(1, 0),
            end: Offset(0, 0),
          ).animate(animation),
          child: FadeTransition(
            opacity: Tween(begin: 0.0, end: 1.0).animate(animation),
            child: child,
          ),
        ),
        child: Consumer<app.AppProvider>(
          builder: (context, value, child) {
            Widget home;
            switch (value.status) {
              case app.Status.Authorized:
                switch (value.state) {
                  case app.State.Artist:
                    home = Artist();
                    break;
                  case app.State.Client:
                    home = Client();
                    break;
                  default:
                    home = NotFoundWidget();
                }
                break;
              case app.Status.Unauthorized:
                home = Login();
                break;
              case app.Status.Authorizing:
                home = Login();
                break;
              case app.Status.Undefined:
                home = SplashScreen();
                break;
              default:
                home = NotFoundWidget();
            }
            return home;
          },
        ),
      ),
    );
  }
}
