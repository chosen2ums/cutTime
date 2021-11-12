import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';
import 'package:salon/provider/app_provider.dart' as app;
import 'package:salon/repository.dart';
import 'package:shape_of_view/shape_of_view.dart';

import 'client/widget/profile_edit.dart';

class Settings extends StatefulWidget {
  Settings({Key key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  TextEditingController name = TextEditingController();

  @override
  Widget build(BuildContext context) {
    app.AppProvider provider = Provider.of(context);
    return Scaffold(
      appBar: AppBar(title: Text('Тохиргоо')),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(top: 10, left: 20, right: 20),
          child: Column(
            children: [
              ShapeOfView(
                shape: CircleShape(
                  borderColor: Colors.white,
                  borderWidth: 1,
                ),
                child: CachedNetworkImage(
                  imageUrl: provider.user.avatar?.path ?? repo.empty,
                  fit: BoxFit.cover,
                ),
                height: 100,
                width: 100,
              ),
              TextButton(
                onPressed: provider.changeProfile,
                child: Text('Зураг солих'),
                style: ButtonStyle(
                  visualDensity: VisualDensity.compact,
                  foregroundColor: MaterialStateProperty.all(Theme.of(context).colorScheme.secondary),
                  padding: MaterialStateProperty.all(EdgeInsets.fromLTRB(20, 2, 20, 2)),
                  shape: MaterialStateProperty.all(StadiumBorder()),
                  side: MaterialStateProperty.all(BorderSide(color: Theme.of(context).colorScheme.secondary, width: 1)),
                ),
              ),
              ProfileEdit('Нэр'),
              ProfileEdit('Цахим шуудан'),
              ProfileEdit('Утас'),
              ProfileEdit('Төрсөн өдөр'),
              ProfileEdit('Хүйс'),
              provider.user.role == 'client'
                  ? list(
                      icon: Ionicons.scan_outline,
                      title: 'Хамтран ажиллах',
                      onClick: () => provider.navi.pushNamed('/Join'),
                    )
                  : Container(),
              // list(
              //   icon: Ionicons.location_outline,
              //   title: 'Миний байршил',
              //   onClick: () => provider.navi.pushNamed('/MyPosition'),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  Widget list({Function onClick, IconData icon, String title}) {
    return InkWell(
      onTap: onClick,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 15),
        child: Row(
          children: [
            Icon(icon),
            SizedBox(width: 50),
            Text(
              title,
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
