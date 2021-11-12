import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salon/models/salon.dart';
import 'package:salon/provider/app_provider.dart' as app;
import 'package:salon/repository.dart';
import 'package:shape_of_view/shape_of_view.dart';

typedef Value = Function(Salon);

class SingleSalonWidget extends StatelessWidget {
  final Salon salon;
  final Value onTap;
  final bool selected;
  final Size size;
  final double img;
  final int access;
  final Color color;
  SingleSalonWidget(
    this.salon, {
    this.onTap,
    this.access = 1,
    this.selected = false,
    this.size,
    this.img,
    Color color = Colors.transparent,
  }) : this.color = color;

  @override
  Widget build(BuildContext context) {
    app.AppProvider provider = Provider.of(context);
    double width = size.width;
    double height = size.height;

    String title;
    Color _color = Colors.white;

    if (salon.isFollow) {
      title = 'Following';
      _color = Theme.of(context).colorScheme.secondary;
    } else if (salon.history != 0) {
      title = 'Recent';
      _color = Theme.of(context).colorScheme.secondaryVariant;
    }

    if (selected) {
      title = 'Selected';
      _color = Theme.of(context).colorScheme.secondary;
    }

    return InkWell(
      onTap: () => onTap != null ? onTap(salon) : null,
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(5),
          border: Border.all(
            color: selected ? Theme.of(context).colorScheme.secondary.withOpacity(0.5) : Theme.of(context).colorScheme.secondary.withOpacity(0.2),
          ),
        ),
        height: height,
        width: width,
        child: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: CachedNetworkImage(
                imageUrl: salon.cover?.path ?? 'https://seedtale.com/app/assets/images/product-preview/p2879_side0.png',
                height: img,
                fit: BoxFit.cover,
                width: width,
              ),
            ),
            Positioned(
              bottom: 10,
              left: 15,
              child: GestureDetector(
                onTap: () => provider.showSalon(
                  context,
                  salon,
                  access: access,
                ),
                child: ShapeOfView(
                  shape: CircleShape(),
                  child: CachedNetworkImage(
                    imageUrl: salon.logo?.path ?? repo.empty,
                    fit: BoxFit.cover,
                    height: 65,
                    width: 65,
                  ),
                ),
              ),
            ),
            Positioned(
              top: img,
              left: 95,
              right: 0,
              bottom: 0,
              child: InkWell(
                onTap: () => provider.showSalon(
                  context,
                  salon,
                  access: access,
                ),
                child: Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    salon.name ?? '',
                    maxLines: 2,
                    softWrap: true,
                    overflow: TextOverflow.clip,
                    style: TextStyle(
                      color: Theme.of(context).hintColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 23,
                      height: 1,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 10,
              right: 0,
              child: Visibility(
                visible: title != null,
                child: Container(
                    color: _color,
                    padding: EdgeInsets.fromLTRB(5, 2, 10, 2),
                    child: Text(title ?? '', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 14))),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
