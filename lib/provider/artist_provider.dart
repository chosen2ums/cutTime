import 'package:flutter/material.dart';
import 'package:salon/models/artist.dart';
import 'package:salon/repository.dart';

class ArtistProvider with ChangeNotifier {
  Artist artist;
  Stat stat;
  ArtistProvider.instance(this.artist) : stat = Stat.Loading {
    conf();
  }

  conf() async {
    if (artist == null)
      stat = Stat.Error;
    else {
      if (!artist.isDone)
        stat = Stat.Undone;
      else {
        await artist.getData();
        stat = Stat.Done;
      }
    }
    notifyListeners();
  }
}
