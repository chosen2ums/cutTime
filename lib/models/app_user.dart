import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:salon/models/media.dart';
import 'package:salon/repository.dart';

class AppUser {
  int id;
  String name;
  String email;
  String phone;
  String uid;
  DateTime birthday;
  String gender;
  String role;
  Media avatar;

  AppUser({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.uid,
    this.birthday,
    this.gender,
    this.role,
    this.avatar,
  });

  Future update(key, val) async {
    switch (key) {
      case 'Нэр':
        await updateUserName(val);
        break;
      case 'Цахим шуудан':
        await updateUserEmail(val);
        break;
      case 'Утас':
        await updateUserPhone(val);
        break;
      case 'Төрсөн өдөр':
        await updateUserBirthday(val);
        break;
      case 'Хүйс':
        await updateUserGender(val);
        break;
      default:
    }
    return null;
  }

  final picker = ImagePicker();

  Future changeProfile() async {
    final old = this.avatar;
    try {
      final pickedImage = await picker.pickImage(source: ImageSource.gallery);
      if (pickedImage != null) {
        File image = File(pickedImage.path);
        this.avatar = await repo.changeAvatar(image, 'profile');
        if (this.avatar == null) this.avatar = old;
      } else
        this.avatar = old;
    } catch (e) {
      this.avatar = old;
    }
  }

  Future updateUserBirthday(DateTime birthday) async {
    bool status = await repo.updateUserBirthday(birthday);
    if (status) this.birthday = birthday;
  }

  Future updateUserName(name) async {
    bool status = await repo.updateUserName(name);
    if (status) this.name = name;
  }

  Future updateUserEmail(email) async {
    bool status = await repo.updateUserEmail(email);
    if (status) this.email = email;
  }

  Future updateUserPhone(phone) async {
    bool status = await repo.updateUserPhone(phone);
    if (status) this.phone = phone;
  }

  Future updateUserGender(gender) async {
    if (gender != this.gender) {
      bool status = await repo.updateUserGender(gender);
      if (status) this.gender = gender;
    }
  }

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      uid: json['uid'],
      birthday:
          json['birthday'] != null ? repo.format.parse(json['birthday']) : null,
      gender: json['gender'],
      role: json['role'],
      avatar: Media.fromJson(json['avatar']),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'phone': phone,
        'uid': uid,
        'birthday': repo.format.format(birthday),
        'gender': gender,
        'role': role,
        'avatar': avatar,
      };
}
