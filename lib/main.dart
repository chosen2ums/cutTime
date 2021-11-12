import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:salon/provider/app_provider.dart' as app;
import 'package:salon/provider/artist_state_provider.dart';
import 'package:salon/repository.dart';
import 'package:salon/route_generator.dart';
import 'package:timeago/timeago.dart' as timeago;

void main() async {
  timeago.setLocaleMessages('mn', timeago.MnMessages());
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await GetStorage.init();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    iconconf();
    super.initState();
  }

  iconconf() async {
    repo.pin = BitmapDescriptor.fromBytes(
      await repo.getBytesFromAsset(
        'assets/svg/currentLocation.svg',
        context: context,
        size: Size(45, 45),
      ),
    );
    repo.dot = BitmapDescriptor.fromBytes(
      await repo.getBytesFromAsset(
        'assets/svg/unselected.svg',
        context: context,
        size: Size(23, 23),
      ),
    );
    repo.dotSelected = BitmapDescriptor.fromBytes(
      await repo.getBytesFromAsset(
        'assets/svg/selected.svg',
        size: Size(23, 23),
        context: context,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => app.AppProvider.instance()),
        ChangeNotifierProvider(create: (context) => ArtistStateProvider.instance()),
      ],
      child: Start(),
    );
  }
}

class Start extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ArtistStateProvider artist = Provider.of(context);
    repo.setArtistApp(artist);
    return Consumer<app.AppProvider>(builder: (context, value, child) {
      repo.setApp(value);
      return MaterialApp(
        title: 'Salon',
        debugShowCheckedModeBanner: false,
        theme: app.light,
        darkTheme: app.dark,
        themeMode: ThemeMode.system,
        onGenerateRoute: RouteGenerator.generateRoute,
        navigatorKey: value.key,
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: [Locale('en'), Locale('mn')],
        initialRoute: '/Home',
      );
    });
  }
}
