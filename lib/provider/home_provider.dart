import 'package:flutter/material.dart';
import 'package:salon/models/post.dart';

class HomeProvider with ChangeNotifier {
  List<Post> posts;
  ScrollController controller = new ScrollController();
  HomeProvider.instance() : posts = List.empty() {
    conf();
  }
  int pl = 0;
  bool loading = false;

  void conf() {
    controller.addListener(listener);
  }

  updatePost(posts) {
    this.posts = posts;
    if (pl == 0) (posts ?? []).length > 5 ? pl = 5 : pl = (posts ?? []).length;
  }

  void listener() async {
    // Feed loader
    if (!loading) {
      if (controller.position.maxScrollExtent == controller.offset) {
        loading = true;
        notifyListeners();
        await Future.delayed(Duration(seconds: 1));
        loading = false;
        notifyListeners();
        pl += 5;
        if (pl > posts.length) pl = posts.length;
        notifyListeners();
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
