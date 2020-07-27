import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:joker/constants/config.dart';
import 'package:joker/util/functions.dart';
import 'package:joker/util/data.dart';
import 'providers/language.dart';
import 'package:joker/providers/counter.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool locationTurnOn;
  Future<void> askUser(Language lang, MainProvider bolc) async {
    data.getData("countryCodeTemp").then((String value1) {
      data.getData("countryDialCodeTemp").then((String value2) {
        bolc.saveCountryCode(value1, value2);
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

    Navigator.pushNamedAndRemoveUntil(context, "/HomeMap", (_) => false,
        arguments: <String, dynamic>{
          "home_map_lat": config.lat ?? 0.0,
          "home_map_long": config.long ?? 0.0
        });
  }

  @override
  void initState() {
    super.initState();
    final Language lang = Provider.of<Language>(context, listen: false);
    final MainProvider bolc = Provider.of<MainProvider>(context, listen: false);
    askUser(lang, bolc);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          color: Colors.white,
          alignment: Alignment.center,
          child: SvgPicture.asset("assets/images/templogo.svg")),
    );
  }
}
