import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:salon/models/service.dart';
import 'package:salon/repository.dart';

typedef Value = Function(Service);

class SingleServiceWidget extends StatelessWidget {
  final Service service;
  final Value onTap;
  final bool selected;
  final Value order;
  final bool checked;
  SingleServiceWidget(
    this.service, {
    this.onTap,
    this.selected = false,
    this.order,
    this.checked = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap == null ? null : () => onTap(selected ? null : service),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(
            color: Theme.of(context).colorScheme.secondary,
            width: selected ? 0.6 : 0.2,
          ),
        ),
        height: 90,
        padding: EdgeInsets.all(2),
        child: Row(
          children: [
            CachedNetworkImage(
              imageUrl: service.image?.path ?? repo.emptyImage,
              width: 120,
              height: 90,
              fit: BoxFit.cover,
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      service.name,
                      maxLines: 2,
                      softWrap: true,
                      textAlign: TextAlign.start,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          '${service.duration} min',
                          style: TextStyle(
                            fontSize: 16,
                            color: Theme.of(context).hintColor.withOpacity(0.75),
                          ),
                        ),
                        Spacer(),
                        RichText(
                          text: TextSpan(
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                              wordSpacing: -3,
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                            children: [
                              TextSpan(
                                text: service.first + ' ',
                              ),
                              TextSpan(
                                text: service.last,
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            AnimatedSwitcher(
              duration: Duration(milliseconds: 300),
              transitionBuilder: (child, animation) => FadeTransition(
                opacity: Tween(begin: 0.0, end: 1.0).animate(animation),
                child: child,
              ),
              child: checked
                  ? IconButton(
                      onPressed: () => order(service),
                      iconSize: 50,
                      icon: Icon(Ionicons.add_circle),
                      color: Theme.of(context).colorScheme.secondary,
                    )
                  : TextButton(
                      onPressed: onTap == null ? null : () => onTap(selected ? null : service),
                      child: Icon(selected ? Ionicons.checkmark_outline : null, size: 30),
                      style: ButtonStyle(
                        visualDensity: VisualDensity.compact,
                        shape: MaterialStateProperty.all(CircleBorder()),
                        padding: MaterialStateProperty.all(EdgeInsets.all(20)),
                        foregroundColor: MaterialStateProperty.all(Colors.white),
                        backgroundColor: MaterialStateProperty.all(selected ? Theme.of(context).colorScheme.secondary : Colors.transparent),
                        side: MaterialStateProperty.all(BorderSide(color: Theme.of(context).hintColor.withOpacity(0.2), width: selected ? 0 : 2)),
                      ),
                    ),
            ),
            SizedBox(width: 5),
          ],
        ),
      ),
    );
  }
}
