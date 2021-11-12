import 'package:salon/models/app_user.dart';
import 'package:salon/models/salon.dart';
import 'package:salon/models/service.dart';
import 'package:salon/repository.dart';

class ArtistOrder {
  int id;
  int dadid;
  String status;
  AppUser client;
  String contact;
  Salon salon;
  Service service;
  DateTime begin;
  DateTime end;

  ArtistOrder({
    this.id,
    this.dadid,
    this.status,
    this.client,
    this.contact,
    this.salon,
    this.service,
    this.begin,
    this.end,
  });

  factory ArtistOrder.fromJson(Map<String, dynamic> json) => ArtistOrder(
        id: json['id'],
        dadid: json['dad'],
        status: json['status'],
        client: AppUser.fromJson(json['client']),
        contact: json['contact'],
        salon: Salon.fromJson(json['salon']),
        service: Service.fromJson(json['service']),
        begin: repo.format.parse(json['begin']),
        end: repo.format.parse(json['end']),
      );
}
