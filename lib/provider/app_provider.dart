import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:salon/components/artist_widget.dart';
import 'package:salon/components/comment_widget.dart';
import 'package:salon/models/app_user.dart';
import 'package:salon/models/artist.dart';
import 'package:salon/models/category.dart';
import 'package:salon/models/order.dart';
import 'package:salon/models/post.dart';
import 'package:salon/models/salon.dart';
import 'package:salon/models/service.dart';
import 'package:salon/repository.dart';

//0xFF715D83
enum State { Client, Artist }
enum Status { Undefined, Authorized, Unauthorized, Authorizing }
final dark = ThemeData(
  fontFamily: 'Raleway',
  appBarTheme: AppBarTheme(backgroundColor: ThemeData.dark().scaffoldBackgroundColor, foregroundColor: Colors.white),
  colorScheme: ColorScheme.dark(
    secondary: Color(0xFF9054E7),
    secondaryVariant: Color(0xFFF88E77),
  ),
  hintColor: Colors.white,
  dividerColor: Colors.white54,
);
final light = ThemeData(
  fontFamily: 'Raleway',
  appBarTheme: AppBarTheme(backgroundColor: Colors.white, foregroundColor: Colors.black),
  colorScheme: ColorScheme.light(
    secondary: Color(0xFF9054E7),
    secondaryVariant: Color(0xFFF88E77),
  ),
  hintColor: Colors.black,
  dividerColor: Colors.black54,
);

class AppProvider with ChangeNotifier {
  State _state;
  Status _status;
  FirebaseAuth _auth;
  final GlobalKey<NavigatorState> key;
  final GetStorage storage;
  bool lock = false, isGoogle = false;
  LatLng myposition;
  AppProvider.instance()
      : _status = Status.Undefined,
        _auth = FirebaseAuth.instance,
        key = GlobalKey<NavigatorState>(),
        storage = GetStorage() {
    _auth.authStateChanges().listen(authStateListener);
    bool isclient = repo.storage.read('state') ?? true;
    changeState(isclient ? State.Client : State.Artist);
  }
  AppUser user;

  List<Post> posts;
  List<Salon> salons = List.empty(growable: true);
  List<Artist> artists = List.empty(growable: true);
  List<Service> services = List.empty(growable: true);
  List<Order> orders = List.empty(growable: true);
  List<Category> categories = [];

  FirebaseAuth get auth => _auth;
  State get state => _state;
  Status get status => _status;
  NavigatorState get navi => key.currentState;

  Future positionConfiguration() async {
    if (storage.hasData('position'))
      myposition = json.decode(storage.read('position'));
    else
      await Geolocator.getCurrentPosition().then(setMyLocation).catchError((msg) => setMyLocation(null));
    return null;
  }

  setMyLocation(Position position) => myposition = position == null ? null : LatLng(position.latitude, position.longitude);

  authStateListener(User fbuser) async {
    if (fbuser == null) {
      changeStatus(Status.Unauthorized);
      navi.pushNamedAndRemoveUntil('/Home', (route) => true);
    } else {
      final token = await getToken(fbuser);
      repo.setToken(token);
      user = await repo.login(fbuser);
      if (user == null)
        logOut();
      else {
        changeStatus(Status.Undefined);
        await positionConfiguration();
        changeStatus(Status.Authorized);
      }
    }
  }

  Future<String> getToken(User fbuser) async {
    try {
      return await fbuser.getIdToken(true);
    } catch (e) {
      return '';
    }
  }

  changeState(state) {
    _state = state;
    notifyListeners();
    if (state == State.Artist) {
      storage.write('state', false);
      repo.setDioOptions('specialist');
    } else {
      storage.write('state', true);
      repo.setDioOptions('client');
    }
  }

  changeStatus(status) {
    _status = status;
    notifyListeners();
  }

  lockApp(val) {
    lock = val;
    notifyListeners();
  }

  updateMe(user) {
    this.user = user;
    notifyListeners();
  }

