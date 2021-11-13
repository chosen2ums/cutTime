import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as fstorage;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:salon/models/artist.dart';
import 'package:salon/models/artist_order.dart';
import 'package:salon/models/category.dart';
import 'package:salon/models/media.dart';
import 'package:salon/models/order.dart';
import 'package:salon/models/order_item.dart';
import 'package:salon/models/service.dart';
import 'package:salon/provider/app_provider.dart';
import 'package:salon/provider/artist_state_provider.dart';

import 'models/post.dart';
import 'models/salon.dart';
import 'models/comment.dart';
import 'models/app_user.dart';

final repo = Repository();
enum Stat { Loading, Error, Undone, Done }

class Repository {
  AppProvider app;
  ArtistStateProvider artistApp;
  Dio dio = new Dio();
  GetStorage storage = new GetStorage();
  BitmapDescriptor pin, dot, dotSelected;
  DateFormat get format =>
      DateFormat('EEE, dd MMM yyyy HH:mm:ss \'GMT\'', 'en_US');
  DateFormat get bformat => DateFormat('yyyy.MM.dd', 'mn');
  DateFormat get orderday => DateFormat('yyyy-MM-dd', 'mn');
  DateFormat get ordertime => DateFormat('yyyy-MM-dd HH:mm', 'mn');
  DateFormat get onlytime => DateFormat('HH:mm', 'mn');
  DateFormat get oformat => DateFormat.MMMEd('mn');
  String get empty =>
      'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_640.png';
  String get emptyImage =>
      'https://www.google.com/url?sa=i&url=https%3A%2F%2Fwww.istockphoto.com%2Fphotos%2Ferror-404&psig=AOvVaw2qN1mXh4XuH3joBgDnt-su&ust=1635070227157000&source=images&cd=vfe&ved=0CAsQjRxqFwoTCLDcsb-l4PMCFQAAAAAdAAAAABAD';
  double statusBar = 0;

  setApp(app) => this.app = app;
  setArtistApp(app) => this.artistApp = app;

  setDioOptions() {
    // if (url != '') dio.options.baseUrl = 'https://esalon.mn/api/client/$url/';

    dio.options.baseUrl = 'https://esalon.mn/api/client/';
    dio.options.headers['content-Type'] = 'application/json; charset=utf-8';
    dio.options.connectTimeout = 5000;
    dio.options.receiveTimeout = 3000;
  }

  setToken(token) => dio.options.headers['authorization'] = 'Bearer $token';

  snackBar(msg) => Fluttertoast.showToast(
      msg: msg, gravity: ToastGravity.SNACKBAR, toastLength: Toast.LENGTH_LONG);

  Future<Uint8List> getBytesFromAsset(
    String path, {
    context,
    Size size = const Size(30, 30),
  }) async {
    String svgString = await DefaultAssetBundle.of(context).loadString(path);
    DrawableRoot svgDrawableRoot = await svg.fromSvgString(svgString, null);
    final ratio = ui.window.devicePixelRatio.ceil();
    final width = size.width.ceil() * ratio;
    final height = size.height.ceil() * ratio;
    final picture = svgDrawableRoot.toPicture(
      size: Size(
        width.toDouble(),
        height.toDouble(),
      ),
    );
    final image = await picture.toImage(width, height);
    ByteData bytes = await image.toByteData(format: ui.ImageByteFormat.png);
    return bytes.buffer.asUint8List();
  }

  Future<AppUser> login(User fbuser) async {
    try {
      final response = await dio.post(
        'login',
        data: json.encode({
          'name': fbuser.displayName,
          'email': fbuser.email,
          'phone': fbuser.phoneNumber,
          'uid': fbuser.uid,
          'avatar': fbuser.photoURL,
        }),
      );
      final res = json.decode('$response');
      if (res['success'])
        return AppUser.fromJson(res['data']);
      else
        return null;
    } catch (e) {
      return null;
    }
  }

  //Post
  Future<List<Post>> getPosts() async {
    try {
      final response = await dio.get('posts');
      final res = json.decode('$response');
      if (res['success']) {
        List data = res['data'];
        return data.map((e) => Post.fromJson(e)).toList();
      } else
        return List.empty();
    } catch (e) {
      print(e);
      return List.empty();
    }
  }

  Future<List<Post>> getPostsBySalon(id) async {
    try {
      final response = await dio.get('salon-posts/$id');
      final res = json.decode('$response');
      if (res['success']) {
        List data = res['data'];
        return data.map((e) => Post.fromJson(e)).toList();
      } else
        return List.empty();
    } catch (e) {
      return List.empty();
    }
  }

