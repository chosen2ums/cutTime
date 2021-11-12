import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';
import 'package:salon/models/service.dart';
import 'package:salon/provider/artist_state_provider.dart';
import 'package:salon/repository.dart';
import 'package:shape_of_view/shape_of_view.dart';

class ArtistServiceWidget extends StatefulWidget {
  final Service service;
  ArtistServiceWidget(this.service, {Key key}) : super(key: key);

  @override
  _ArtistServiceWidgetState createState() => _ArtistServiceWidgetState();
}

class _ArtistServiceWidgetState extends State<ArtistServiceWidget> {
  @override
  Widget build(BuildContext context) {
    ArtistStateProvider provider = Provider.of(context);
    return InkWell(
      onTap: () => provider.handleChangeService(widget.service),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: Theme.of(context).colorScheme.secondary,
            width: widget.service.mine ? 0.6 : 0.1,
          ),
        ),
        height: 90,
        padding: EdgeInsets.all(2),
        child: Row(
          children: [
            ShapeOfView(
              shape: RoundRectShape(
                borderRadius: BorderRadius.circular(8),
                borderColor: Colors.white,
                borderWidth: 2,
              ),
              child: CachedNetworkImage(
                imageUrl: widget.service.image?.path ?? repo.empty,
                fit: BoxFit.cover,
                width: 110,
                height: 90,
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      widget.service.name,
                      maxLines: 2,
                      softWrap: true,
                      textAlign: TextAlign.start,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          '${widget.service.duration} min',
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
                                text: widget.service.first + ' ',
                              ),
                              TextSpan(
                                text: widget.service.last,
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
            TextButton(
              onPressed: () => provider.handleChangeService(widget.service),
              child: Icon(widget.service.mine ? Ionicons.checkmark_outline : null, size: 30),
              style: ButtonStyle(
                visualDensity: VisualDensity.compact,
                shape: MaterialStateProperty.all(CircleBorder()),
                padding: MaterialStateProperty.all(EdgeInsets.all(20)),
                foregroundColor: MaterialStateProperty.all(Colors.white),
                backgroundColor: MaterialStateProperty.all(widget.service.mine ? Theme.of(context).colorScheme.secondary : Colors.transparent),
                side: MaterialStateProperty.all(BorderSide(color: Theme.of(context).hintColor.withOpacity(0.2), width: widget.service.mine ? 0 : 2)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