  updateUserInfo(title, text) async {
    await user.update(title, text);
    notifyListeners();
  }

  changeProfile() async {
    await user.changeProfile();
    notifyListeners();
  }

  updatePosts(posts) {
    this.posts = posts;
    notifyListeners();
  }

  updateSalons(salons) {
    this.salons = salons;
    notifyListeners();
  }

  updateArtists(artists) {
    this.artists = artists;
    notifyListeners();
  }

  updateCategories(categories) {
    this.categories = categories;
    this.categories.insert(
          0,
          Category(
            id: 0,
            level: 1,
            engName: 'All',
            monName: 'Бүгд',
          ),
        );
    notifyListeners();
  }

  updateServices(services) {
    this.services = services;
    notifyListeners();
  }

  updateOrders(orders) {
    this.orders = orders;
    notifyListeners();
  }

  createOrder({Salon salon}) async {
    Order order = await navi.pushNamed(
      '/Order',
      arguments: Order(client: user, salon: salon),
    );
    if (order != null) addOrder(order);
  }

  deleteOrder(id) {
    repo.deleteOrder(id);
    orders.removeWhere((element) => element.id == id);
    notifyListeners();
  }

  addOrder(order) {
    if (this.orders.isEmpty)
      this.orders = [order];
    else
      this.orders.insert(0, order);
    lockApp(false);
  }

  logOut() async => await _auth.signOut();

  loginGoogle() async {
    isGoogle = true;
    changeStatus(Status.Authorizing);
    try {
      GoogleSignIn googleSignIn = GoogleSignIn();
      GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
      GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;
      AuthCredential credential =
          GoogleAuthProvider.credential(accessToken: googleSignInAuthentication.accessToken, idToken: googleSignInAuthentication.idToken);
      _auth.signInWithCredential(credential);
    } catch (e) {
      print(e);
      changeStatus(Status.Unauthorized);
    }
  }

  loginFacebook() async {
    isGoogle = false;
    changeStatus(Status.Authorizing);
    try {
      LoginResult result = await FacebookAuth.instance.login();
      if (result.status == LoginStatus.success) {
        AuthCredential credential = FacebookAuthProvider.credential(result.accessToken.token);
        await auth.signInWithCredential(credential);
      } else {
        Fluttertoast.showToast(
          msg: result.message,
          gravity: ToastGravity.SNACKBAR,
        );
        changeStatus(Status.Unauthorized);
      }
    } catch (e) {
      print(e);
      changeStatus(Status.Unauthorized);
    }
  }

  clientStateCreated() {
    getPosts();
    getSalons();
    getArtists();
    getCategories();
    getServices();
    getOrders();
  }

  getPosts() => repo.getPosts().then(updatePosts);
  getSalons() => repo.getSalons().then(updateSalons);
  getArtists() => repo.getArtists().then(updateArtists);
  getCategories() => repo.getCategories().then(updateCategories);
  getServices() => repo.getServices().then(updateServices);
  getOrders() => repo.getOrders().then(updateOrders);

  //
  order(Order order) async {
    navi.pop(order);
    storage.write('page', 1);
  }

  showPostOwner(context, PostOwner owner) {
    if (owner.type == 'salon')
      showSalon(context, owner);
    else
      showArtist(context, owner);
  }

  showSalon(context, salon, {int access = 1}) async {
    if (access == 1) {
      demoorder = await navi.pushNamed<Order>(
        '/Salon',
        arguments: salons.firstWhere(
          (e) => e.id == salon.id,
          orElse: () => null,
        ),
      );
    }
    notifyListeners();
  }

  showArtist(context, artist) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(13)),
      ),
      builder: (BuildContext context) => ArtistWidget(
        artists.firstWhere((e) => e.id == artist.id, orElse: () => null),
      ),
    );
    notifyListeners();
  }

  showCommentSheet(context, Post post) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(13)),
      ),
      builder: (BuildContext context) => new CommentWidget(post),
    );
  }

  //
  Order demoorder;
}
