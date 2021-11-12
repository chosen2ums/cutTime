import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';
import 'package:salon/models/service.dart';
import 'package:salon/provider/order_provider.dart';
import 'package:salon/repository.dart';

class SelectedServiceWidget extends StatelessWidget {
  final Service service;
  SelectedServiceWidget(this.service, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    OrderProvider val = Provider.of(context);
    return InkWell(
      onTap: () => val.setService(null),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(
            color: Theme.of(context).colorScheme.secondary.withOpacity(0.2),
          ),
        ),
        margin: EdgeInsets.symmetric(vertical: 15),
        padding: EdgeInsets.all(2),
        height: 90,
        child: Row(
          children: [
            CachedNetworkImage(
              imageUrl: service.image?.path ?? repo.empty,
              fit: BoxFit.cover,
              width: 120,
              height: 90,
            ),
            SizedBox(width: 20),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    service.name,
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        val.order.salon.name,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).hintColor.withOpacity(0.75),
                        ),
                      ),
                      Text(
                        (service.price / 1000).toStringAsFixed(1),
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
            SizedBox(width: 15),
            TextButton(
              onPressed: () => print('check'),
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
      ),
    );
  }
}
