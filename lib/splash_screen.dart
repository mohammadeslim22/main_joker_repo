import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sim_country_code/flutter_sim_country_code.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:joker/constants/config.dart';
import 'package:joker/providers/auth.dart';
import 'package:joker/providers/map_provider.dart';
import 'package:joker/util/functions.dart';
import 'package:joker/util/data.dart';
import 'package:joker/util/service_locator.dart';
import 'package:location/location.dart';
import 'providers/language.dart';
import 'package:provider/provider.dart';
import 'package:joker/util/size_config.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool locationTurnOn;

  Future<void> askUser(Language lang, Auth auth) async {
    data.getData("countryCodeTemp").then((String value1) {
      data.getData("countryDialCodeTemp").then((String value2) {
        auth.saveCountryCode(value1, value2);
      });
    });
    data.getData("lang").then((String value) async {
      if (value.isEmpty) {
      } else {
        print("1: $value");
        config.userLnag = Locale(value);
        await lang.setLanguage(Locale(value));
        print("2: ${lang.currentLanguage}");
      }
    });

    locationTurnOn = await updateLocation;
    location.onLocationChanged.listen((LocationData event) {
      config.lat = event.latitude;
      config.long = event.longitude;
      getIt<HOMEMAProvider>().setRotation(event.heading);
    });
    Navigator.pushNamedAndRemoveUntil(context, "/WhereToGo", (_) => false);
  }

  Future<void> initPlatformState(Auth auth) async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await FlutterSimCountryCode.simCountryCode;
      print("platform country code : $platformVersion");
      auth.dialCodeFav = platformVersion;
      auth.getCountry(platformVersion);
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }
    if (!mounted) {
      return;
    }
  }

  @override
  void initState() {
    super.initState();
    final Language lang = Provider.of<Language>(context, listen: false);
    final Auth auth = Provider.of<Auth>(context, listen: false);
    askUser(lang, auth);
    initPlatformState(auth);
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: Container(
          color: Colors.white,
          alignment: Alignment.center,
          child: SvgPicture.asset(
            "assets/images/Layer.svg",
            width: 200,
          )),
    );
  }
}
