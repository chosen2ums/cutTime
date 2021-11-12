import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:salon/components/webview.dart';
import 'package:salon/helper/helper.dart';
import 'package:salon/pages/login/facebook_login.dart';
import 'package:salon/pages/login/google_login.dart';
import 'package:salon/repository.dart';

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: Helper.of(context).onWillPop,
      child: ColoredBox(
        color: Colors.white,
        child: Stack(
          children: [
            Positioned(
              top: MediaQuery.of(context).padding.top,
              left: 0,
              right: 0,
              bottom: 0,
              child: Image.asset(
                'assets/img/login_2.png',
                fit: BoxFit.fill,
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              top: 150,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset('assets/img/logo.png', height: 80, width: 80, fit: BoxFit.cover),
                  SizedBox(height: 20),
                  Text('CUTime', style: TextStyle(fontSize: 28, color: Theme.of(context).colorScheme.secondary, fontFamily: 'TenorSans')),
                  Text(
                    'Салон захиалгын систем',
                    style: TextStyle(
                      fontFamily: 'Thasadith',
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 100,
              child: social(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget social(context) {
    return Column(
      children: [
        GoogleLogin(),
        SizedBox(height: 10),
        FacebookLogin(),
        SizedBox(height: 20),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 30),
          child: RichText(
              textAlign: TextAlign.justify,
              text: TextSpan(children: [
                TextSpan(
                  text: "Нэвтэрснээр та ",
                  style: TextStyle(color: Colors.black),
                ),
                TextSpan(
                  text: "үйлчилгээний гэрээг",
                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, decoration: TextDecoration.underline),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () => repo.app.navi
                        .pushNamed('/WebView', arguments: WebViewArguments("Үйлчилгээний ерөнхий нөхцөл", "https://esalon.mn/user_agreements")),
                ),
                TextSpan(
                  text: " хүлээн зөвшөөрч байгаа болно.",
                  style: TextStyle(color: Colors.black),
                ),
              ])),
        ),
      ],
    );
  }
}
