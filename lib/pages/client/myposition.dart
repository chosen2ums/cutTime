import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:salon/helper/helper.dart';
import 'package:salon/provider/app_provider.dart' as app;

class MyPosition extends StatefulWidget {
  MyPosition({Key key}) : super(key: key);

  @override
  _MyPositionState createState() => _MyPositionState();
}

class _MyPositionState extends State<MyPosition> {
  GoogleMapController controller;
  BitmapDescriptor current;
  Marker marker = Marker(markerId: MarkerId('myPosition'));

  mapMode(String sw) => getJsonFile("assets/json/$sw.json").then(setMapStyle);

  Future<String> getJsonFile(String path) async =>
      await rootBundle.loadString(path);

  void setMapStyle(String mapStyle) => controller.setMapStyle(mapStyle);

  setIcon() async => current = BitmapDescriptor.fromBytes(
      await getBytesFromAsset('assets/svg/currentLocation.svg'));

  Future<Uint8List> getBytesFromAsset(String path) async {
    String svgString = await DefaultAssetBundle.of(context).loadString(path);
    DrawableRoot svgDrawableRoot = await svg.fromSvgString(svgString, null);
    final ratio = ui.window.devicePixelRatio.ceil();
    final width = Size(45, 45).width.ceil() * ratio;
    final height = Size(45, 45).height.ceil() * ratio;
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

  @override
  void initState() {
    setIcon();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    app.AppProvider provider = Provider.of(context);
    return WillPopScope(
      onWillPop: Helper.of(context).backPage,
      child: Material(
        child: Stack(
          children: [
            GoogleMap(
              mapType: MapType.normal,
              myLocationEnabled: false,
              myLocationButtonEnabled: false,
              compassEnabled: false,
              zoomControlsEnabled: false,
              markers: Set.from([marker]),
              initialCameraPosition: CameraPosition(
                target: LatLng(
                  provider.myposition.latitude,
                  provider.myposition.longitude,
                ),
                zoom: 15,
              ),
              onMapCreated: (GoogleMapController controller) {
                this.controller = controller;
                marker = Marker(
                  icon: current,
                  anchor: Offset(0.5, 0.5),
                  flat: true,
                  markerId: MarkerId('myPosition'),
                  draggable: true,
                  position: LatLng(
                    provider.myposition.latitude,
                    provider.myposition.longitude,
                  ),
                );
                setState(() {});
                if (MediaQuery.of(context).platformBrightness ==
                    Brightness.dark)
                  mapMode('dark');
                else
                  mapMode('light');
              },
            ),
          ],
        ),
      ),
    );
  }
}
