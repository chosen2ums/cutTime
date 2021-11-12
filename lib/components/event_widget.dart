import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:salon/models/order_item.dart';
import 'package:salon/repository.dart';
import 'package:shape_of_view/shape_of_view.dart';

class EventWidget extends StatelessWidget {
  final OrderItem item;
  EventWidget({this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.background,
        borderRadius: BorderRadius.horizontal(
          left: Radius.circular(70),
          right: Radius.circular(10),
        ),
        border: Border.all(color: Colors.white12, width: 1),
        boxShadow: [
          BoxShadow(
            blurRadius: 5,
            spreadRadius: 2,
            color: Colors.black12,
            offset: Offset(-2, 2),
          )
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ShapeOfView(
            shape: CircleShape(borderColor: Colors.white, borderWidth: 1),
            child: CachedNetworkImage(
              imageUrl: item.artist.avatar?.path ?? repo.empty,
              fit: BoxFit.cover,
              height: 70,
              width: 70,
            ),
          ),
          SizedBox(width: 15),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(
                  item.artist.name ?? 'Артист',
                  style: TextStyle(
                      color: Theme.of(context).hintColor,
                      fontSize: 24,
                      fontWeight: FontWeight.w600),
                ),
                Row(
                  children: [
                    Text(
                      "Үйлчилгээ",
                      style: TextStyle(
                        color: Theme.of(context).hintColor.withOpacity(0.8),
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 6),
                      child: Icon(
                        Ionicons.at_circle,
                        color: Theme.of(context).hintColor,
                        size: 5,
                      ),
                    ),
                    Text(
                      item.service.name,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      "${item.service.duration} min",
                      style: TextStyle(
                        color: Theme.of(context).hintColor.withOpacity(0.8),
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 6),
                      child: Icon(
                        Ionicons.at_circle,
                        color: Theme.of(context).hintColor,
                        size: 5,
                      ),
                    ),
                    Text(
                      "₮${item.service.price}",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Text(repo.onlytime.format(item.begin)),
          SizedBox(width: 10),
        ],
      ),
    );
  }
}
