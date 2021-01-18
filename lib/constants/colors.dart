import 'package:flutter/material.dart';

class MyColors {
  factory MyColors() {
    return _colors;
  }

  MyColors._internal();

  static final MyColors _colors = MyColors._internal();

  Color white = const Color(0xffffffff);
  Color grey = const Color(0xffF5F5F7);
  Color black = const Color(0xff101010);
  Color yellow = const Color(0xffFFC000);
  Color green = const Color(0xff007C40);
  Color red = const Color(0xffFC531C);
  Color blue = Colors.blue[400];
  Color redOpacity = const Color(0xffFC531C);
  Color jokerBlue = Colors.blue;
  Color trans = Colors.transparent;
  Color ggrey = Colors.grey;
}

final MyColors colors = MyColors();
