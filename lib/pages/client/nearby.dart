import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';
import 'package:salon/components/salon_list_widget.dart';
import 'package:salon/components/map_salon_widget.dart';
import 'package:salon/components/single_category_widget.dart';
import 'package:salon/helper/error.dart';
import 'package:salon/helper/loading.dart';
import 'package:salon/provider/app_provider.dart' as app;
import 'package:salon/provider/filter_provider.dart';
import 'package:salon/repository.dart';

class Nearby extends StatefulWidget {
  final bool canPop;
  Nearby({this.canPop = false, Key key}) : super(key: key);

  @override
  _NearbyState createState() => _NearbyState();
}

class _NearbyState extends State<Nearby> {
  bool isShown = false;

  void handleFilter() {
    isShown = !isShown;
    setState(() {
      // ignore: unnecessary_statements
      isShown;
    });
  }

  @override
  Widget build(BuildContext context) {
    app.AppProvider provider = Provider.of(context);
    return WillPopScope(
      onWillPop: () async {
        if (widget.canPop)
          return true;
        else
          return false;
      },
      child: Material(
        child: ChangeNotifierProvider(
          create: (_) => FilterProvider.instance(
            context,
            provider.salons.where((e) => e.isDone).toList(),
            provider.categories,
            repo.app.myposition != null ? LatLng(provider.myposition.latitude, provider.myposition.longitude) : null,
            canPop: widget.canPop,
          ),
          child: Consumer<FilterProvider>(
            builder: (context, value, child) {
              switch (value.ready) {
                case Ready.UNREADY:
                  return Center(child: Loading(20));
                  break;
                case Ready.READY:
                  return Stack(
                    children: [
                      Positioned(
                        left: 0,
                        top: 0,
                        right: 0,
                        bottom: 0,
                        child: MapSalonWidget(),
                      ),
                      Positioned(
                        top: repo.statusBar + 15,
                        left: 10,
                        right: 0,
                        height: 38,
                        child: Row(
                          children: [
                            SizedBox(
                              width: 38,
                              height: 38,
                              child: TextButton(
                                onPressed: handleFilter,
                                child: Icon(Ionicons.funnel_outline, size: 20),
                                style: ButtonStyle(
                                  elevation: MaterialStateProperty.all(10),
                                  padding: MaterialStateProperty.all(EdgeInsets.zero),
                                  foregroundColor: MaterialStateProperty.all(Colors.white),
                                  backgroundColor: MaterialStateProperty.all(Theme.of(context).colorScheme.secondary),
                                  shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(13))),
                                ),
                              ),
                            ),
                            Expanded(
                              child: !isShown
                                  ? Container()
                                  : ListView.separated(
                                      itemCount: value.categories.length,
                                      scrollDirection: Axis.horizontal,
                                      physics: const AlwaysScrollableScrollPhysics(),
                                      cacheExtent: 999999,
                                      itemBuilder: (context, index) => AnimationConfiguration.staggeredList(
                                        position: index,
                                        child: FlipAnimation(
                                          child: FadeInAnimation(
                                            child: SingleCategoryWidget(
                                              value.categories.elementAt(index),
                                              onTap: value.setCategory,
                                              selected: value.category == value.categories.elementAt(index),
                                            ),
                                          ),
                                        ),
                                      ),
                                      separatorBuilder: (context, index) => SizedBox(width: 0),
                                    ),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        top: repo.statusBar + 60,
                        left: 10,
                        width: 38,
                        child: SizedBox(
                          width: 38,
                          height: 38,
                          child: TextButton(
                            onPressed: value.getMyPosition,
                            child: Icon(Ionicons.locate_outline, size: 20),
                            style: ButtonStyle(
                              elevation: MaterialStateProperty.all(10),
                              padding: MaterialStateProperty.all(EdgeInsets.zero),
                              foregroundColor: MaterialStateProperty.all(Colors.white),
                              backgroundColor: MaterialStateProperty.all(Theme.of(context).colorScheme.secondary),
                              shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(13))),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        child: SalonListWidget(),
                      ),
                    ],
                  );
                  break;
                default:
                  return Center(child: Error(detail: 'un'));
              }
            },
          ),
        ),
      ),
    );
  }
}