  Future<List<Post>> getPostsByArtist(id) async {
    try {
      final response = await dio.get('artist-posts/$id');
      final res = json.decode('$response');
      if (res['success']) {
        List data = res['data'];
        return data.map((e) => Post.fromJson(e)).toList();
      } else
        return List.empty();
    } catch (e) {
      return List.empty();
    }
  }

  Future<bool> postLike(id) async {
    try {
      final response = await dio.post('post-like/$id');
      final res = json.decode('$response');
      if (res['success']) {
        if (res['message'] == 'Liked!')
          return true;
        else
          return false;
      } else
        return false;
    } catch (e) {
      return false;
    }
  }

  Future<bool> postSave(id) async {
    try {
      final response = await dio.post('post-save/$id');
      final res = json.decode('$response');
      if (res['success']) {
        if (res['message'] == 'Saved!')
          return true;
        else
          return false;
      } else
        return false;
    } catch (e) {
      return false;
    }
  }

  Future<Comment> addComment(id, comment) async {
    try {
      final response = await dio.post(
        'post-comment',
        data: json.encode({'id': id, 'comment': comment}),
      );
      final res = json.decode('$response');
      if (res['success'])
        return Comment.fromJson(res['data']);
      else
        return null;
    } catch (e) {
      return null;
    }
  }

  Future<bool> deleteComment(Comment comment) async {
    try {
      final response = await dio.delete('post-comment/${comment.id}');
      final res = json.decode('$response');
      if (res['success'])
        return true;
      else
        return false;
    } catch (e) {
      return false;
    }
  }

  //Salon
  Future<List<Salon>> getSalons() async {
    try {
      final response = await dio.get('unauthorized/salons');
      final res = json.decode('$response');
      if (res['success']) {
        List data = res['data'];
        return data.map((e) => Salon.fromJson(e)).toList();
      } else
        return List.empty();
    } catch (e) {
      return List.empty();
    }
  }

  //Artist
  Future<List<Artist>> getArtists() async {
    try {
      final response = await dio.get('unauthorized/artists');
      final res = json.decode('$response');
      if (res['success']) {
        List data = res['data'];
        return data.map((e) => Artist.fromJson(e)).toList();
      } else
        return List.empty();
    } catch (e) {
      return List.empty();
    }
  }

  Future<List<Artist>> getArtistsBySalon(id) async {
    try {
      final response = await dio.get('unauthorized/salon-artists/$id');
      final res = json.decode('$response');
      if (res['success']) {
        List data = res['data'];
        return data.map((e) => Artist.fromJson(e)).toList();
      } else
        return List.empty();
    } catch (e) {
      return List.empty();
    }
  }

  //Category
  Future<List<Category>> getCategories() async {
    try {
      final response = await dio.get('categories');
      final res = json.decode('$response');
      if (res['success']) {
        List data = res['data'];
        return data.map((e) => Category.fromJson(e)).toList();
      } else
        return List.empty();
    } catch (e) {
      return List.empty();
    }
  }

  Future<List<Category>> getCategoriesBySalon(id) async {
    try {
      final response = await dio.get('salon-categories/$id');
      final res = json.decode('$response');
      if (res['success']) {
        List data = res['data'];
        return data.map((e) => Category.fromJson(e)).toList();
      } else
        return List.empty();
    } catch (e) {
      return List.empty();
    }
  }

  //Service
  Future<List<Service>> getServices() async {
    try {
      final response = await dio.get('services');
      final res = json.decode('$response');
      if (res['success']) {
        List data = res['data'];
        return data.map((e) => Service.fromJson(e)).toList();
      } else
        return List.empty();
    } catch (e) {
      return List.empty();
    }
  }

  Future<List<Service>> getServicesBySalon(id) async {
    try {
      final response = await dio.get('salon-services/$id');
      final res = json.decode('$response');
      if (res['success']) {
        List data = res['data'];
        return data.map((e) => Service.fromJson(e)).toList();
      } else
        return List.empty();
    } catch (e) {
      return List.empty();
    }
  }

