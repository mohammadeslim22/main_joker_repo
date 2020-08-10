import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:joker/localization/trans.dart';
import 'package:joker/ui/widgets/custom_toast_widget.dart';
import 'package:joker/util/data.dart';
import 'package:joker/util/dio.dart';

class Auth with ChangeNotifier {
  Auth() {
    // TODO(ahmed): do login by dio library
  }
  static List<String> validators = <String>[null, null];
  static List<String> keys = <String>[
    'phone',
    'password',
  ];

  Map<String, String> validationMap =
      Map<String, String>.fromIterables(keys, validators);
  Future<bool> login(String countryCode, String username, String pass,
      BuildContext context) async {
    bool res;
    await dio.post<dynamic>("login", data: <String, dynamic>{
      "phone": countryCode + username.toString().trim(),
      "password": pass.toString()
    }).then((Response<dynamic> value) async {
      if (value.statusCode == 422) {
        value.data['errors'].forEach((String k, dynamic vv) {
          validationMap[k] = vv[0].toString();
        });
        validationMap.updateAll((String key, String value) {
          return null;
        });
        res = false;
      }

      if (value.statusCode == 200) {
        if (value.data != "fail") {
          await data.setData(
              "authorization", "Bearer ${value.data['api_token']}");
          dio.options.headers['authorization'] =
              'Bearer ${value.data['api_token']}';

          Navigator.pushNamed(context, '/Home', arguments: <String, dynamic>{
            "salesDataFilter": false,
            "FilterData": null
          });
          res = true;
        } else {
          showToastWidget(
              IconToastWidget.fail(msg: trans(context, 'wrong_user_or_pass')),
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

    return res;
  }

  Map<String, dynamic> user;
  StreamSubscription<dynamic> userAuthSub;

  @override
  void dispose() {
    if (userAuthSub != null) {
      userAuthSub.cancel();
      userAuthSub = null;
    }
    super.dispose();
  }

  bool get isAuthenticated {
    return user != null;
  }

  void signInAnonymously() {}

  void signOut() {}
}
