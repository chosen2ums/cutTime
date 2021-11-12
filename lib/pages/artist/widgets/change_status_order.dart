import 'package:flutter/material.dart';
import 'package:salon/models/artist_order.dart';

class ChangeStatusOrder extends StatelessWidget {
  final ArtistOrder order;
  ChangeStatusOrder(this.order, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Захиалгын дугаар: #${order.dadid}-${order.id}',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              style: TextStyle(
                color: Theme.of(context).hintColor,
                fontSize: 13,
              ),
              children: [
                TextSpan(
                  text: 'Үйлчилгээ: ',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                TextSpan(text: '${order.service.name}\n'),
                TextSpan(
                  text: 'Хэрэглэгч: ',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                TextSpan(text: '${order.client.name}\n'),
                TextSpan(
                  text: 'Холбогдох утас: ',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                TextSpan(text: '${order.contact}'),
              ],
            ),
          ),
        ],
      ),
      actionsOverflowButtonSpacing: 10,
      actionsOverflowDirection: VerticalDirection.down,
      backgroundColor:
          Theme.of(context).colorScheme.background.withOpacity(0.8),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop('served'),
          child: Text('Дууссан'),
        ),
      ],
    );
  }
}
