import 'package:flutter/material.dart';
import 'package:salon/helper/loading.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(child: Loading(20)),
    );
  }
}
