import 'colors.dart';
import 'package:flutter/material.dart';

class Styles {
  TextStyle title = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.bold,
    color: colors.black,
  );

  TextStyle saleTitle = TextStyle(
    fontSize: 18,
    color: colors.black,
  );

  TextStyle smallButton =  TextStyle(
    fontSize: 12,
    color: colors.black,
    fontWeight: FontWeight.w100
  );
  TextStyle mylight = const TextStyle(
  fontWeight: FontWeight.w100,
  color: Colors.grey,
  fontSize: 15,
);
TextStyle mysmalllight = const TextStyle(
  fontWeight: FontWeight.w100,
  color: Colors.grey,
  fontSize: 12,
);
TextStyle mysmall = const TextStyle(
  fontWeight: FontWeight.w100,
  color: Colors.black,
  fontSize: 13,
);
TextStyle mystyle = const TextStyle(
  fontWeight: FontWeight.w100,
  color: Colors.black,
  fontSize: 15,
);
TextStyle mystyle2 = const TextStyle(
  fontWeight: FontWeight.bold,
  color: Colors.black,
  fontSize: 40,
);
TextStyle underHead = const TextStyle(
  fontWeight: FontWeight.w100,
  color: Color(0xFF303030),
  fontSize: 18,
);
TextStyle underHeadblack = const TextStyle(
  fontWeight: FontWeight.w100,
  color: Colors.black,
  fontSize: 20,
);
TextStyle notificationNO = const TextStyle(
  fontWeight: FontWeight.w100,
  color: Colors.white,
  fontSize: 20,
);
TextStyle resend = const TextStyle(
  fontWeight: FontWeight.w100,
  color: Colors.orange,
  fontSize: 20,
);
TextStyle redstyle = const TextStyle(
  fontWeight: FontWeight.w100,
  color: Colors.red,
  fontSize: 12,
);
TextStyle mywhitestyle = const TextStyle(
  fontWeight: FontWeight.w100,
  color: Colors.white,
  fontSize: 15,
  decoration: TextDecoration.none,
);
TextStyle underHeadwhite = const TextStyle(
  fontWeight: FontWeight.w100,
  color: Colors.white,
  fontSize: 20,
  decoration: TextDecoration.none,
);
}

final Styles styles = Styles();
