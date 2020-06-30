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

  TextStyle smallButton =
      TextStyle(fontSize: 12, color: colors.black, fontWeight: FontWeight.w100);
      TextStyle smallButtonactivated =
      TextStyle(fontSize: 12, color: colors.orange, fontWeight: FontWeight.w100);
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
    height: 1.7
  );
    TextStyle mysmallforgridview = const TextStyle(
    fontWeight: FontWeight.w100,
    
    fontSize: 13,
  );
  TextStyle mystyle = const TextStyle(
      fontWeight: FontWeight.w100,
      color: Colors.black,
      fontSize: 15,
      height: 1.7
      );

        TextStyle myredstyle = const TextStyle(
      fontWeight: FontWeight.w100,
      color: Colors.red,
      fontSize: 15,
      height: 1.7
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
      height: 1.7);
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
    TextStyle saleScreenBottomBar = const TextStyle(
    fontWeight: FontWeight.w600,
    color: Colors.orangeAccent,
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
    TextStyle redstyleForSaleScreen = const TextStyle(
    fontWeight: FontWeight.w900,
    color: Colors.red,
    fontSize:24,
  );
  TextStyle mywhitestyle = const TextStyle(
    fontWeight: FontWeight.w100,
    color: Colors.white,
    fontSize: 15,
    decoration: TextDecoration.none,
  );
  TextStyle underHeadwhite = const TextStyle(
    fontWeight: FontWeight.w300,
    color: Colors.white,
    fontSize: 20,
    height: 1.5,
    decoration: TextDecoration.none,
  );
    TextStyle memberShipBottomSheet = const TextStyle(
    fontWeight: FontWeight.w600,
    color: Colors.white,
    fontSize: 15,
  );
      TextStyle memberShipBottomSheetmercahnt = TextStyle(
    fontWeight: FontWeight.w200,
    color: colors.grey,
    fontSize: 15,
  );
  TextStyle memberSipMessageText = const TextStyle(fontSize: 12.0, height: 1.7);

  TextStyle memberShipMessage = TextStyle(fontSize: 15.0, color: colors.green);
}

final Styles styles = Styles();
