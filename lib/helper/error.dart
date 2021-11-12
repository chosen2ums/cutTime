import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Error extends StatelessWidget {
  final String detail;
  Error({this.detail = ''});
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('error: $detail'));
  }
}
