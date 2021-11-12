import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_week_view/flutter_week_view.dart';
import 'package:image_picker/image_picker.dart';
import 'package:salon/models/artist.dart';
import 'package:salon/models/artist_order.dart';
import 'package:salon/models/post.dart';
import 'package:salon/models/service.dart';
import 'package:salon/pages/artist/widgets/change_status_order.dart';
import 'package:salon/repository.dart';

class ArtistStateProvider with ChangeNotifier {
  ArtistStateProvider.instance();
  List<ArtistOrder> orders = List.empty();
  List<Post> posts = List.empty();
  bool loading = false;
  Artist me;

  stateRun() {
    getMe();
    getOrders();
    getPosts();
  }

  getMe() => repo.getMeAsArtist().then(updateMe);
  getOrders() => repo.getMyOrders().then(updateOrders);
  getPosts() => repo.getMyPosts().then(updatePosts);

  updateMe(me) {
    this.me = me;
    notifyListeners();
    fetchMySalonData();
  }

  updateOrders(orders) {
    this.orders = orders;
    updateEvents();
  }

  updatePosts(posts) {
    this.posts = posts;
    notifyListeners();
  }

  fetchMySalonData() async {
    await this.me.salon?.getServices();
    await this.me.salon?.getCategories();
    notifyListeners();
  }

  handleChangeService(Service service) async {
    loading = true;
    notifyListeners();
    int index =
        this.me.services.indexWhere((element) => element.id == service.id);
    bool status = await service.handleChange();
    if (status) {
      if (index == -1) this.me.services.add(service);
    } else {
      if (index != -1) this.me.services.removeAt(index);
    }
    loading = false;
    notifyListeners();
  }

  //Appointment
  DayViewController controller = DayViewController();
  HourMinute start = HourMinute(hour: 9, minute: 0);
  HourMinute end = HourMinute(hour: 22, minute: 0);
  List<FlutterWeekViewEvent> events = List.empty();
  DateTime selected = DateTime.now();
  DateTime focused = DateTime.now();

  selectDay(selected, focused) {
    this.selected = selected;
    this.focused = focused;
    updateEvents();
  }

  updateEvents() {
    List<FlutterWeekViewEvent> events = [];
    List<ArtistOrder> orders = this
        .orders
        .where(
          (element) =>
              repo.bformat.format(element.begin) ==
              repo.bformat.format(selected),
        )
        .toList();
    for (var order in orders) {
      Color color;
      switch (order.status) {
        case 'waiting':
          color = Colors.orange[200];
          break;
        case 'served':
          color = Colors.green[200];
          break;
        default:
      }
      FlutterWeekViewEvent event = new FlutterWeekViewEvent(
        title: '#${order.dadid}-${order.id} ${order.contact}',
        description:
            'Үйлчилгээ: ${order.service.name} \nХэрэглэгч: ${order.client?.name}',
        textStyle: TextStyle(fontSize: 12, color: Colors.white),
        end: order.end,
        start: order.begin,
        decoration: BoxDecoration(
          color: color,
          border: Border.all(
            color: Colors.white,
            width: 1,
          ),
        ),
        onTap: () => print('lol'),
        onLongPress:
            order.status == 'waiting' ? () => showStatusChanger(order) : null,
      );
      events.add(event);
    }
    this.events = events;
    notifyListeners();
  }

  showStatusChanger(order) async {
    String status = await showDialog(
      context: repo.app.navi.context,
      builder: (context) => ChangeStatusOrder(order),
    );
    if (status != null) {
      bool value = await repo.orderStatus(order.id, status);
      if (value) getOrders();
    }
  }

  //Post
  Post post;
  List<File> photos;
  PostOwner ownersalon, ownerme;
  addPost() async {
    ownersalon = PostOwner(
      id: this.me.salon.id,
      logo: this.me.salon.logo,
      name: this.me.salon.name,
      type: 'salon',
    );
    ownerme = PostOwner(
      id: this.me.id,
      logo: this.me.avatar,
      name: this.me.name,
      type: 'artist',
    );
    photos = [];
    post = Post(owner: ownersalon, tags: [], body: '');
    repo.app.navi.pushNamed('/AddPost');
  }

  backPost() {
    post = null;
    photos = null;
    repo.app.navi.pop();
  }

  savePost() async {
    if (photos.length != 0 && post.body != '') {
      loading = true;
      notifyListeners();
      Post newpost = await repo.addPost(photos, post, this.me);
      if (newpost != null) posts.insert(0, newpost);
      loading = false;
      notifyListeners();
      repo.app.navi.pop();
    } else
      repo.snackBar('Мэдээлэл дутуу байна');
  }

  addPhoto(type) async {
    final picker = ImagePicker();
    try {
      if (type == 0) {
        XFile pickedImage = await picker.pickImage(
          source: ImageSource.camera,
          imageQuality: 50,
        );
        if (pickedImage != null) insertFile(pickedImage);
        //Custom ESalon Camera
        // await repo.app.navi.pushNamed('/Camera');
      } else {
        List<XFile> pickedImage = await picker.pickMultiImage(imageQuality: 50);
        if (pickedImage != null) {
          for (var item in pickedImage) {
            insertFile(item);
          }
        }
      }
    } catch (e) {
      print(e);
    }
  }

  insertFile(XFile file) {
    File image = File(file.path);
    this.photos.add(image);
    notifyListeners();
  }

  removePhoto(photo) async {
    photos.removeWhere((element) => element == photo);
    notifyListeners();
  }

  changeTitle(val) {
    this.post.body = val;
    notifyListeners();
  }

  setOwner(issalon) {
    if (issalon)
      post.owner = ownersalon;
    else
      post.owner = ownerme;
    notifyListeners();
  }

  handleTags(tag) {
    int index = post.tags.indexWhere((element) => tag.id == element.id);
    if (index.isNegative)
      post.tags.add(PostTag(name: tag.name, id: tag.id));
    else
      post.tags.removeAt(index);
    notifyListeners();
  }
}
