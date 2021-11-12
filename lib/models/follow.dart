import 'package:salon/models/artist.dart';
import 'package:salon/models/media.dart';
import 'package:salon/models/salon.dart';
import 'package:salon/provider/app_provider.dart';

class Follow {
  int id;
  Salon salon;
  Artist artist;
  Media avatar;
  String name;
  String type;

  Follow({this.salon, this.artist}) {
    conf();
  }

  conf() {
    if (salon != null) {
      avatar = salon.logo;
      name = salon.name;
      type = 'Салон';
      id = salon.id;
    } else {
      avatar = artist.avatar;
      name = artist.name;
      type = 'Артист';
      id = artist.id;
    }
  }

  show(AppProvider provider, context) {
    if (salon != null)
      provider.showSalon(context, this.salon);
    else {
      provider.showArtist(context, this.artist);
    }
  }
}
