import 'package:flutter/material.dart';
import 'package:joker/constants/config.dart';

import '../base_model.dart';
import 'package:joker/util/dio.dart';
import 'package:dio/dio.dart';

class ResetPasswordModle extends BaseModel {
  static List<String> resetPassValidators = <String>[null];
  static List<String> resetPasskeys = <String>[
    'password',
  ];
  Map<String, String> resetPassValidationMap =
      Map<String, String>.fromIterables(resetPasskeys, resetPassValidators);
  Future<bool> resetpassword(String phone, String newPassword) async {
    setBusy(true);
    final Response<dynamic> response = await dio.post<dynamic>("resetpassword",
        data: <String, dynamic>{
          'phone': phone,
          'password': newPassword.trim()
        });
    if (response.statusCode == 422) {
      response.data['errors'].forEach((String k, dynamic vv) {
        resetPassValidationMap[k] = vv[0].toString();
      });
      notifyListeners();
      return false;
    } else {
      if (response.statusCode == 200) {
        if (response.data == "true") {
          setBusy(false);
          notifyListeners();
          return true;
        } else {
          setBusy(false);
          notifyListeners();
          return false;
        }
      } else {
        setBusy(false);
        notifyListeners();
        return false;
      }
    }
  }

  Widget returnchildResetPass(String login) {
    if (!busy) {
      return Padding(
          padding: const EdgeInsets.fromLTRB(30, 20, 30, 20),
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
