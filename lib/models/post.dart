import 'package:flutter/cupertino.dart';
import 'package:salon/components/single_comment_widget.dart';
import 'package:salon/models/owner.dart';
import 'package:salon/repository.dart';

import 'comment.dart';
import 'media.dart';

class Post {
  int id;
  String body;
  DateTime created;
  PostOwner owner;
  List<Media> photos;
  List<PostTag> tags;
  List<Comment> comments;
  List<Owner> likes;
  bool isLiked;
  bool isSaved;

  //animated comment
  GlobalKey<AnimatedListState> key = GlobalKey();

  Post({
    this.id,
    this.body,
    this.created,
    this.owner,
    this.photos,
    this.tags,
    this.comments,
    this.likes,
    this.isLiked,
    this.isSaved,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    List phts = json['pictures'];
    List tgs = json['tags'];
    List cmmnts = json['comments'];
    List lks = json['likes'];
    return Post(
      id: json['id'],
      body: json['body'] ?? "".trim(),
      created: repo.format.parse(json['created_at']),
      owner: PostOwner.fromJson(json['owner']),
      photos: phts.map((e) => Media.fromJson(e)).toList(),
      tags: tgs.map((e) => PostTag.fromJson(e)).toList(),
      comments: cmmnts.map((e) => Comment.fromJson(e)).toList(),
      likes: lks.map((e) => Owner.fromJson(e)).toList(),
      isLiked: json['is_liked'] ?? false,
      isSaved: json['is_saved'] ?? false,
    );
  }

  Future<bool> like() async {
    isLiked = await repo.postLike(id);

    if (isLiked)
      likes.add(Owner(name: 'test'));
    else
      likes.removeWhere((e) => e.id == this.id);
    return isLiked;
  }

  Future<bool> save() async => isSaved = await repo.postSave(id);

  addComment(comment) async {
    Comment newcomment = await repo.addComment(id, comment);
    key.currentState?.insertItem(
      comments.length,
      duration: Duration(milliseconds: 200),
    );
    comments.add(newcomment);
  }

  deleteComment(Comment comment) async {
    bool status = await repo.deleteComment(comment);
    if (status) {
      int indx = comments.indexOf(comment);
      key.currentState?.removeItem(indx, (context, animation) => null);
      comments.removeAt(indx);
    }
  }

  Widget slideChild(BuildContext context, int index, animation) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: Offset(1, 0),
        end: Offset(0, 0),
      ).animate(animation),
      child: SingleCommentWidget(
        this.comments[index],
        delete: this.deleteComment,
      ),
    );
  }
}

//salon
class PostOwner {
  int id;
  String name;
  Media logo;
  String type;

  PostOwner({
    this.id,
    this.name,
    this.logo,
    this.type,
  });

  factory PostOwner.fromJson(Map<String, dynamic> json) {
    return PostOwner(
      id: json['id'],
      name: json['name'] ?? 'Owner',
      logo: Media.fromJson(json['logo']),
      type: json['type'],
    );
  }
}

//service
class PostTag {
  int id;
  String name;

  PostTag({
    this.id,
    this.name,
  });

  factory PostTag.fromJson(Map<String, dynamic> json) {
    return PostTag(
      id: json['id'],
      name: json['name'],
    );
  }
}
