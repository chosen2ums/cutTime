import 'package:flutter/material.dart';
import 'package:salon/components/profile_widget.dart';
import 'package:salon/repository.dart';

import 'widgets/my_salon_widget.dart';
import 'widgets/my_services_widget.dart';

class ArtistAccount extends StatefulWidget {
  ArtistAccount({Key key}) : super(key: key);

  @override
  _ArtistAccountState createState() => _ArtistAccountState();
}

class _ArtistAccountState extends State<ArtistAccount> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      margin: EdgeInsets.only(top: repo.statusBar),
      child: SingleChildScrollView(
        child: Column(
          children: [
            ProfileWidget(),
            SizedBox(height: 50),
            MySalonWidget(),
            MyServicesWidget(),
          ],
        ),
      ),
    );
  }
}
