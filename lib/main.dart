import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:joker/constants/colors.dart';
import 'package:joker/providers/map_provider.dart';
import 'package:joker/splash_screen.dart';
import 'constants/config.dart';
import 'services/navigationService.dart';
import 'util/dio.dart';
import 'package:joker/providers/mainprovider.dart';
import 'package:joker/providers/merchantsProvider.dart';
import 'package:joker/providers/salesProvider.dart';
import 'package:provider/provider.dart';
import 'constants/route.dart';
import 'constants/themes.dart';
import 'providers/language.dart';
import 'localization/localization_delegate.dart';
import 'providers/auth.dart';
import 'package:joker/util/data.dart';
import 'util/service_locator.dart';
import 'package:joker/providers/globalVars.dart';

//import 'package:flutter/scheduler.dart';
// import 'package:joker/models/user.dart';

Future<void> main() async {
  ErrorWidget.builder = (FlutterErrorDetails flutterErrorDetails) =>
      errorScreen(flutterErrorDetails.exception);

  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();
  dioDefaults();
  await data.getData('authorization').then<dynamic>((String auth) {
    print("auth what :$auth");
    if (auth.isEmpty) {
      config.loggedin = false;
    } else {
      config.loggedin = true;
    }
    dio.options.headers['authorization'] = '$auth';
  });

  //  data.getData("lang").then((String value) {
  //   config.userLnag = Locale(value);
  // });

  runApp(
    MultiProvider(
      providers: <ChangeNotifierProvider<ChangeNotifier>>[
        ChangeNotifierProvider<Auth>.value(
          value: getIt<Auth>(),
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
        ChangeNotifierProvider<MerchantProvider>.value(
          value: getIt<MerchantProvider>(),
        ),
        ChangeNotifierProvider<SalesProvider>.value(
          value: getIt<SalesProvider>(),
        ),
        ChangeNotifierProvider<GlobalVars>.value(
          value: getIt<GlobalVars>(),
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
            data.setData("initlang", supportedLocale.languageCode);
            return supportedLocale;
          }
        }

        data.setData("initlang", supportedLocales.first.countryCode);
        return supportedLocales.first;
      },
      theme: mainThemeData(),
      onGenerateRoute: onGenerateRoute,
      home: const SplashScreen(),
    );
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
                  color: colors.blue,
                  child: Text(
                    'Go Back',
                    style: TextStyle(
                      color: colors.white,
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
