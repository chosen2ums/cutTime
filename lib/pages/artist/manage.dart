import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';
import 'package:salon/components/post_widget.dart';
import 'package:salon/provider/artist_state_provider.dart';
import 'package:salon/repository.dart';

class Manage extends StatefulWidget {
  Manage({Key key}) : super(key: key);

  @override
  _ManageState createState() => _ManageState();
}

class _ManageState extends State<Manage> {
  @override
  Widget build(BuildContext context) {
    ArtistStateProvider val = Provider.of(context);
    return Scaffold(
      body: ListView.separated(
        shrinkWrap: true,
        cacheExtent: 99999999,
        itemCount: val.posts.length,
        padding: EdgeInsets.only(bottom: 100, top: repo.statusBar + 10),
        itemBuilder: (context, index) => PostWidget(
          val.posts.elementAt(index),
          access: 0,
        ),
        separatorBuilder: (context, index) => SizedBox(height: 30),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Пост нэмэх',
        onPressed: val.addPost,
        foregroundColor: Colors.white,
        child: Icon(Ionicons.add_sharp),
        backgroundColor: Theme.of(context).colorScheme.secondary,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
