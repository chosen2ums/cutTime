import 'package:salon/models/owner.dart';
import 'package:salon/repository.dart';

class Comment {
  int id;
  String comment;
  DateTime created;
  Owner owner;

  Comment({
    this.id,
    this.comment,
    this.created,
    this.owner,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'],
      comment: json['comment'].trim(),
      created: repo.format.parse(json['created_at']),
      owner: Owner.fromJson(json['owner']),
    );
  }
}
