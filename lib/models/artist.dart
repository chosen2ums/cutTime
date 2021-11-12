import 'package:salon/models/category.dart';
import 'package:salon/models/media.dart';
import 'package:salon/models/post.dart';
import 'package:salon/models/salon.dart';
import 'package:salon/models/service.dart';
import 'package:salon/repository.dart';

class Artist with Comparable {
  int id;
  String name;
  String role;
  String email;
  String phone;
  String gender;
  DateTime birthday;
  Media avatar;
  bool active;
  bool isDone;
  Salon salon;
  bool isFollow;
  int history;
  List<Category> categories;
  List<Service> services;

  List<Post> posts;

  Artist({
    this.id,
    this.name,
    this.role,
    this.email,
    this.phone,
    this.gender,
    this.birthday,
    this.avatar,
    this.active,
    this.isDone,
    this.isFollow,
    this.history,
    this.salon,
    this.services,
    this.categories,
  });

  Future getData() async {
    await getPosts();
    return null;
  }

  Future getPosts() async => posts = posts == null ? await repo.getPostsByArtist(id) : posts;

  Future<bool> follow() async {
    isFollow = await repo.followArtist(id);
    return isFollow;
  }

  bool hasService(service) {
    int index = services.indexWhere((element) => element.id == service.id);
    if (index != -1)
      return true;
    else
      return false;
  }

  @override
  int compareTo(other) {
    if (this.isFollow)
      return -1;
    else if (this.history != 0) {
      if (other.isFollow)
        return 1;
      else
        return -1;
    } else
      return 1;
  }

  factory Artist.fromJson(Map<String, dynamic> json) {
    List data = json['services'] ?? List.empty();
    List cat = json['categories'] ?? List.empty();
    return Artist(
      id: json['id'],
      name: json['name'],
      role: json['role'],
      email: json['email'],
      phone: json['phone'],
      gender: json['gender'],
      birthday: json['birthday'] != null ? repo.format.parse(json['birthday']) : null,
      avatar: Media.fromJson(json['avatar']),
      active: json['active'] ?? false,
      isDone: json['is_done'] ?? false,
      isFollow: json['is_follow'] ?? false,
      history: json['history'] ?? 0,
      salon: json['salon'] == null ? null : Salon.fromJson(json['salon']),
      services: data.map((e) => Service.fromJson(e)).toList(),
      categories: cat.map((e) => Category.fromJson(e)).toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'role': role,
        'email': email,
        'phone': phone,
        'gender': gender,
        'birthday': repo.format.format(birthday),
        'avatar': avatar,
        'active': active,
        'is_done': isDone,
        'is_follow': isFollow,
        'history': history,
        'salon': salon,
        'services': services,
        'categories': categories,
      };
}
