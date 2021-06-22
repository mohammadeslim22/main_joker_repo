import 'package:flutter/material.dart';
import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:joker/constants/colors.dart';
import 'package:joker/localization/trans.dart';
import 'package:joker/providers/auth.dart';
import 'package:joker/ui/view_models/notifications_modle.dart';
import 'package:joker/util/data.dart';
import 'package:joker/util/dio.dart';
import 'package:joker/constants/config.dart';
import 'package:joker/util/service_locator.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

import '../base_model.dart';

class LoginModel extends BaseModel {
  ViewState state = ViewState.Idle;

  static List<String> validators = <String>[null, null];
  static List<String> keys = <String>[
    'phone',
    'password',
  ];
  Map<String, String> loginValidationMap =
      Map<String, String>.fromIterables(keys, validators);

  Future<bool> login(String username, String pass, BuildContext context) async {
    setBusy(true);
    bool res;
    final OSPermissionSubscriptionState status =
        await OneSignal.shared.getPermissionSubscriptionState();
    final String playerId = status.subscriptionStatus.userId;
    await dio.post<dynamic>("login", data: <String, dynamic>{
      "phone": getIt<Auth>().myCountryDialCode +
          username.replaceAll(RegExp(r'^0+(?=.)'), '').toString().trim(),
      "password": pass.toString(),
      "onesignal_player_id": playerId
    }).then((Response<dynamic> value) async {
      if (value.statusCode == 422) {
        value.data['errors'].forEach((String k, dynamic vv) {
          loginValidationMap[k] = vv[0].toString();
        });

        res = false;
        notifyListeners();
      }

      if (value.statusCode == 200) {
        if (value.data != "fail") {
          data.setData("user_data",
              "${value.data['data']['name'].toString()}::${value.data['data']['image'].toString()}::${value.data['data']['email'].toString()}::${value.data['data']['phone'].toString()}::${value.data['data']['birth_date'].toString()}::${value.data['data']['address'].toString()}");
          getIt<Auth>().setUserData(
              value.data['data']['image'].toString(),
              value.data['data']['email'].toString(),
              value.data['data']['name'].toString(),
              value.data['data']['phone'].toString(),
              value.data['data']['birth_date'].toString(),
              value.data['data']['address'].toString());

          getIt<NotificationsModel>()
              .setnotificationdCount(value.data['data']['unread_count'] as int);
          notifyListeners();

          dio.options.headers['authorization'] =
              "Bearer ${value.data['data']['api_token']}";
          await data.setData(
              "authorization", "Bearer ${value.data['data']['api_token']}");

          config.loggedin = true;

          getIt<Auth>().isAuthintecated = true;
          Navigator.popAndPushNamed(context, '/MapAsHome',
              arguments: <String, dynamic>{
                "lat": config.lat,
                "long": config.long
              });

          res = true;
        } else {
          showToastWidget(
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                color: colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset("assets/images/ic_fail.png",
                        height: 60, width: 60, color: colors.ggrey),
                    const SizedBox(width: 12),
                    Text(trans(context, 'wrong_user_or_pass')),
                  ],
                ),
              ),
              context: context,
              position: StyledToastPosition.center,
              animation: StyledToastAnimation.scale,
              reverseAnimation: StyledToastAnimation.fade,
              duration: const Duration(seconds: 4),
              animDuration: const Duration(seconds: 1),
              curve: Curves.elasticOut,
              reverseCurve: Curves.linear);

          res = false;
        }
      } else {
        res = false;
      }
    });
    setBusy(false);
    notifyListeners();
    return res;
  }

  Widget changechildLogin(String login) {
    if (!busy) {
      return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          child: Text(login,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 25,
              )));
    } else {
      return config.spinkit;
    }
  }
}
