import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salon/helper/loading.dart';
import 'package:salon/provider/app_provider.dart' as app;
import 'package:salon/repository.dart';
import 'package:slidable_button/slidable_button.dart';

class FacebookLogin extends StatefulWidget {
  FacebookLogin({Key key}) : super(key: key);

  @override
  _FacebookLoginState createState() => _FacebookLoginState();
}

class _FacebookLoginState extends State<FacebookLogin> with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  AnimationController controller;

  @override
  void initState() {
    controller = AnimationController(vsync: this, duration: Duration(milliseconds: 200), reverseDuration: Duration(milliseconds: 0));
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      if (repo.app.status == app.Status.Unauthorized) {
        if (this.mounted) controller.reverse();
      }
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    app.AppProvider provider = Provider.of(context);
    return SlidableButton(
      height: 55,
      width: MediaQuery.of(context).size.width - 40,
      buttonWidth: 55,
      label: Image.asset('assets/img/facebook.png', height: 55, width: 55),
      child: InkWell(
        onTap: () async {
          if (provider.status == app.Status.Unauthorized) {
            await controller.forward();
            provider.loginFacebook();
          }
        },
        child: Container(
          height: 55,
          alignment: Alignment.centerLeft,
          margin: EdgeInsets.symmetric(vertical: 3),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(23),
            border: Border.all(
                color: app.Status.Authorizing == provider.status
                    ? provider.isGoogle
                        ? Colors.grey
                        : Theme.of(context).colorScheme.secondary
                    : Theme.of(context).colorScheme.secondary,
                width: 0.4),
          ),
          child: app.Status.Authorizing == provider.status
              ? !provider.isGoogle
                  ? Loading(20)
                  : Padding(
                      padding: const EdgeInsets.only(left: 80),
                      child: Text('FACEBOOK ЭРХЭЭР НЭВТРЭХ',
                          textAlign: TextAlign.start, style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w300)),
                    )
              : Padding(
                  padding: const EdgeInsets.only(left: 80),
                  child:
                      Text('FACEBOOK ЭРХЭЭР НЭВТРЭХ', textAlign: TextAlign.start, style: TextStyle(color: Colors.black, fontWeight: FontWeight.w300)),
                ),
        ),
      ),
      initialPosition: SlidableButtonPosition.left,
      controller: controller,
      dismissible: false,
      onChanged: (val) {
        if (val == SlidableButtonPosition.right) provider.loginFacebook();
      },
    );
  }
}
