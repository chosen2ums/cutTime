import 'package:flutter/material.dart';
import 'package:salon/helper/helper.dart';
import 'package:salon/helper/loading.dart';

class Shop extends StatefulWidget {
  const Shop({Key key}) : super(key: key);

  @override
  _ShopState createState() => _ShopState();
}

class _ShopState extends State<Shop> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: Helper.of(context).onWillPop,
      child: Center(child: Loading(20)),
    );
  }
}
