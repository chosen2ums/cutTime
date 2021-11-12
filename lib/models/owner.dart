import 'package:salon/models/media.dart';

class Owner {
  int id;
  String name;
  Media avatar;

  Owner({
    this.id,
    this.name,
    this.avatar,
  });

  factory Owner.fromJson(Map<String, dynamic> json) {
    return Owner(
      id: json['id'],
      name: json['name'],
      avatar: Media.fromJson(json['avatar']),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'avatar': avatar,
      };
}
