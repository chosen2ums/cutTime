import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class Loading extends StatelessWidget {
  final double size;
  Loading(this.size) : assert(size != null);
  @override
  Widget build(BuildContext context) {
    return Center(
      child: LottieBuilder.asset('assets/json/loading.json', height: size),
    );
  }
}
