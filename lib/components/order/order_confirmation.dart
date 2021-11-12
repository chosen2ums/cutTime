import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';
import 'package:salon/helper/finish.dart';
import 'package:salon/models/order_item.dart';
import 'package:salon/provider/order_provider.dart';
import 'package:salon/repository.dart';
import 'package:shape_of_view/shape_of_view.dart';

import 'additional_widget.dart';

class OrderConfirmation extends StatefulWidget {
  final Function change;
  OrderConfirmation(this.change, {Key key}) : super(key: key);

  @override
  _OrderConfirmationState createState() => _OrderConfirmationState();
}

class _OrderConfirmationState extends State<OrderConfirmation> {
  @override
  Widget build(BuildContext context) {
    OrderProvider val = Provider.of(context);
    List<OrderItem> services = val.order.services;
    return WillPopScope(
      onWillPop: () async {
        if (val.terminate) {
          val.setTerminate();
          return false;
        }
        if (services.last.id == null && val.order.services.length != 1)
          val.removeLast();
        else
          val.setTerminate();
        return false;
      },
      child: services.last.id == null && val.order.services.length != 1
          ? AdditionalWidget()
          : Container(
              height: double.infinity,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      height: 220,
                      child: Stack(
                        children: [
                          Positioned(
                            top: 0,
                            left: 0,
                            right: 0,
                            bottom: 50,
                            child: CachedNetworkImage(
                              imageUrl: val.order.salon?.cover?.path ??
                                  'https://assets-us-01.kc-usercontent.com/0542d611-b6d8-4320-a4f4-35ac5cbf43a6/2fb8b3d5-db7a-4261-8058-8e09531ff76a/salon-insurance-header.jpg?w=1110&h=400&fit=crop',
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                SizedBox(width: 30),
                                ShapeOfView(
                                  shape: CircleShape(),
                                  child: CachedNetworkImage(
                                    imageUrl: val.order.salon?.logo?.path ?? repo.empty,
                                    fit: BoxFit.cover,
                                    height: 100,
                                    width: 100,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                    bottom: 13,
                                    left: 10,
                                  ),
                                  child: Text(
                                    val.order.salon?.name ?? '',
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 30),
                    Row(
                      children: [
                        SizedBox(width: 20),
                        Icon(
                          Ionicons.calendar_number_outline,
                          color: Theme.of(context).hintColor.withOpacity(0.8),
                          size: 16,
                        ),
                        SizedBox(width: 10),
                        Text(
                          repo.bformat.format(val.order.day),
                          style: TextStyle(
                            letterSpacing: -0.2,
                            fontSize: 12,
                            color: Theme.of(context).hintColor.withOpacity(0.8),
                          ),
                        ),
                        Spacer(),
                        Icon(
                          Ionicons.call_outline,
                          color: Theme.of(context).hintColor.withOpacity(0.8),
                          size: 16,
                        ),
                        SizedBox(width: 10),
                        Text(
                          '${val.order.salon?.phone ?? ''}',
                          style: TextStyle(
                            letterSpacing: -0.2,
                            fontSize: 12,
                            color: Theme.of(context).hintColor.withOpacity(0.8),
                          ),
                        ),
                        SizedBox(width: 20),
                      ],
                    ),
                    AnimatedSwitcher(
                      duration: Duration(milliseconds: 250),
                      transitionBuilder: (child, animation) => SizeTransition(
                        sizeFactor: Tween(begin: 0.0, end: 1.0).animate(animation),
                        child: child,
                      ),
                      child: val.order.id == null
                          ? Container(
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                border: Border.all(color: Theme.of(context).colorScheme.secondary.withOpacity(0.2)),
                              ),
                              height: 120,
                              width: double.infinity,
                              margin: EdgeInsets.only(top: 10),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  CachedNetworkImage(
                                    imageUrl: services.first.service?.image?.path ?? repo.empty,
                                    fit: BoxFit.cover,
                                    height: 120,
                                    width: 140,
                                  ),
                                  SizedBox(width: 15),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Text(
                                          services.first.service?.name ?? '',
                                          maxLines: 2,
                                          softWrap: true,
                                          textAlign: TextAlign.left,
                                          overflow: TextOverflow.clip,
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          'artist: ' + services.first.artist?.name ?? '',
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: Theme.of(context).hintColor.withOpacity(0.5),
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Text(
                                          repo.onlytime.format(services.first.begin),
                                          style: TextStyle(
                                            color: Theme.of(context).colorScheme.secondary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(bottom: 10, right: 10),
                                    child: Text(
                                      ((services.first.service?.price ?? 0) / 1000).toStringAsFixed(1),
                                      style: TextStyle(
                                        fontSize: 40,
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context).colorScheme.secondary,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : ListView.builder(
                              shrinkWrap: true,
                              itemCount: services.length,
                              scrollDirection: Axis.vertical,
                              padding: EdgeInsets.symmetric(vertical: 30),
                              physics: ClampingScrollPhysics(),
                              itemBuilder: (context, index) {
                                OrderItem model = services.elementAt(index);
                                return Visibility(
                                  visible: model?.id != null,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.transparent,
                                      border: Border.all(color: Theme.of(context).colorScheme.secondary.withOpacity(0.2)),
                                    ),
                                    height: 80,
                                    width: double.infinity,
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 10),
                                          child: Text(
                                            repo.onlytime.format(model.begin),
                                            style: TextStyle(
                                              letterSpacing: -0.5,
                                              color: Theme.of(context).hintColor.withOpacity(0.8),
                                            ),
                                          ),
                                        ),
                                        CachedNetworkImage(
                                          imageUrl: model.service?.image?.path ?? repo.empty,
                                          fit: BoxFit.cover,
                                          height: 80,
                                          width: 100,
                                        ),
                                        SizedBox(width: 15),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Text(
                                                model.service?.name ?? '',
                                                maxLines: 2,
                                                softWrap: true,
                                                textAlign: TextAlign.left,
                                                overflow: TextOverflow.clip,
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(
                                                model.artist?.name ?? '',
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  color: Theme.of(context).hintColor.withOpacity(0.5),
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Text(
                                          ((model.service?.price ?? 0) / 1000).toStringAsFixed(1),
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Theme.of(context).colorScheme.secondary,
                                          ),
                                        ),
                                        model.id == null
                                            ? Container()
                                            : IconButton(
                                                onPressed: () => val.removeDetail(
                                                  model.id,
                                                  services.length,
                                                ),
                                                icon: Icon(
                                                  Ionicons.remove_circle_outline,
                                                  color: Theme.of(context).colorScheme.secondary.withOpacity(0.5),
                                                ),
                                              ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                    ),
                    val.order.id == null
                        ? Padding(
                            padding: EdgeInsets.fromLTRB(30, 30, 30, 0),
                            child: Text('Та захиалгын мэдээллээ нягтлан, хүсэлтээ баталгаажуулна уу',
                                textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          )
                        : Container(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          height: 150,
                          child: Column(
                            children: [
                              val.terminate
                                  ? IconButton(
                                      onPressed: val.setTerminate,
                                      iconSize: 80,
                                      icon: Icon(
                                        Ionicons.arrow_back_circle_outline,
                                        color: Theme.of(context).colorScheme.secondary,
                                      ),
                                    )
                                  : val.order.id == null
                                      ? IconButton(
                                          onPressed: val.setState,
                                          iconSize: 80,
                                          icon: Icon(
                                            Ionicons.arrow_back_circle_outline,
                                            color: Theme.of(context).colorScheme.secondary,
                                          ),
                                        )
                                      : IconButton(
                                          onPressed: () async {
                                            await val.order.salon.getServices();
                                            val.newOrderItem();
                                          },
                                          iconSize: 80,
                                          icon: Icon(
                                            Ionicons.add_circle_outline,
                                            color: Theme.of(context).colorScheme.secondary,
                                          ),
                                        ),
                              Spacer(),
                              Text(
                                '${val.terminate ? 'буцах' : val.order.id == null ? 'буцах' : 'нэмэлт\n үйлчилгээ'}',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.secondary,
                                ),
                              ),
                              Spacer(),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 150,
                          child: Column(
                            children: [
                              val.terminate
                                  ? IconButton(
                                      iconSize: 80,
                                      onPressed: val.cancel,
                                      icon: Icon(Ionicons.close_circle, color: Colors.red),
                                    )
                                  : IconButton(
                                      onPressed: () async {
                                        if (val.order.id == null)
                                          val.post();
                                        else {
                                          bool status = await val.confirmOrder();
                                          await showDialog(
                                            context: context,
                                            builder: (context) => Finish(status),
                                          );
                                          if (!status)
                                            val.cancel();
                                          else {
                                            val.order.status = 'pending';
                                            repo.app.addOrder(val.order);
                                            val.resetOrder();
                                            widget.change();
                                          }
                                        }
                                      },
                                      iconSize: 80,
                                      icon: Icon(
                                        Ionicons.checkmark_circle,
                                        color: Color(0xFF61DDAA),
                                      ),
                                    ),
                              Spacer(),
                              Text(
                                val.terminate
                                    ? 'Устгах'
                                    : val.order.id == null
                                        ? 'Баталгаажуулах'
                                        : 'Дуусгах',
                                style: TextStyle(
                                  color: Color(0xFF61DDAA),
                                ),
                              ),
                              Spacer(),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 30),
                    Visibility(
                      visible: val.order.id != null,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: Divider(
                          color: Theme.of(context).colorScheme.secondary,
                          height: 70,
                        ),
                      ),
                    ),
                    Visibility(
                      visible: val.order.id != null,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            'Нийт:    ',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).hintColor.withOpacity(0.5),
                            ),
                          ),
                          Text(
                            (val.order.total / 1000).toStringAsFixed(1),
                            style: TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                          SizedBox(width: 40),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
