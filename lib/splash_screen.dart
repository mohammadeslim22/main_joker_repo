import 'package:after_layout/after_layout.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sim_country_code/flutter_sim_country_code.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:joker/constants/config.dart';
import 'package:joker/providers/auth.dart';
import 'package:joker/providers/map_provider.dart';
import 'package:joker/ui/view_models/notifications_modle.dart';
import 'package:joker/util/functions.dart';
import 'package:joker/util/data.dart';
import 'package:joker/util/service_locator.dart';
import 'package:location/location.dart';
import 'constants/colors.dart';
import 'providers/language.dart';
import 'package:provider/provider.dart';
import 'package:joker/util/size_config.dart';
// import 'package:fluttertoast/fluttertoast.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with AfterLayoutMixin<SplashScreen> {
  _SplashScreenState();

  bool showLoading = false;
  Future<void> askUser(Language lang) async {
    data.getData("ilang").then((String value) async {
      if (value.isEmpty) {
      } else {
        await lang.setLanguage(Locale(value));
      }
    });

    final Map<String, dynamic> loc = await updateLocation;
    final List<String> loglat = loc["location"] as List<String>;

    location.onLocationChanged.listen((LocationData event) {
      getIt<HOMEMAProvider>().setLatLomg(event.latitude, event.longitude);
      config.lat = event.latitude;
      config.long = event.longitude;
      // Fluttertoast.showToast(
      //     msg: "does it really changes when change my location from splash ? ");
      // print("does it really changes when change my location from splash ? ");
      getIt<HOMEMAProvider>().setRotation(event.heading);
    });
    setState(() {
      showLoading = true;
    });
    await getIt<HOMEMAProvider>().getSpecializationsData();
    setState(() {
      showLoading = false;
    });
    Navigator.pushNamedAndRemoveUntil(context, "/MapAsHome", (_) => false,
        arguments: <String, double>{
          "home_map_lat": double.parse(loglat.elementAt(0)) ?? 0.0,
          "home_map_long": double.parse(loglat.elementAt(1)) ?? 0.0
        });
  }

  Future<void> initPlatformState(Auth auth) async {
    String platformVersion;
    try {
      platformVersion = await FlutterSimCountryCode.simCountryCode;
      auth.dialCodeFav = platformVersion.toUpperCase();
      auth.getCountry(platformVersion.toUpperCase());
    } on PlatformException {
      platformVersion = 'TR';
    }
    if (!mounted) {
      return;
    }
  }

  @override
  void initState() {
    super.initState();
    final Language lang = Provider.of<Language>(context, listen: false);
    final Auth auth = getIt<Auth>();
    initPlatformState(auth);
    auth.setUserAndPicture();
    askUser(lang);
    getIt<NotificationsModel>().getNotificationsCount();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      color: colors.white,
      child: Align(
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SvgPicture.asset("assets/images/joker_indirim.svg",
                fit: BoxFit.cover, width: 200),
            const SizedBox(height: 12),
            Visibility(
                replacement: const SizedBox(height: 48),
                visible: showLoading,
                child: const CupertinoActivityIndicator(radius: 24))
          ],
        ),
      ),
    ));

    //   Container(
    //       color: Colors.white,
    //       alignment: Alignment.center,
    //       child:
    //           SvgPicture.asset("assets/images/joker_indirim.svg", width: 200)),
    // );
  }

  @override
  void afterFirstLayout(BuildContext context) {
    SizeConfig().init(context);
  }
}
