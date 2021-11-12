import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:salon/models/category.dart';
import 'package:salon/models/salon.dart';
import 'package:salon/repository.dart';

enum Ready { READY, UNREADY }

class FilterProvider with ChangeNotifier {
  BuildContext context;
  bool canPop;
  GoogleMapController controller;
  List<Salon> salons, filtered;
  List<Marker> markers = [];
  List<Category> categories, subcategories;
  Category category;
  LatLng targeted, myPosition;
  Ready ready;
  PageController pageController;
  FilterProvider.instance(this.context, this.salons, List<Category> categories, this.myPosition, {this.canPop})
      : pageController = PageController(initialPage: 0, viewportFraction: 0.8),
        this.categories = categories.where((e) => e.level == 1).toList(),
        this.subcategories = categories.where((e) => e.level == 2).toList(),
        category = categories.first,
        targeted = myPosition ?? LatLng(47.91892103945385, 106.9178472202153),
        ready = Ready.UNREADY {
    conf();
  }
  StreamController<Set<Marker>> markerController = StreamController();
  Stream<Set<Marker>> get markerStream => markerController.stream;
  double selectedRadius = 1000, zoom = 14.3;
  int prevPage = 0, currentPage = 0;

  void conf() async {
    this.salons.forEach((e) async => await e.getCategories());
    pageController..addListener(listener);
    filterSalon();
    updateMarkers();
    ready = Ready.READY;
    if (myPosition == null) getMyPosition();
    notifyListeners();
  }

  @override
  void dispose() {
    markerController..close();
    super.dispose();
  }

  void setMarker() => markerController.sink.add(Set.from(markers));

  bool requested = false;
  void getMyPosition() async {
    await repo.app.positionConfiguration();
    var status = await Permission.location.status;
    if (repo.app.myposition != null) {
      myPosition = repo.app.myposition;
      markers.removeAt(0);
      markers.insert(
        0,
        Marker(
          icon: repo.pin,
          anchor: Offset(0.5, 0.5),
          flat: true,
          markerId: MarkerId('my position'),
          draggable: true,
          position: this.myPosition,
        ),
      );
      setTargeted();
    } else {
      if (status.isDenied && !requested) {
        requested = true;
        await openAppSettings();
        getMyPosition();
      }
    }
  }

  filterSalon() {
    filtered = salons.where((e) => -1 != e.categories.indexWhere((e) => ((e.parent == category.id) || (e.id == category.id)))).toList();
    if (myPosition != null) filtered = filtered.where((e) => e.range(myPosition) <= selectedRadius).toList();
    notifyListeners();
    updateMarkers();
  }

  changeMapMode(String sw) => getJsonFile("assets/json/$sw.json").then(setMapStyle);

  Future<String> getJsonFile(String path) async => await rootBundle.loadString(path);

  void setMapStyle(String mapStyle) => controller.setMapStyle(mapStyle);

  void moveCamera() => controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: targeted,
            zoom: zoom,
            bearing: 0.0,
            tilt: 0.0,
          ),
        ),
      );

  void setTargeted({int targeted = 0}) {
    this.targeted = markers[targeted].position;
    updateMarkers();
    notifyListeners();
    moveCamera();
  }

  void setZoom(zoom, double radius) {
    this.zoom = zoom;
    this.selectedRadius = radius;
    filterSalon();
    moveCamera();
  }

  setRadius(double radius) {
    switch (radius.floor()) {
      case 500:
        setZoom(15.2, radius);
        break;
      case 1000:
        setZoom(14.3, radius);
        break;
      case 1500:
        setZoom(13.7, radius);
        break;
      case 2000:
        setZoom(12.0, 5000.0);
        break;
      default:
    }
  }

  void updateMarkers() {
    markers.clear();
    markers.add(
      Marker(
        icon: myPosition == null ? BitmapDescriptor.defaultMarker : repo.pin,
        anchor: Offset(0.5, 0.5),
        flat: true,
        markerId: MarkerId('Төв талбай'),
        draggable: true,
        position: this.myPosition ?? LatLng(47.91892103945385, 106.9178472202153),
      ),
    );
    filtered.asMap().forEach(
          (i, e) => markers.add(
            Marker(
              icon: prevPage == i ? repo.dotSelected : repo.dot,
              infoWindow: InfoWindow(title: e.name),
              onTap: () => pagination(i),
              flat: true,
              anchor: Offset(0.5, 0.5),
              markerId: MarkerId(e.id.toString()),
              draggable: true,
              position: e.position,
            ),
          ),
        );
    setMarker();
  }

  setCategory(category) {
    if (this.category != category) this.category = category;
    filterSalon();
  }

  listener() {
    if (pageController.page.round() != prevPage) {
      prevPage = pageController.page.round();
      currentPage = pageController.page.round();
      notifyListeners();
      setTargeted(targeted: pageController.page.round() + 1);
    }
  }

  pagination(int page) => pageController.animateToPage(page, duration: Duration(milliseconds: 100), curve: Curves.easeInOut);
}
