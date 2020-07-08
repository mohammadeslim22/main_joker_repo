import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:joker/ui/auth/login_screen.dart';
import 'package:joker/ui/home.dart';
import 'constants/config.dart';
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
// import 'package:flutter/scheduler.dart';
// import 'package:joker/models/user.dart';
import 'package:dio/dio.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  dioDefaults();
  await data.getData('authorization').then<dynamic>((String auth) {
    if (auth == null) {
      print("khhhhhhhhhhhhhhhhh");
      config.loggedin = false;
    } else {
      config.loggedin = true;
    }
    dio.options.headers['authorization'] = '$auth';
  });

  // await data.getData("profile_pic").then((String value) {
  //   print("profile pic:   $value");
  //   if (value == "null") {
  //     print("error here ?");
  //     dio.get<dynamic>("user").then((Response<dynamic> value) {
  //       print(value.data['data']['image'].toString());
  //       config.profileUrl = value.data['data']['image'].toString();
  //       data.setData("profile_pic", value.data['data']['image'].toString());
  //       data.setData("username", value.data['data']['name'].toString());
  //     });
  //   }

  //   config.profileUrl = value;
  // });
  data.getData("lat").then((String value) {
    config.lat = double.parse(value);
  });
  data.getData("long").then((String value) async {
    print("lat  $value");
    if (value == null) {
      print("no location saved ");
      await updateLocation;
    }
  });
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
        ChangeNotifierProvider<MyCounter>(
          create: (_) => MyCounter(),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Language lang = Provider.of<Language>(context);
    // data.getData("lang").then((String value) {
    //   config.userLnag = Locale(value);
    //   lang.setLanguage(Locale(value));
    // });

    return MaterialApp(
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
        locale: config.userLnag,
        localeResolutionCallback:
            (Locale locale, Iterable<Locale> supportedLocales) {
          if (locale == null) {
            return supportedLocales.first;
          }

          for (final Locale supportedLocale in supportedLocales) {
            if (supportedLocale.languageCode == locale.languageCode) {
              // lang.setLanguage(supportedLocale);
              data.setData("lang", supportedLocale.languageCode);

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
        home: config.loggedin ? const Home() : LoginScreen());
  }
}
