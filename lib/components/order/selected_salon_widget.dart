import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';
import 'package:salon/provider/order_provider.dart';
import 'package:salon/repository.dart';
import 'package:shape_of_view/shape_of_view.dart';

class SelectedSalonWidget extends StatelessWidget {
  SelectedSalonWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    OrderProvider val = Provider.of(context);
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.background,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
          color: Theme.of(context).colorScheme.secondary.withOpacity(0.2),
        ),
      ),
      margin: EdgeInsets.all(15),
      padding: EdgeInsets.all(0),
      height: 90,
      child: Row(
        children: [
          ShapeOfView(
            shape: RoundRectShape(borderRadius: BorderRadius.circular(5)),
            child: CachedNetworkImage(
              imageUrl: val.order.salon?.logo?.path ?? repo.empty,
              fit: BoxFit.cover,
              height: 90,
              width: 90,
            ),
          ),
          SizedBox(width: 15),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  val.order.salon?.name ?? '',
                  maxLines: 2,
                  softWrap: true,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    height: 1,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  repo.oformat.format(val.order.day),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).hintColor.withOpacity(0.75),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 15),
          TextButton(
            onPressed: () => print('change'),
            child: Icon(Ionicons.checkmark_outline, size: 30),
            style: ButtonStyle(
              visualDensity: VisualDensity.compact,
              shape: MaterialStateProperty.all(CircleBorder()),
              padding: MaterialStateProperty.all(EdgeInsets.all(20)),
              foregroundColor: MaterialStateProperty.all(Colors.white),
              backgroundColor: MaterialStateProperty.all(Theme.of(context).colorScheme.secondary),
              side: MaterialStateProperty.all(BorderSide(color: Theme.of(context).hintColor.withOpacity(0.2), width: 0)),
            ),
          ),
          SizedBox(width: 10),
        ],
      ),
    );
  }
}
