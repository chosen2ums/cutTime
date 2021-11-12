import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:salon/models/category.dart';
import 'package:salon/models/media.dart';
import 'package:salon/models/post.dart';
import 'package:salon/repository.dart';

import 'artist.dart';
import 'service.dart';

class Salon with Comparable {
  int id;
  String name;
  String description;
  String location;
  String address;
  String phone;
  String email;
  String fb;
  String what3word;
  LatLng position;
  Media logo;
  Media cover;
  bool isActive;
  bool isDone;
  bool isFollow;
  List<TimeTable> timeTable;
  List<Artist> artists;
  List<Post> posts;
  List<Service> services;
  List<Category> categories;
  int history;

  Salon({
    this.id,
    this.name,
    this.description,
    this.location,
    this.address,
    this.phone,
    this.email,
    this.fb,
    this.what3word,
    this.position,
    this.logo,
    this.cover,
    this.isActive,
    this.isDone,
    this.isFollow,
    this.timeTable,
    this.history,
  });

  String distance(LatLng pos) => Geolocator.distanceBetween(
        pos.latitude,
        pos.longitude,
        position.latitude,
        position.longitude,
      ).toStringAsFixed(2);

  double range(LatLng pos) => Geolocator.distanceBetween(
        pos.latitude,
        pos.longitude,
        position.latitude,
        position.longitude,
      );

  Future getData() async {
    await getArtists();
    artists.sort();
    await getPosts();
    await getServices();
    await getCategories();
    return null;
  }

  Future<List<Artist>> getArtists() async => artists = artists == null ? await repo.getArtistsBySalon(id) : artists;
  Future getPosts() async => posts = posts == null ? await repo.getPostsBySalon(id) : posts;
  Future getServices() async => services = services == null ? await repo.getServicesBySalon(id) : services;
  Future getCategories() async {
    if (categories == null) {
      categories = [
        Category(
          id: 0,
          level: 2,
          engName: 'all',
          monName: 'бүгд',
        ),
      ];
      categories.addAll(await repo.getCategoriesBySalon(id));
    }
  }

  Future<bool> follow() async {
    isFollow = await repo.followSalon(id);
    return isFollow;
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

  factory Salon.fromJson(Map<String, dynamic> json) {
    List time = json['timetable'] ?? [];
    return Salon(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      location: json['location'],
      address: json['address'],
      phone: json['phone'],
      email: json['email'],
      fb: json['facebook'],
      what3word: json['what3word'],
      position: json['position'].first == null ? null : LatLng.fromJson(json['position']),
      logo: Media.fromJson(json['logo']),
      cover: Media.fromJson(json['cover']),
      isActive: json['is_active'],
      isDone: json['is_done'],
      isFollow: json['is_follow'],
      timeTable: time.map((e) => TimeTable.fromJson(e)).toList(),
      history: json['history'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'location': location,
        'address': address,
        'phone': phone,
        'email': email,
        'facebook': fb,
        'what3word': what3word,
        'position': position,
        'logo': logo,
        'cover': cover,
        'is_active': isActive,
        'is_done': isDone,
        'if_follow': isFollow,
        'timetable': timeTable,
        'history': history,
      };
}

class TimeTable {
  String day;
  DateTime start;
  DateTime end;

  TimeTable({
    this.day,
    this.start,
    this.end,
  });

  String get st => DateFormat('hh:mm').format(start);
  String get nd => DateFormat('hh:mm').format(end);

  factory TimeTable.fromJson(Map<String, dynamic> json) => TimeTable(
        day: json['day'],
        start: repo.format.parse(json['start']),
        end: repo.format.parse(json['end']),
      );

  Map<String, dynamic> toJson() => {
        'day': day,
        'start': repo.format.format(start),
        'end': repo.format.format(end),
      };
}
