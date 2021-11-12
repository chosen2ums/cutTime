import 'package:salon/models/category.dart';
import 'package:salon/models/media.dart';
import 'package:salon/repository.dart';

class Service {
  int id;
  String name;
  Category category;
  int duration;
  String gender;
  Media image;
  bool active;
  int price;
  bool mine;

  Service({
    this.id,
    this.name,
    this.category,
    this.duration,
    this.gender,
    this.image,
    this.active,
    this.price,
    this.mine = false,
  });

  String get first =>
      price.toString().substring(0, price.toString().length - 3);
  String get last => price.toString().substring(price.toString().length - 3);

  Future handleChange() async {
    bool val;
    if (mine)
      val = await repo.removeService(this.id);
    else
      val = await repo.addService(this.id);
    this.mine = !this.mine == val;
    return mine;
  }

  factory Service.fromJson(Map<String, dynamic> json) => Service(
        id: json['id'],
        name: json['name'].trim(),
        category: Category.fromJson(json['category']),
        duration: json['duration'],
        gender: json['gender'],
        image: Media.fromJson(json['image']),
        active: json['is_active'],
        price: json['price'],
        mine: json['mine'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'category': category,
        'duration': duration,
        'gender': gender,
        'image': image,
        'is_active': active,
        'price': price,
        'mine': mine,
      };
}
