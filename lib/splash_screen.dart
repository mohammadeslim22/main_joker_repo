import 'package:after_layout/after_layout.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sim_country_code/flutter_sim_country_code.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:joker/constants/config.dart';
import 'package:joker/providers/auth.dart';
import 'package:joker/providers/map_provider.dart';
import 'package:joker/services/navigationService.dart';
import 'package:joker/util/dio.dart';
import 'package:joker/util/functions.dart';
import 'package:joker/util/data.dart';
import 'package:joker/util/service_locator.dart';
import 'package:location/location.dart';
import 'localization/trans.dart';
import 'providers/language.dart';
import 'package:provider/provider.dart';
import 'package:joker/util/size_config.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with AfterLayoutMixin<SplashScreen> {
  bool locationTurnOn;

  Future<void> askUser(Language lang, Auth auth) async {
    data.getData("countryCodeTemp").then((String value1) {
      data.getData("countryDialCodeTemp").then((String value2) {
        auth.saveCountryCode(value1, value2);
      });
    });
    data.getData("lang").then((String value) async {
      if (value.isEmpty) {
        print("lang storage is empty");
      } else {
        const String arabicBaseUrl =
            "https://joker.altariq.ps/api/ar/v1/customer/";
        const String englishBaseUrl =
            "https://joker.altariq.ps/api/en/v1/customer/";
        const String turkishBaseUrl =
            "https://joker.altariq.ps/api/tr/v1/customer/";
        String baseUrl = await data.getData("baseUrl");
        if (baseUrl == "" || baseUrl.isEmpty || baseUrl == null) {
          baseUrl = config.baseUrl;
        }
        print("1: $value");
        config.userLnag = Locale(value);
        await lang.setLanguage(Locale(value));
        print("config.userLnag.countryCode  $value  $baseUrl");
        if (value == "en") {
          dio.options.baseUrl = englishBaseUrl;
        } else if (value == "ar") {
          dio.options.baseUrl = arabicBaseUrl;
        } else {
          dio.options.baseUrl = turkishBaseUrl;
        }
        print("dio.options.baseUrl ${dio.options.baseUrl}");
        await data.setData("baseUrl", dio.options.baseUrl);
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
      // auth.setDialCodee(platformVersion);
      await auth.getCountry(platformVersion);
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }
    if (!mounted) {
      return;
    }
  }

  Auth auth;
  @override
  void initState() {
    super.initState();
    final Language lang = Provider.of<Language>(context, listen: false);
    auth = Provider.of<Auth>(context, listen: false);
    askUser(lang, auth);
    initPlatformState(auth);
    // if (config.loggedin) {
    //   data.getData("username").then((String name) {
    //     if (name.isEmpty || name == null) {
    //       config.username ='username';
    //       auth.changeUsername('username');
    //     } else {
    //       auth.changeUsername(name);
    //       config.username = name;
    //     }
    //   });

    //   data.getData("profile_pic").then((String value) {
    //     if (value.isEmpty || value == "null" || value == "" || value == null) {
    //       dio.get<dynamic>("user").then((Response<dynamic> value) {
    //         if (value.statusCode == 200) {
    //           auth.changeUsername(value.data['data']['name'].toString());
    //           config.username = value.data['data']['name'].toString();
    //           if (value.data['data']['image'].toString().trim() !=
    //               "https://joker.altariq.ps/ar/image/") {
    //             config.imageUrl = value.data['data']['image'].toString().trim();
    //             data.setData("profile_pic", config.profileUrl);
    //           }

    //           data.setData("username", value.data['data']['name'].toString());
    //         }
    //       });
    //     } else {
    //       if (value != "https://joker.altariq.ps/ar/image/") {
    //         config.profileUrl = value;
    //       }
    //     }
    //   });
    // } else {
    //   auth.changeUsername("Login or Sign up");
    //   config.username = getIt<NavigationService>()
    //       .translateWithNoContext("Login or Sign up");
    // }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: Container(
          color: Colors.white,
          alignment: Alignment.center,
          child: SvgPicture.asset("assets/images/Layer.svg", width: 200)),
    );
  }

  void setUserAndPicture(Auth auth) {
    if (config.loggedin) {
      data.getData("username").then((String name) {
        if (name.isEmpty || name == null) {
          config.username = trans(context, 'username');
          auth.changeUsername(trans(context, 'username'));
        } else {
          auth.changeUsername(name);
          config.username = name;
        }
      });

      data.getData("profile_pic").then((String value) {
        if (value.isEmpty || value == "null" || value == "" || value == null) {
          dio.get<dynamic>("user").then((Response<dynamic> value) async {
            if (value.statusCode == 200) {
              auth.changeUsername(value.data['data']['name'].toString());
              config.username = value.data['data']['name'].toString();
              if (value.data['data']['image'].toString().trim() !=
                  "https://joker.altariq.ps/ar/image/") {
                auth.setUserPicture(
                    value.data['data']['image'].toString().trim());
                config.imageUrl = value.data['data']['image'].toString().trim();
                await data.setData("profile_pic", config.profileUrl);
              }

              await data.setData(
                  "username", value.data['data']['name'].toString());
            }
          });
        } else {
          if (value != "https://joker.altariq.ps/ar/image/") {
            auth.setUserPicture(value);
            config.profileUrl = value;
          }
        }
      });
    } else {
      auth.changeUsername(trans(context, "login_or_sign_up"));
      config.username = getIt<NavigationService>()
          .translateWithNoContext(trans(context, "login_or_sign_up"));
    }
  }

  @override
  void afterFirstLayout(BuildContext context) {
    setUserAndPicture(auth);
  }
}
