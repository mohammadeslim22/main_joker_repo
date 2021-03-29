import 'package:flutter/material.dart';
import 'colors.dart';

ThemeData mainThemeData() {
  return ThemeData(
    primaryColor: colors.orange,
    primaryTextTheme: const TextTheme(),
    scaffoldBackgroundColor: colors.grey,
    accentColor: colors.orange,
    appBarTheme: AppBarTheme(
      color: colors.grey,
      elevation: 0.0,
      iconTheme: IconThemeData(color: colors.black),
      textTheme: const TextTheme(),
    ),
    fontFamily: "Almarai",
    canvasColor: colors.white,

    textSelectionTheme: TextSelectionThemeData(cursorColor: colors.orange),
    // cursorColor: colors.orange,
    hintColor: colors.black,
    // bottomSheetTheme:  BottomSheetThemeData(elevation: 10,backgroundColor: Colors.white.withOpacity(.75)),
    textTheme: TextTheme(
      bodyText2: TextStyle(color: colors.black, fontSize: 14.0),
    ),
  );
}

ThemeData mainThemeDatadark() {
  return ThemeData(
    primaryColor: colors.orange,
    primaryTextTheme: const TextTheme(),
    scaffoldBackgroundColor: const Color(0xFF2B2B2B),
    appBarTheme: AppBarTheme(
      color: const Color(0xFF666666),
      elevation: 0.0,
      iconTheme: IconThemeData(color: colors.black),
      textTheme: const TextTheme(),
    ),
    fontFamily: "Almarai",
    canvasColor: const Color(0xFF666666),
    textSelectionTheme: TextSelectionThemeData(cursorColor: colors.orange),
    hintColor: colors.black,
    // bottomSheetTheme:  BottomSheetThemeData(elevation: 10,backgroundColor: Colors.white.withOpacity(.75)),
    textTheme: TextTheme(
      bodyText2: TextStyle(color: colors.black, fontSize: 14.0),
    ),
  );
}
