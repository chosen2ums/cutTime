import 'package:flutter/material.dart';
import 'package:salon/components/favorite_widget.dart';
import 'package:salon/components/follow_widget.dart';
import 'package:salon/components/profile_widget.dart';
import 'package:salon/helper/helper.dart';
import 'package:salon/repository.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: Helper.of(context).onWillPop,
      child: Padding(
        padding: EdgeInsets.only(top: repo.statusBar),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ProfileWidget(),
              SizedBox(height: 30),
              FollowWidget(),
              FavoriteWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
