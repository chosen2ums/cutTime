import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';
import 'package:salon/provider/app_provider.dart' as app;
import 'package:salon/repository.dart';
import 'package:shape_of_view/shape_of_view.dart';

import 'webview.dart';

class ProfileWidget extends StatefulWidget {
  ProfileWidget({Key key}) : super(key: key);

  @override
  _ProfileWidgetState createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget> {
  @override
  Widget build(BuildContext context) {
    app.AppProvider provider = Provider.of(context);
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 160,
      child: Stack(
        children: [
          Positioned(
            top: provider.user.role != 'client' ? 10 : 50,
            bottom: provider.user.role != 'client' ? 40 : 0,
            left: 20,
            child: ShapeOfView(
              shape: CircleShape(
                borderColor: Colors.white,
                borderWidth: 1,
              ),
              child: CachedNetworkImage(
                imageUrl: provider.user.avatar?.path ?? repo.empty,
                width: 95,
                height: 95,
                fit: BoxFit.cover,
              ),
            ),
          ),
          provider.user.role != 'client'
              ? Positioned(
                  left: 10,
                  bottom: 10,
                  height: 25,
                  width: 110,
                  child: TextButton(
                    onPressed: () => provider.changeState(
                      provider.state == app.State.Artist ? app.State.Client : app.State.Artist,
                    ),
                    style: ButtonStyle(
                      visualDensity: VisualDensity.compact,
                      shape: MaterialStateProperty.all(StadiumBorder()),
                      side: MaterialStateProperty.all(
                        BorderSide(color: Theme.of(context).colorScheme.secondary, width: 1),
                      ),
                    ),
                    child: Text(
                      provider.state == app.State.Artist ? 'Switch to client' : 'Switch to artist',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                        fontSize: 12,
                      ),
                    ),
                  ),
                )
              : Container(),
          Positioned(
            top: 10,
            right: 10,
            left: provider.user.role != 'client' ? 150 : 10,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: RichText(
                    maxLines: 2,
                    softWrap: true,
                    textAlign: TextAlign.left,
                    overflow: TextOverflow.clip,
                    text: TextSpan(
                      style: TextStyle(
                        color: Theme.of(context).hintColor.withOpacity(0.75),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        shadows: [
                          Shadow(
                            blurRadius: 5,
                            color: Colors.black12,
                            offset: Offset(0, 3),
                          )
                        ],
                      ),
                      children: [
                        TextSpan(text: 'Hello,  '),
                        TextSpan(
                          text: provider.user.name,
                          style: TextStyle(fontWeight: FontWeight.w800),
                        ),
                      ],
                    ),
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: () => print('notif'),
                      color: Theme.of(context).hintColor.withOpacity(0.75),
                      visualDensity: VisualDensity.compact,
                      icon: Icon(Ionicons.notifications_sharp),
                    ),
                    PopupMenuButton(
                      itemBuilder: (context) => [
                        PopupMenuItem<int>(
                            child: Row(
                              children: [
                                Icon(Ionicons.settings_outline, size: 18),
                                SizedBox(width: 5),
                                Text('Тохиргоо'),
                              ],
                            ),
                            padding: EdgeInsets.fromLTRB(15, 0, 5, 0),
                            textStyle: TextStyle(fontSize: 14, color: Theme.of(context).hintColor),
                            value: 0),
                        PopupMenuItem<int>(
                            child: Row(
                              children: [
                                Icon(Ionicons.receipt_outline, size: 18),
                                SizedBox(width: 5),
                                Text('Үйлчилгээний гэрээ'),
                              ],
                            ),
                            padding: EdgeInsets.fromLTRB(15, 0, 5, 0),
                            textStyle: TextStyle(fontSize: 14, color: Theme.of(context).hintColor),
                            value: 1),
                        PopupMenuItem<int>(
                            child: Row(
                              children: [
                                Icon(Ionicons.exit_outline, size: 18),
                                SizedBox(width: 5),
                                Text('Системээс гарах'),
                              ],
                            ),
                            padding: EdgeInsets.fromLTRB(15, 0, 5, 0),
                            textStyle: TextStyle(fontSize: 14, color: Theme.of(context).hintColor),
                            value: 2),
                      ],
                      onSelected: (val) {
                        switch (val) {
                          case 0:
                            provider.navi.pushNamed('/Settings');
                            break;
                          case 1:
                            provider.navi.pushNamed('/WebView',
                                arguments: WebViewArguments("Үйлчилгээний ерөнхий нөхцөл", "https://esalon.mn/user_agreements"));
                            break;
                          case 2:
                            provider.logOut();
                            break;
                          default:
                        }
                      },
                      elevation: 1,
                      padding: EdgeInsets.zero,
                      icon: Icon(Ionicons.ellipsis_vertical_sharp),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                    ),
                  ],
                )
              ],
            ),
          ),
          Positioned(
            bottom: 10,
            top: 55,
            left: 160,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Visibility(
                  visible: provider.user.email != null && provider.user.email != '',
                  child: Row(
                    children: [
                      Icon(Ionicons.mail_outline, size: 18),
                      SizedBox(width: 20),
                      Text(provider.user.email, style: TextStyle(fontSize: 12)),
                    ],
                  ),
                ),
                SizedBox(height: 5),
                Visibility(
                  visible: provider.user.phone != null && provider.user.phone != '',
                  child: Row(
                    children: [
                      Icon(Ionicons.call_outline, size: 18),
                      SizedBox(width: 20),
                      Text('${provider.user.phone}', style: TextStyle(fontSize: 12)),
                    ],
                  ),
                ),
                SizedBox(height: 5),
                Visibility(
                  visible: provider.user.birthday != null,
                  child: Row(
                    children: [
                      Icon(Ionicons.gift_outline, size: 18),
                      SizedBox(width: 20),
                      Text(repo.bformat.format(provider.user.birthday ?? DateTime.now()), style: TextStyle(fontSize: 12)),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
