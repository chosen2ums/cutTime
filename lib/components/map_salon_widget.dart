import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:salon/helper/loading.dart';
import 'package:salon/provider/filter_provider.dart';
import 'package:salon/repository.dart';

class MapSalonWidget extends StatefulWidget {
  MapSalonWidget({Key key}) : super(key: key);

  @override
  _MapSalonWidgetState createState() => _MapSalonWidgetState();
}

class _MapSalonWidgetState extends State<MapSalonWidget> {
  @override
  Widget build(BuildContext context) {
    FilterProvider filter = Provider.of(context);
    double width = MediaQuery.of(context).size.width * 0.8;
    double bottom = width * 0.6;
    return Stack(
      children: [
        StreamBuilder<Set<Marker>>(
          stream: filter.markerStream,
          builder: (context, snapshot) {
            if (snapshot.hasData)
              return GoogleMap(
                mapType: MapType.normal,
                myLocationEnabled: false,
                myLocationButtonEnabled: false,
                compassEnabled: false,
                zoomControlsEnabled: false,
                zoomGesturesEnabled: true,
                tiltGesturesEnabled: true,
                initialCameraPosition: CameraPosition(
                  target: filter.targeted,
                  zoom: filter.zoom,
                ),
                markers: snapshot.data,
                onMapCreated: (GoogleMapController controller) {
                  filter.controller = controller;
                  if (MediaQuery.of(context).platformBrightness == Brightness.dark)
                    filter.changeMapMode('dark');
                  else
                    filter.changeMapMode('light');
                },
              );
            else
              return Center(child: Loading(20));
          },
        ),
        Visibility(
          visible: filter.myPosition != null,
          child: Positioned(
            top: repo.statusBar + 40,
            bottom: bottom + 10,
            right: 0,
            child: RotatedBox(
              quarterTurns: -1,
              child: SliderTheme(
                data: SliderThemeData(
                  trackHeight: 1,
                  activeTrackColor: Theme.of(context).colorScheme.secondary,
                  inactiveTrackColor: Theme.of(context).hintColor.withOpacity(0.5),
                  thumbColor: Theme.of(context).colorScheme.secondary,
                  rangeThumbShape: RoundRangeSliderThumbShape(enabledThumbRadius: 6, disabledThumbRadius: 3, elevation: 5),
                  rangeTickMarkShape: RoundRangeSliderTickMarkShape(tickMarkRadius: 2),
                  inactiveTickMarkColor: Theme.of(context).hintColor.withOpacity(0.5),
                ),
                child: RangeSlider(
                  values: RangeValues(500, filter.selectedRadius == 5000.0 ? 2000.0 : filter.selectedRadius),
                  min: 500,
                  max: 2000,
                  divisions: 3,
                  onChangeEnd: (value) => filter.setRadius(value.end),
                  onChanged: (value) => print(value),
                ),
              ),
            ),
          ),
        ),
        Visibility(
          visible: filter.myPosition != null,
          child: Positioned(
            top: repo.statusBar + 60,
            bottom: bottom + 30,
            right: 35,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '5000m',
                  style: TextStyle(
                    fontSize: 12,
                    shadows: [Shadow(color: Theme.of(context).colorScheme.secondary.withOpacity(0.4), blurRadius: 1)],
                    color: filter.selectedRadius >= 5000.0 ? Theme.of(context).colorScheme.secondary : Theme.of(context).hintColor.withOpacity(0.5),
                  ),
                ),
                Text(
                  '1500m',
                  style: TextStyle(
                    fontSize: 12,
                    shadows: [Shadow(color: Theme.of(context).colorScheme.secondary.withOpacity(0.4), blurRadius: 1)],
                    color: filter.selectedRadius >= 1500.0 ? Theme.of(context).colorScheme.secondary : Theme.of(context).hintColor.withOpacity(0.5),
                  ),
                ),
                Text(
                  '1000m',
                  style: TextStyle(
                    fontSize: 12,
                    shadows: [Shadow(color: Theme.of(context).colorScheme.secondary.withOpacity(0.4), blurRadius: 1)],
                    color: filter.selectedRadius >= 1000.0 ? Theme.of(context).colorScheme.secondary : Theme.of(context).hintColor.withOpacity(0.5),
                  ),
                ),
                Text(
                  '500m',
                  style: TextStyle(
                    fontSize: 12,
                    shadows: [Shadow(color: Theme.of(context).colorScheme.secondary.withOpacity(0.4), blurRadius: 1)],
                    color: filter.selectedRadius >= 500.0 ? Theme.of(context).colorScheme.secondary : Theme.of(context).hintColor.withOpacity(0.5),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
