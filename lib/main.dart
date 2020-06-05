import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:joker/ui/auth/login_screen.dart';
import 'package:joker/ui/home.dart';
import 'package:joker/ui/sale_screen.dart';
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

void main() {
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
  dioDefaults();
  data.getData('authorization').then<dynamic>((dynamic auth) {
    print(auth);
    dio.options.headers
        .update('authorization', (dynamic value) async => auth.toString());
  });

  data.getData("lat").then((String value) {
    config.lat = value as double;
  });
  data.getData("long").then((String value) {
    config.long = value as double;
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Language lang = Provider.of<Language>(context);

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
        locale: lang.currentLanguage,
        localeResolutionCallback:
            (Locale locale, Iterable<Locale> supportedLocales) {
          if (locale == null) {
            return supportedLocales.first;
          }

          for (final Locale supportedLocale in supportedLocales) {
            if (supportedLocale.languageCode == locale.languageCode) {
              return supportedLocale;
            }
          }
          // TODO(ahmed): use it to change language on start application
          /* SchedulerBinding.instance.addPostFrameCallback(
          (_) => lang.setLanguage(supportedLocales.first),
        ); */

          return supportedLocales.first;
        },
        theme: mainThemeData(),
        onGenerateRoute: onGenerateRoute,
        //  home:const ShopDetails(merchantId: 24,lovecount: 50,likecount: 50)
        home:const Home()
        // home: const ShopDetails(likecount: 50,lovecount: 50,shop:    Shop(
        //     image: "assets/images/shopone.jpg"
        //   ),),
        );
  }
}
