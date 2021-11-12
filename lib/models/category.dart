import 'package:salon/models/media.dart';

class Category {
  int id;
  String monName;
  String engName;
  String description;
  Media icon;
  Media image;
  int parent;
  int level;

  Category({
    this.id,
    this.monName,
    this.engName,
    this.description,
    this.icon,
    this.image,
    this.parent,
    this.level,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      monName: json['mon_name'],
      engName: json['eng_name'],
      description: json['description'],
      icon: Media.fromJson(json['icon']),
      image: Media.fromJson(json['image']),
      parent: json['parent_id'],
      level: json['level'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'mon_name': monName,
        'eng_name': engName,
        'description': description,
        'icon': icon,
        'image': image,
        'parent_id': parent,
        'level': level,
      };
}
