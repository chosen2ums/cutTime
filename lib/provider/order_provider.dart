import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:salon/models/category.dart';
import 'package:salon/models/order.dart';
import 'package:salon/models/salon.dart';
import 'package:salon/repository.dart';

class OrderProvider with ChangeNotifier {
  Order order;
  BuildContext context;
  List<Salon> salons, filtered;
  List<Category> categories, subcategories;
  OrderProvider.instance(
    this.order, {
    this.salons,
    this.context,
    List<Category> categories,
  })  : category = categories.first,
        this.categories = categories.where((e) => e.level == 1).toList(),
        this.subcategories = categories.where((e) => e.level == 2).toList() {
    conf();
  }
  Category category;
  bool loading = false;
  bool confirmState = false;
  bool terminate = false;

  conf() {
    salons.forEach((element) async {
      await element.getCategories();
      await element.getArtists();
    });
    filtered = salons;
    notifyListeners();
  }

  void setCategory(category) {
    this.category = category;
    notifyListeners();
    // filterArtist();
  }

  void setState({bool val}) {
    if (val == null)
      confirmState = !confirmState;
    else
      confirmState = val;
    repo.app.lockApp(confirmState);
    if (!confirmState) setTerminate(val: false);
    notifyListeners();
  }

  ///[ORDER_FILTER_SALON_BY_CATEGORY] Хэсэг хугацаанд ашиглахгүй байх санал ирсэл
  // void filterSalon() {
  //   filtered = salons.where((e) => -1 != e.categories.indexWhere((e) => e.id == category.id)).toList();
  //   notifyListeners();
  // }

  ///[ORDER_FILTER_ARTIST_BY_CATEGORY] Хэсэг хугацаанд ашиглахгүй байх санал ирсэл
  // void filterArtist() => order.services.last.updateArtists(
  //       order.services.last.artists
  //           .where((e) =>
  //               -1 !=
  //               e.categories.indexWhere(
  //                 (e) => e.id == category.id,
  //               ))
  //           .toList(),
  //     );

  void newOrderItem() {
    order.newItem();
    notifyListeners();
  }

  void removeLast() {
    order.removeLast();
    notifyListeners();
  }

  void setDay(day) {
    this.order.setDay(day);
    this.getTimeTable();
  }

  void calendarCreated() => this.order.services.last.fetchAvTime(this.order.day).then((value) {
        notifyListeners();
      });

  void calendarDisposed() {
    this.order.setDay(DateTime.now());
    this.order.services.last.setAge(0);
    this.order.services.last.setIndx(-1);
    this.order.services.last.setAvTime(List<String>.empty());
    this.order.services.first.setBegin(null);
  }

  setAvTime(avTime) {
    this.order.services.last.setAvTime(avTime);
    notifyListeners();
  }

  setAge(age) {
    this.order.services.last.setAge(age);
    notifyListeners();
    // getTimeTable();
  }

  void setTimeIndx(String time, indx) {
    this.order.services.last.setIndx(indx);
    if (time == null)
      this.order.services.last.setBegin(null);
    else
      this.order.services.last.setBegin(
            repo.ordertime.parse(
              repo.orderday.format(this.order.day) + ' ' + time,
            ),
          );

    notifyListeners();
  }

  getTimeTable() async {
    setAvTime(null);
    setTimeIndx(null, -1);
    await this.order.fetchAvTime();
    notifyListeners();
  }

  void settime(time) {
    this.order.services.last.setBegin(time);
    notifyListeners();
  }

  setService(service) async {
    this.order.services.last.setService(service);
    if (service != null) this.order.ssArtist();
    notifyListeners();
  }

  setSalon(salon) async {
    await this.order.setSalon(salon);
    notifyListeners();
  }

  void setArtist(artist) async {
    await this.order.setArtist(artist);
    notifyListeners();
  }

  void updateArtist(artist) async {
    if (this.order.services.last.artist != artist) {
      this.order.updateArtist(artist);
      getTimeTable();
    }
  }

  post() async {
    loading = true;
    notifyListeners();
    List<int> ids = await repo.postOrder(order);
    if (ids != null) {
      this.order.setId(ids.first);
      this.order.services.last.setId(ids.last);
      repo.app.lockApp(true);
    }
    loading = false;
    notifyListeners();
  }

  postDetail() async {
    loading = true;
    notifyListeners();
    if (order.services.last.begin != null) {
      int newid = await repo.postOrderDetail(order.services.last, order.id);
      if (newid == null)
        this.order.removeLast();
      else
        order.services.last.setId(newid);
      loading = false;
      notifyListeners();
    } else
      Fluttertoast.showToast(
        msg: 'Үйлчилгээ авах цагаа сонгон уу!',
        gravity: ToastGravity.SNACKBAR,
      );
  }

  Future<bool> confirmOrder() async => await repo.confirmOrder(order.id);

  resetOrder() {
    this.order = new Order(client: repo.app.user);

    notifyListeners();
  }

  removeDetail(id, length) async {
    if (length == 1)
      setTerminate();
    else {
      bool status = await repo.deleteOrderDetail(id);
      if (status) this.order.removeAt(this.order.services.indexWhere((e) => e.id == id));
    }
    notifyListeners();
  }

  setTerminate({bool val}) {
    if (val == null)
      terminate = !terminate;
    else
      terminate = val;
    notifyListeners();
  }

  cancel() async {
    repo.deleteOrder(order.id);
    switch (order.type) {
      case Type.ARTIST:
        order = Order(
          salon: order.salon,
          client: repo.app.user,
          artist: order.services.first.artist,
        );
        break;
      case Type.SALON:
        order = Order(client: repo.app.user, salon: order.salon);
        break;
      default:
        order = Order(client: repo.app.user);
    }
    repo.app.lockApp(false);
    setState();
  }
}
