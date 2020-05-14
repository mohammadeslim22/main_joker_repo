import 'package:flutter/material.dart';
import 'colors.dart';

ThemeData mainThemeData() {
  return ThemeData(
    primaryColor: colors.orange,
    primaryTextTheme: const TextTheme(),
    scaffoldBackgroundColor: colors.grey,
    appBarTheme: AppBarTheme(
      color: colors.grey,
      elevation: 0.0,
      iconTheme: IconThemeData(color: colors.black),
      textTheme: const TextTheme(),
    ),
    fontFamily: "Almarai",
    canvasColor: Colors.white,
    cursorColor: colors.orange,
    hintColor: colors.black,
    textTheme: TextTheme(
      bodyText2: TextStyle(
        color: colors.black,
        fontSize: 14.0,
      ),
    ),
  );
}