  //order
  Future<List<int>> postOrder(Order order) async {
    try {
      final response = await dio.post(
        'order',
        data: json.encode({
          'status': 'creating',
          'salon': order.salon.id,
          'contact': order.contact,
          'start': ordertime.format(order.services.first.begin),
          'end': ordertime.format(order.services.first.end),
          'service': order.services.first.service.id,
          'artist': order.services.first.artist.id,
          'price': order.services.first.service.price,
        }),
      );
      final res = json.decode('$response');
      if (res['success']) {
        List<int> datas = [res['orderid'], res['itemid']];
        return datas;
      } else {
        snackBar(res['message']);
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<int> postOrderDetail(OrderItem item, int id) async {
    try {
      final response = await dio.post('order-detail/$id',
          data: json.encode({
            'service': item.service.id,
            'price': item.service.price,
            'start': ordertime.format(item.begin),
            'end': ordertime.format(item.end),
            'artist': item.artist.id,
          }));
      final res = json.decode('$response');
      snackBar(res['message']);

      if (res['success'])
        return res['data'];
      else
        return null;
    } catch (e) {
      return null;
    }
  }

  Future<bool> confirmOrder(id) async {
    try {
      final response = await dio.put(
        'orders/status/$id',
        data: json.encode({'status': 'pending'}),
      );
      final res = json.decode('$response');
      if (!res['success']) snackBar(res['message']);
      return res['success'];
    } catch (e) {
      return false;
    }
  }

  deleteOrder(id) async {
    try {
      final response = await dio.delete('order/$id');
      final res = json.decode('$response');
      snackBar(res['message']);
    } catch (e) {
      print(e);
    }
  }

  Future<bool> deleteOrderDetail(id) async {
    try {
      final response = await dio.delete('order-detail/$id');
      final res = json.decode('$response');
      snackBar(res['message']);
      return res['success'];
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<List<Order>> getOrders() async {
    try {
      final response = await dio.get('orders');
      final res = json.decode('$response');
      if (res['success']) {
        List data = res['data'];
        return data.map((e) => Order.fromJson(e)).toList();
      } else
        return List.empty();
    } catch (e) {
      return List.empty();
    }
  }

  Future<List<String>> getAvailableTime(
    OrderItem item,
    DateTime day,
  ) async {
    try {
      final response = await dio.post(
        'available-time',
        data: json.encode({
          'employee': item.artist.id,
          'date': orderday.format(day),
          'duration': item.service.duration,
          'weekday': day.weekday - 1,
        }),
      );
      final res = json.decode('$response');
      if (res['success']) {
        try {
          List data = res['data'];
          List<String> time = data.map((e) => e.toString()).toList();
          return time;
        } catch (e) {
          snackBar(res['message']);
          return List.empty();
        }
      } else {
        snackBar(res['message']);
        return List.empty();
      }
    } catch (e) {
      return List.empty();
    }
  }

  //follow
  Future<bool> followSalon(id) async {
    try {
      final response = await dio.post('follow-salon/$id');
      final res = json.decode('$response');
      return res['data'];
    } catch (e) {
      return false;
    }
  }

  Future<bool> followArtist(id) async {
    try {
      final response = await dio.post('follow-artist/$id');
      final res = json.decode('$response');
      return res['data'];
    } catch (e) {
      return false;
    }
  }

  //profile
  Future<Media> changeAvatar(File file, String type) async {
    List<Media> links = await photo([file], type);
    if (links.isEmpty) {
      snackBar('Error');
      return null;
    } else {
      try {
        final response = await dio.post(
          'change-avatar',
          data: json.encode({
            'path': links.first.path,
            'name': links.first.name,
          }),
        );
        final res = json.decode('$response');
        print(res);
        if (res['success'])
          return Media.fromJson(res['data']);
        else {
          snackBar(res['message']);
          return null;
        }
      } catch (e) {
        print(e);
        return null;
      }
    }
  }

  Future<bool> removePhoto(id) async {
    try {
      final response = await dio.get('image-remove/$id');
      final res = json.decode('$response');
      print(res);
      if (!res['success']) snackBar(res['message']);
      return res['success'];
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> updateUserAvatar(avatar) async {
    try {
      final response = await dio.put('update_user_avatar/$avatar');
      print(response);
      var jsonResponse = jsonDecode('$response');
      return jsonResponse['success'];
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateUserBirthday(birthday) async {
    try {
      final response = await dio.put('update_user_birthday/$birthday');
      print(response);
      var jsonResponse = jsonDecode('$response');
      return jsonResponse['success'];
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateUserName(name) async {
    try {
      final response = await dio.put('update_user_name/$name');
      print(response);
      var jsonResponse = jsonDecode('$response');
      return jsonResponse['success'];
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateUserEmail(email) async {
    try {
      final response = await dio.put('update_user_email/$email');
      print(response);
      var jsonResponse = jsonDecode('$response');
      return jsonResponse['success'];
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateUserPhone(phone) async {
    try {
      final response = await dio.put('update_user_phone/$phone');
      print(response);
      var jsonResponse = jsonDecode('$response');
      return jsonResponse['success'];
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateUserGender(gender) async {
    try {
      final response = await dio.put('update_user_gender/$gender');
      print(response);
      var jsonResponse = jsonDecode('$response');
      return jsonResponse['success'];
    } catch (e) {
      return false;
    }
  }

  //setup
  Future<AppUser> joinSalon(id, code) async {
    try {
      final response = await dio.post(
        'join-salon',
        data: json.encode({'id': id, 'code': code}),
      );
      final res = json.decode('$response');
      snackBar(res['message']);
      if (res['success'])
        return AppUser.fromJson(res['data']);
      else
        return null;
    } catch (e) {
      return null;
    }
  }

  //specialist api
  Future<Artist> getMeAsArtist() async {
    try {
      final response =
          await dio.get('https://esalon.mn/api/specialist/me-as-artist');
      final res = json.decode('$response');
      if (res['success'])
        return Artist.fromJson(res['data']);
      else
        return null;
    } catch (e) {
      return null;
    }
  }

  Future<List<Post>> getMyPosts() async {
    try {
      final response =
          await dio.get('https://esalon.mn/api/specialist/my-posts');
      final res = json.decode('$response');
      if (res['success']) {
        List data = res['data'];
        return data.map((e) => Post.fromJson(e)).toList();
      } else
        return List.empty();
    } catch (e) {
      return List.empty();
    }
  }

  Future<List<ArtistOrder>> getMyOrders() async {
    try {
      final response =
          await dio.get('https://esalon.mn/api/specialist/my-orders');
      final res = json.decode('$response');
      if (res['success']) {
        List data = res['data'];
        return data.map((e) => ArtistOrder.fromJson(e)).toList();
      } else
        return List.empty();
    } catch (e) {
      return List.empty();
    }
  }

  Future<Post> addPost(List<File> photos, Post post, Artist me) async {
    List<Media> links = await photo(photos, 'posts');
    if (links.isEmpty) {
      snackBar('Error');
      return null;
    } else {
      try {
        final response = await dio.post(
          'add-post',
          data: json.encode({
            'title': post.body,
            'salon': me.salon.id,
            'salonpost': post.owner.type == 'salon',
            'tags': post.tags.map((e) => e.id).toList(),
            'photos': links
                .map((e) => {
                      'path': e.path,
                      'name': e.name,
                    })
                .toList(),
          }),
        );
        final res = json.decode('$response');
        print(res);
        if (res['success'])
          return Post.fromJson(res['data']);
        else {
          snackBar(res['message']);
          return null;
        }
      } catch (e) {
        print(e);
        return null;
      }
    }
  }

  Future<List<Media>> photo(List<File> files, type) async {
    fstorage.FirebaseStorage fbstorage = fstorage.FirebaseStorage.instance;
    List<Media> links = [];
    for (var i = 0; i < files.length; i++) {
      try {
        String path = "$type/image-" +
            DateFormat('yyyy-MM-dd-hh-mm-ss').format(DateTime.now()) +
            '-${app.user.id}$i';
        await fbstorage.ref().child(path).putFile(files.elementAt(i));
        Media link = Media(
          name: path,
          path: await fbstorage.ref().child(path).getDownloadURL(),
        );
        links.add(link);
      } on fstorage.FirebaseException catch (e) {
        print(e);
      }
    }

    return links;
  }

  Future<bool> addService(id) async {
    try {
      final response = await dio.get('add-service/$id');
      final res = json.decode('$response');
      if (!res['success']) snackBar(res['message']);
      return res['success'];
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> removeService(id) async {
    try {
      final response = await dio.get('remove-service/$id');
      final res = json.decode('$response');
      if (!res['success']) snackBar(res['message']);
      return res['success'];
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> orderStatus(id, status) async {
    try {
      final response = await dio.get('order-status/$id/$status');
      final res = json.decode('$response');
      if (!res['success']) snackBar(res['message']);
      return res['success'];
    } catch (e) {
      print(e);
      return false;
    }
  }
}
