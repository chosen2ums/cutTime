import 'package:salon/models/app_user.dart';
import 'package:salon/models/artist.dart';
import 'package:salon/models/order_item.dart';
import 'package:salon/models/salon.dart';
import 'package:salon/models/service.dart';

enum Type { SALON, ARTIST, DEFAULT }

class Order {
  int id;
  AppUser client;
  String contact;
  Salon salon;
  List<OrderItem> services;
  String status;

  Type type;
  DateTime day;

  Order({
    this.id,
    this.client,
    this.contact,
    this.status,
    this.services,
    this.salon,
    Artist artist,
    Service service,
  }) {
    if (this.contact == null) this.contact = this.client.phone;
    if (this.status == null) this.status = 'creating';
    if (this.services == null) {
      if (artist != null)
        type = Type.ARTIST;
      else if (salon != null) {
        type = Type.SALON;
        this.salon.getArtists();
      } else
        type = Type.DEFAULT;
      this.services = [
        OrderItem(
          service: service,
          salon: this.salon,
          artist: artist,
        ),
      ];
    }
    if (day == null) day = DateTime.now();
  }

  int get total {
    int price = 0;
    List<OrderItem> active = services.where((element) => element.id != null).toList();
    active.forEach((e) => price += e.service.price);
    return price;
  }

  void setId(id) => this.id = id;

  Future setSalon(salon) async {
    if (salon != this.salon) {
      this.salon = salon;
      await this.salon.getArtists();
      await this.salon.getServices();
      this.services.last.updateServices(this.salon.services);
      this.services.last.updateArtists(this.salon.artists);
      this.services.last.setArtist(null);
    }
    return null;
  }

  //artist

  Future setArtist(Artist artist) async {
    this.services.last.setArtist(artist);
    if (this.salon == null) {
      this.salon = artist.salon;
      await this.salon.getArtists();
      await this.salon.getServices();
      await this.salon.getCategories();
    }
    return null;
  }

  updateArtist(artist) => this.services.last.updateArtist(artist);
  ssArtist() => this.salon.getArtists().then(this.services.last.ssArtist);

  Future fetchAvTime() async => await this.services.last.fetchAvTime(this.day);

  void newItem() => services.add(OrderItem(salon: this.salon));
  void removeLast() => this.services.removeLast();

  void removeAt(index) => this.services.removeAt(index);

  Future setDay(day) async {
    this.day = day;
    return null;
  }

  factory Order.fromJson(Map<String, dynamic> json) {
    List body = json['services'] ?? List.empty();
    return Order(
      id: json['id'],
      client: AppUser.fromJson(json['client']),
      contact: json['contact'],
      status: json['status'],
      salon: Salon.fromJson(json['salon']),
      services: body.map((e) => OrderItem.fromJson(e)).toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'client': client,
        'contact': contact,
        'status': status,
        'salon': salon,
        'services': services,
      };
}
