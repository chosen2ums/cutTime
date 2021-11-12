import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salon/pages/artist/widgets/artist_service_widget.dart';
import 'package:salon/provider/artist_state_provider.dart';

class MyServicesWidget extends StatefulWidget {
  MyServicesWidget({Key key}) : super(key: key);

  @override
  _MyServicesWidgetState createState() => _MyServicesWidgetState();
}

class _MyServicesWidgetState extends State<MyServicesWidget> {
  @override
  Widget build(BuildContext context) {
    ArtistStateProvider val = Provider.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 10),
          child: Text(
            'Идэвхтэй үйлчилгээ ${val.me.services.length}',
            style: TextStyle(
              color: Theme.of(context).hintColor.withOpacity(0.75),
              fontSize: 16,
              fontWeight: FontWeight.w800,
              shadows: [
                Shadow(
                  blurRadius: 5,
                  color: Colors.black12,
                  offset: Offset(0, 3),
                )
              ],
            ),
          ),
        ),
        ListView.separated(
          itemCount: val.me.salon?.services?.length ?? 0,
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          itemBuilder: (context, index) =>
              ArtistServiceWidget(val.me.salon?.services?.elementAt(index)),
          separatorBuilder: (context, index) => SizedBox(height: 10),
        ),
        Container(
          height: 40,
          width: double.infinity,
          margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: TextButton(
            onPressed: () => print('test'),
            child: Text('Шинэ үйлчилгээний хүсэлт'),
            style: ButtonStyle(
              visualDensity: VisualDensity.compact,
              foregroundColor: MaterialStateProperty.all(Colors.white),
              backgroundColor: MaterialStateProperty.all(
                  Theme.of(context).colorScheme.secondary),
              shape: MaterialStateProperty.all(StadiumBorder()),
            ),
          ),
        )
      ],
    );
  }
}
