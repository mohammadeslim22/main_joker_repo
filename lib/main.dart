import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:joker/providers/map_provider.dart';
import 'package:joker/ui/auth/login_screen.dart';
import 'constants/config.dart';
import 'services/navigationService.dart';
import 'ui/home_map.dart';
import 'util/dio.dart';
import 'package:joker/providers/counter.dart';
import 'package:provider/provider.dart';
import 'constants/route.dart';
import 'constants/themes.dart';
import 'providers/language.dart';
import 'localization/localization_delegate.dart';
import 'providers/auth.dart';
import 'package:joker/util/data.dart';
import 'package:joker/util/functions.dart';

import 'util/service_locator.dart';
//import 'package:flutter/scheduler.dart';
// import 'package:joker/models/user.dart';

Future<void> main() async {
  ErrorWidget.builder = (FlutterErrorDetails flutterErrorDetails) =>
      errorScreen(flutterErrorDetails.exception);

  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();
  dioDefaults();
  await data.getData('authorization').then<dynamic>((String auth) {
    print("auth  :$auth");
    if (auth.isEmpty) {
      config.loggedin = false;
    } else {
      config.loggedin = true;
    }
    dio.options.headers['authorization'] = '$auth';
  });
  // data.getData("lat").then((String value) {
  //   config.lat = double.parse(value);
  // });
  await updateLocation;
  // data.getData("long").then((String value) async {

  //   print("lat  $value");
  //   if (value == null) {
  //     await updateLocation;
  //   }
  // });
  data.getData("lang").then((String value) {
    config.userLnag = Locale(value);
  });

  runApp(
    MultiProvider(
      providers: <ChangeNotifierProvider<ChangeNotifier>>[
        ChangeNotifierProvider<Auth>(
          create: (_) => Auth(),
        ),
        ChangeNotifierProvider<Language>(
          create: (_) => Language(),
        ),
        ChangeNotifierProvider<MainProvider>(
          create: (_) => MainProvider(),
        ),
        ChangeNotifierProvider<HOMEMAProvider>.value(
          value: getIt<HOMEMAProvider>(),
        ),
      ],
      child: MyApp(),
    ),
  );
}

GlobalKey<NavigatorState> navigatorState = GlobalKey<NavigatorState>();

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  bool doOnce = true;
  @override
  Widget build(BuildContext context) {
    final Language lang = Provider.of<Language>(context);
    final MainProvider bolc = Provider.of<MainProvider>(context);

    // data.getData("lang").then((String value) {
    //   config.userLnag = Locale(value);
    //   lang.setLanguage(Locale(value));
    // });

    return MaterialApp(
        navigatorKey: getIt<NavigationService>().navigatorKey,
        debugShowCheckedModeBanner: false,
        localizationsDelegates: <LocalizationsDelegate<dynamic>>[
          DemoLocalizationsDelegate(),
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          DefaultMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const <Locale>[
          Locale('ar'),
          Locale('en'),
          Locale('tr'),
        ],
        locale: lang.currentLanguage, //config.userLnag,
        localeResolutionCallback:
            (Locale locale, Iterable<Locale> supportedLocales) {
          if (locale == null) {
            data.setData("initlang", supportedLocales.first.countryCode);
            return supportedLocales.first;
          }

          for (final Locale supportedLocale in supportedLocales) {
            if (supportedLocale.languageCode == locale.languageCode) {
              // lang.setLanguage(supportedLocale);
              data.setData("initlang", supportedLocale.languageCode);

              //lang.setLanguage(supportedLocale);
              return supportedLocale;
            }
          }

          // TODO(ahmed): use it to change language on start application
          // SchedulerBinding.instance.addPostFrameCallback((_) async {
          //   await data.getData("lang").then((String value) {
          //     config.userLnag = Locale(value);
          //     lang.setLanguage(Locale(value));
          //   });
          // });
          data.setData("initlang", supportedLocales.first.countryCode);
          return supportedLocales.first;
        },
        // builder: (BuildContext context, Widget t) {
        //   if (dio.options.headers['authorization'] == "null") {
        //     return LoginScreen();
        //   }
        //   return const Home();
        // },
        theme: mainThemeData(),
        onGenerateRoute: onGenerateRoute,
        home: Builder(builder: (BuildContext context) {
          if (doOnce) {
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

            print("3: ${lang.currentLanguage}");
            //  setState(() {
            doOnce = false;
            //    });
          }

          return config.loggedin ? const HOMEMAP() : LoginScreen();
        }));
  }
}

Widget errorScreen(dynamic detailsException) {
  return Builder(
    builder: (BuildContext context) {
      return Material(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 130),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const Text(
                  'Sorry for inconvenience',
                  style: TextStyle(fontSize: 24.0),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text('Exeption Details: $detailsException'),
                ),
                FlatButton(
                  color: Colors.blue,
                  child:const Text(
                    'Go Back',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            ),
          ),
        ),
      );
    },
  );
}
