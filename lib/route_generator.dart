import 'package:flutter/material.dart';
import 'package:salon/components/salon_widget.dart';
import 'package:salon/models/order.dart';
import 'package:salon/models/salon.dart';
import 'package:salon/pages/artist/widgets/add_post_widget.dart';
import 'package:salon/pages/artist/widgets/camera_screen.dart';
import 'package:salon/pages/client/nearby.dart';
import 'package:salon/pages/settings.dart';
import 'package:salon/pages/home.dart';

import 'components/not_found_widget.dart';
import 'components/webview.dart';
import 'pages/client/myposition.dart';
import 'pages/join_state.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Getting arguments passed in while calling Navigator.pushNamed
    final args = settings.arguments;
    switch (settings.name) {
      case '/Home':
        return MaterialPageRoute(builder: (_) => HomeKey());
      case '/Salon':
        return MaterialPageRoute<Order>(builder: (_) => SalonWidget(args));
      case '/MoreSalon':
        return MaterialPageRoute<Salon>(builder: (_) => Nearby(canPop: args));
      case '/Settings':
        return MaterialPageRoute(builder: (_) => Settings());
      case '/MyPosition':
        return MaterialPageRoute(builder: (_) => MyPosition());
      case '/Join':
        return MaterialPageRoute(builder: (_) => Join());
      case '/AddPost':
        return MaterialPageRoute(builder: (_) => AddPostWidget());
      case '/Camera':
        return MaterialPageRoute(builder: (_) => CameraScreen());
      case '/WebView':
        WebViewArguments argument = args;
        return MaterialPageRoute(builder: (_) => MyWebView(title: argument.title, selectedUrl: argument.selectedUrl));
      default:
        // If there is no such named route in the switch statement, e.g. /third
        return MaterialPageRoute(builder: (_) => Scaffold(body: SafeArea(child: NotFoundWidget())));
    }
  }
}
