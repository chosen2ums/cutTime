import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';
import 'package:salon/provider/artist_state_provider.dart';

class AddPhoto extends StatelessWidget {
  AddPhoto({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ArtistStateProvider val = Provider.of(context);
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: Theme.of(context).hintColor.withOpacity(0.2)),
      ),
      margin: EdgeInsets.symmetric(horizontal: 20),
      height: double.infinity,
      width: double.infinity,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Add photo',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).hintColor.withOpacity(0.4),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () => val.addPhoto(0),
                  icon: Icon(Ionicons.camera_outline),
                  color: Theme.of(context).hintColor.withOpacity(0.4),
                ),
                IconButton(
                  onPressed: () => val.addPhoto(1),
                  icon: Icon(Ionicons.image_outline),
                  color: Theme.of(context).hintColor.withOpacity(0.4),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
