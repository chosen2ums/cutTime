import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';
import 'package:salon/models/order.dart';
import 'package:salon/models/service.dart';
import 'package:salon/provider/app_provider.dart' as app;
import 'package:salon/provider/artist_provider.dart';

import 'single_service_widget.dart';

class ArtistServicesWidget extends StatefulWidget {
  ArtistServicesWidget({Key key}) : super(key: key);

  @override
  _ArtistServicesWidgetState createState() => _ArtistServicesWidgetState();
}

class _ArtistServicesWidgetState extends State<ArtistServicesWidget> {
  @override
  Widget build(BuildContext context) {
    app.AppProvider provider = Provider.of(context);
    ArtistProvider val = Provider.of(context);
    List<Service> services = ((val.category?.id ?? 0) == 0)
        ? val.artist.services
        : val.artist.services
            .where((e) => (e.category?.id ?? 0) == (val.category?.id ?? 0))
            .toList();
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) => AnimationConfiguration.staggeredList(
          position: index,
          duration: Duration(milliseconds: 200),
          child: FadeInAnimation(
            child: SingleServiceWidget(
              services.elementAt(index),
              onTap: val.selectService,
              checked: val.service == services.elementAt(index),
              order: (value) async {
                Order order = Order(
                  client: provider.user,
                  salon: val.artist.salon,
                  service: value,
                );
                provider.order(order);
              },
            ),
          ),
        ),
        childCount: services.length,
      ),
    );
    // Column(
    //   crossAxisAlignment: CrossAxisAlignment.start,
    //   children: [
    //     SizedBox(height: 10),
    //     Expanded(
    //       child: ListView.builder(
    //         shrinkWrap: true,
    //         padding: EdgeInsets.zero,
    //         itemCount: services.length,
    //         physics: ClampingScrollPhysics(),
    //         itemBuilder: (context, index) {
    //           return AnimationConfiguration.staggeredList(
    //             position: index,
    //             duration: Duration(milliseconds: 200),
    //             child: FadeInAnimation(
    //               child: SingleServiceWidget(
    //                 services.elementAt(index),
    //                 onTap: val.selectService,
    //                 checked: val.service == services.elementAt(index),
    //                 order: (value) async {
    //                   Order order = Order(
    //                     client: provider.user,
    //                     salon: val.salon,
    //                     service: value,
    //                   );
    //                   provider.order(order);
    //                 },
    //               ),
    //             ),
    //           );
    //         },
    //       ),
    //     )
    //   ],
    // );
  }
}
