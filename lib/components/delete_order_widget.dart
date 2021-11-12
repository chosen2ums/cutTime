import 'package:flutter/material.dart';
import 'package:salon/models/order.dart';

class DeleteOrderWidget extends StatelessWidget {
  final Order order;
  DeleteOrderWidget(this.order, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Захиалга цуцлах',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
      content: RichText(
        textAlign: TextAlign.justify,
        text: TextSpan(
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: Theme.of(context).hintColor,
          ),
          children: [
            TextSpan(text: 'Энэ үйлдлийг хийснээр '),
            TextSpan(
              text: 'таны #${order.id}',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(text: ' дугаартай захиалга цуцлагдах болно!'),
          ],
        ),
      ),
      backgroundColor:
          Theme.of(context).colorScheme.background.withOpacity(0.8),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('үгүй'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(order.id),
          child: Text('тийм'),
        ),
      ],
    );
  }
}
