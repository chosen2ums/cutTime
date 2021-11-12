import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salon/components/delete_order_widget.dart';
import 'package:salon/models/order.dart';
import 'package:salon/provider/app_provider.dart' as app;
import 'package:salon/repository.dart';
import 'package:shape_of_view/shape_of_view.dart';
import 'package:url_launcher/url_launcher.dart';

class SingleOrderWidget extends StatefulWidget {
  final Order order;
  SingleOrderWidget(this.order, {Key key}) : super(key: key);

  @override
  _SingleOrderWidgetState createState() => _SingleOrderWidgetState();
}

class _SingleOrderWidgetState extends State<SingleOrderWidget> {
  @override
  Widget build(BuildContext context) {
    app.AppProvider provider = Provider.of(context);
    Color color;
    switch (widget.order.status) {
      case 'approved':
        color = Colors.green[200];
        break;
      case 'canceled':
        color = Colors.red[300];
        break;
      case 'finished':
        color = Colors.blue[200];
        break;
      case 'pending':
        color = Colors.orange[200];
        break;
      default:
        color = Colors.red[200];
    }
    return InkWell(
      onLongPress: () async {
        int deleteorderid = await showDialog(
          context: context,
          builder: (context) => DeleteOrderWidget(widget.order),
        );
        if (deleteorderid != null) provider.deleteOrder(deleteorderid);
      },
      child: Container(
        color: color,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: color, width: 0.2),
            color: Theme.of(context).colorScheme.background,
          ),
          margin: EdgeInsets.only(right: 5),
          height: 120,
          width: double.infinity,
          child: Stack(
            children: [
              Positioned(
                left: 10,
                top: 10,
                bottom: 25,
                width: 70,
                child: GestureDetector(
                  onTap: () => provider.showSalon(context, widget.order.salon),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      ShapeOfView(
                        shape: CircleShape(),
                        child: CachedNetworkImage(
                          imageUrl: widget.order.salon.logo?.path ?? repo.empty,
                          fit: BoxFit.cover,
                          height: 65,
                          width: 65,
                        ),
                      ),
                      Text(
                        widget.order.salon.name,
                        maxLines: 1,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.clip,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).hintColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 10,
                bottom: 5,
                width: 70,
                child: InkWell(
                  onTap: () => launch('tel:${widget.order.salon.phone}'),
                  child: Text(
                    widget.order.salon.phone,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ),
              Positioned(
                left: 110,
                top: 10,
                right: 5,
                child: Row(
                  children: [
                    Expanded(
                      child: RichText(
                        maxLines: 2,
                        textAlign: TextAlign.justify,
                        text: TextSpan(
                          style: TextStyle(
                            color: Theme.of(context).hintColor,
                            fontWeight: FontWeight.w400,
                            fontSize: 10,
                          ),
                          children: [
                            TextSpan(text: 'Захиалгын дугаар'),
                            TextSpan(
                              text: ' #${widget.order.id}',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 20),
                    Expanded(
                      child: RichText(
                        maxLines: 2,
                        textAlign: TextAlign.justify,
                        text: TextSpan(
                          style: TextStyle(
                            color: Theme.of(context).hintColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                          ),
                          children: [
                            TextSpan(text: '${repo.oformat.format(widget.order.services.first.begin)}'),
                            TextSpan(
                              text: ' ${repo.onlytime.format(widget.order.services.first.begin)}',
                              style: TextStyle(fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 5,
                left: 110,
                right: 5,
                height: 75,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.fromLTRB(5, 0, 4, 0),
                  itemBuilder: (context, index) => Container(
                    width: 50,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ShapeOfView(
                          shape: RoundRectShape(
                            borderRadius: BorderRadius.circular(15),
                            borderColor: Colors.white,
                            borderWidth: 1,
                          ),
                          child: CachedNetworkImage(
                            imageUrl: widget.order.services.elementAt(index).service.image?.path ?? repo.empty,
                            height: 50,
                            width: 50,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          widget.order.services.elementAt(index).service.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12,
                            color: Theme.of(context).hintColor.withOpacity(0.6),
                          ),
                        ),
                      ],
                    ),
                  ),
                  separatorBuilder: (context, index) => SizedBox(width: 10),
                  itemCount: widget.order.services.length,
                ),
              ),
              Positioned(
                bottom: 30,
                right: 30,
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.background.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  padding: EdgeInsets.fromLTRB(5, 2, 5, 2),
                  child: Text(
                    '${(widget.order.total / 1000).toStringAsFixed(1)}',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
