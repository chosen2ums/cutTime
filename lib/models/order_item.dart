import 'dart:async';

import 'package:salon/models/artist.dart';
import 'package:salon/models/salon.dart';
import 'package:salon/models/service.dart';
import 'package:salon/repository.dart';

class OrderItem {
  int id;
  DateTime begin;
  DateTime end;
  Service service;
  Artist artist;
  String status;

  int age = DateTime.now().hour > 18
          ? 2
          : DateTime.now().hour > 13
              ? 1
              : 0,
      indx = -1;
  List<String> avtime;

  OrderItem({
    this.id,
    this.begin,
    this.end,
    this.service,
    this.artist,
    this.status,
    Salon salon,
  }) {
    if (service == null) {
      if (this.artist != null)
        services = artist.services;
      else if (salon != null) {
        services = salon.services;
        updateArtists(salon.artists);
      } else
        updateArtists(repo.app.artists);
    } else {
      if (this.artist == null) ssArtist(salon.artists);
    }
  }

  void setId(id) => this.id = id;

  void setAvTime(avtime) => this.avtime = avtime;

  Future fetchAvTime(day) async => repo.getAvailableTime(this, day).then(setAvTime);

  List<String> get getAvtime => avtime == null
      ? null
      : age == 0
          ? this.avtime.where((e) => !(int.parse(e.split(':').first) > 12)).toList()
          : age == 1
              ? this.avtime.where((e) => !(int.parse(e.split(':').first) < 13 || int.parse(e.split(':').first) > 17)).toList()
              : this.avtime.where((e) => !(int.parse(e.split(':').first) < 18)).toList();

  void setAge(age) => this.age = age == null ? this.age : age;
  void setIndx(indx) => this.indx = indx;

  void setService(service) => this.service = service;
  updateServices(services) => this.services = services;

  ssArtist(List<Artist> artists) {
    List<Artist> filtered = artists.where((e) => e.hasService(this.service)).toList();
    updateArtists(filtered);
  }

  setArtist(artist) {
    this.artist = artist;
    if (this.artist != null) updateServices(this.artist.services);
  }

  updateArtist(artist) => this.artist = artist;
  updateArtists(List<Artist> artists) {
    this.artists = artists.where((e) => e.isDone && e.active).toList();
    this.artists.sort((a, b) => a.compareTo(b));
  }

  void setBegin(begin) {
    this.begin = begin;
    if (begin == null)
      setEnd(null);
    else
      setEnd(this.begin.subtract(Duration(minutes: -service.duration)));
  }

  void setEnd(end) => this.end = end;

  factory OrderItem.fromJson(Map<String, dynamic> json) => OrderItem(
        id: json['id'],
        status: json['status'],
        artist: json['artist'] == null ? null : Artist.fromJson(json['artist']),
        service: Service.fromJson(json['service']),
        begin: json['begin'] == null ? null : repo.format.parse(json['begin']),
        end: json['begin'] == null ? null : repo.format.parse(json['end']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'artist': artist,
        'status': status,
        'service': service,
        'begin': begin == null ? null : repo.format.format(begin),
        'end': end == null ? null : repo.format.format(end),
      };

  //function
  List<Service> services = List.empty();
  List<Artist> artists = List.empty();
}
