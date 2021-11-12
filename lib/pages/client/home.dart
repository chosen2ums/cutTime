import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';
import 'package:salon/components/follow_widget.dart';
import 'package:salon/components/post_widget.dart';
import 'package:salon/helper/helper.dart';
import 'package:salon/helper/loading.dart';
import 'package:salon/provider/app_provider.dart' as app;
import 'package:salon/provider/home_provider.dart';
import 'package:salon/repository.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    HomeProvider home = Provider.of<HomeProvider>(context);
    app.AppProvider provider = Provider.of<app.AppProvider>(context);
    home.updatePost(provider.posts);
    return child();
  }

  child() {
    HomeProvider home = Provider.of(context);
    return WillPopScope(
      onWillPop: Helper.of(context).onWillPop,
      child: (home.posts ?? []).length == 0
          ? Center(child: Text('Ачааллаж байна'))
          : CustomRefreshIndicator(
              builder: (context, child, controller) => child,
              onRefresh: () async => await repo.app.getPosts(),
              child: SingleChildScrollView(
                controller: home.controller,
                physics: AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: repo.statusBar + 20),
                    FollowWidget(head: 'Trending'),
                    Divider(),
                    ListView.separated(
                      shrinkWrap: true,
                      cacheExtent: 9999999,
                      itemCount: home.pl + 1,
                      padding: EdgeInsets.only(bottom: 20),
                      physics: ClampingScrollPhysics(),
                      itemBuilder: (context, index) {
                        if (home.pl == index)
                          return Center(
                            child: home.pl == home.posts.length ? Container() : Loading(20),
                          );
                        else
                          return AnimationConfiguration.staggeredList(
                              position: index,
                              duration: Duration(milliseconds: 250),
                              child: SlideAnimation(child: FadeInAnimation(child: PostWidget(home.posts[index]))));
                      },
                      separatorBuilder: (context, index) => SizedBox(height: 30),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
