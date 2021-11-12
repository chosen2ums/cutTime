import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';
import 'package:salon/components/salon_artists_widget.dart';
import 'package:salon/helper/loading.dart';
import 'package:salon/provider/app_provider.dart' as app;
import 'package:salon/provider/salon_provider.dart';
import 'package:salon/repository.dart';
import 'package:url_launcher/url_launcher.dart';

class SalonAboutWidget extends StatefulWidget {
  SalonAboutWidget({Key key}) : super(key: key);

  @override
  _SalonAboutWidgetState createState() => _SalonAboutWidgetState();
}

class _SalonAboutWidgetState extends State<SalonAboutWidget> {
  GoogleMapController controller;
  List<Marker> markers = List<Marker>.empty(growable: true);
  bool isExpanded = true;
  bool isCreated = false;

  mapMode(String sw) => getJsonFile("assets/json/$sw.json").then(setMapStyle);

  Future<String> getJsonFile(String path) async => await rootBundle.loadString(path);

  void setMapStyle(String mapStyle) => controller.setMapStyle(mapStyle);

  @override
  void initState() {
    created();
    super.initState();
  }

  created() async {
    await Future.delayed(Duration(seconds: 1));
    isCreated = true;
    if (this.mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    SalonProvider val = Provider.of(context);
    app.AppProvider provider = Provider.of(context);
    return SingleChildScrollView(
      physics: ClampingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Visibility(
            visible: val.salon.artists?.length != 0,
            child: SalonArtistsWidget(),
          ),
          Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10),
                abouts(
                  'Цагийн хуваарь',
                  Column(
                    children: List.generate(
                      val.salon.timeTable.length,
                      (index) => Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Ionicons.at_circle,
                                size: 10,
                                color: Colors.green,
                              ),
                              SizedBox(width: 10),
                              Text(
                                val.salon.timeTable.elementAt(index).day,
                                style: TextStyle(
                                  color: Theme.of(context).hintColor.withOpacity(0.6),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            val.salon.timeTable.elementAt(index).st + ' - ' + val.salon.timeTable.elementAt(index).nd,
                            style: TextStyle(color: Theme.of(context).hintColor.withOpacity(0.6), fontSize: 13, fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                abouts(
                  'Холбоо барих',
                  Padding(
                    padding: EdgeInsets.fromLTRB(25, 10, 25, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: () => launch('tel:${val.salon.phone}'),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Icon(Ionicons.call_outline),
                              SizedBox(width: 30),
                              Text(
                                '+976 ${val.salon.phone}',
                                style: TextStyle(
                                  color: Theme.of(context).hintColor.withOpacity(0.6),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 5),
                        InkWell(
                          onTap: () => print('zalhaj baina'),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Icon(Ionicons.mail_outline),
                              SizedBox(width: 30),
                              Text(
                                '${val.salon.email}',
                                style: TextStyle(
                                  color: Theme.of(context).hintColor.withOpacity(0.6),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 5),
                        val.salon.fb == null
                            ? Container()
                            : Row(
                                children: [
                                  Icon(Ionicons.logo_facebook),
                                  SizedBox(width: 30),
                                  Text(
                                    '${val.salon.fb}',
                                    style: TextStyle(
                                      color: Theme.of(context).hintColor.withOpacity(0.6),
                                    ),
                                  ),
                                ],
                              ),
                        SizedBox(height: 30),
                        RichText(
                          text: TextSpan(
                            style: TextStyle(
                                color: Theme.of(context).hintColor.withOpacity(0.6),
                                fontSize: 10,
                                fontWeight: FontWeight.w400,
                                fontStyle: FontStyle.italic),
                            children: [
                              TextSpan(text: val.salon.location),
                              TextSpan(text: ", "),
                              TextSpan(text: val.salon.address),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 15),
                isCreated
                    ? Container(
                        height: MediaQuery.of(context).size.width,
                        child: GoogleMap(
                          mapType: MapType.normal,
                          myLocationEnabled: false,
                          myLocationButtonEnabled: false,
                          compassEnabled: false,
                          initialCameraPosition: CameraPosition(
                            zoom: 13,
                            target: val.salon.position,
                          ),
                          markers: Set.of(markers),
                          onMapCreated: (GoogleMapController controller) {
                            this.controller = controller;

                            markers.addAll(
                              [
                                Marker(
                                  icon: repo.dotSelected,
                                  anchor: Offset(0.5, 0.5),
                                  flat: true,
                                  markerId: MarkerId('${val.salon.id}'),
                                  draggable: true,
                                  position: val.salon.position,
                                ),
                                Marker(
                                  icon: repo.pin,
                                  anchor: Offset(0.5, 0.5),
                                  flat: true,
                                  markerId: MarkerId('myPosition'),
                                  draggable: true,
                                  position: LatLng(
                                    provider.myposition.latitude,
                                    provider.myposition.longitude,
                                  ),
                                ),
                              ],
                            );
                            setState(() {});
                            if (MediaQuery.of(context).platformBrightness == Brightness.dark)
                              mapMode('dark');
                            else
                              mapMode('light');
                          },
                        ),
                      )
                    : Center(child: Loading(16)),
                SizedBox(height: 15),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget abouts(String title, Widget body) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Text(
            title,
            style: TextStyle(
              color: Theme.of(context).hintColor.withOpacity(0.8),
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        SizedBox(
          height: 5,
        ),
        body,
      ],
    );
  }
}
