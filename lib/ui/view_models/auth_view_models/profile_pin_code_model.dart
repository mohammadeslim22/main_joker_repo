import 'package:flutter/material.dart';
import 'package:joker/constants/config.dart';
import 'package:joker/providers/auth.dart';
import 'package:joker/util/data.dart';
import 'package:joker/util/dio.dart';
import 'package:joker/util/service_locator.dart';
import 'package:dio/dio.dart';
import '../base_model.dart';

// enum ViewState { Idle, Busy }

class PinCodeProfileModle extends BaseModel {
  static List<String> pinCodeProfileValidators = <String>[null, null];
  static List<String> pinCodeProfilekeys = <String>[
    'phone',
    'password',
  ];
  Map<String, String> pinCodeProfileValidationMap =
      Map<String, String>.fromIterables(
          pinCodeProfilekeys, pinCodeProfileValidators);

  Future<bool> verifyNewPhone(String password, String mobile) async {
    setBusy(true);
    final Response<dynamic> response = await dio.put<dynamic>("update_phone",
        queryParameters: <String, dynamic>{
          "password": password,
          "new_phone": getIt<Auth>().myCountryDialCode + mobile
        });

    if (response.statusCode == 422) {
      response.data['errors'].forEach((String k, dynamic vv) {
        pinCodeProfileValidationMap[k] = vv[0].toString();
      });
      setBusy(false);
      return false;
    }
    if (response.statusCode == 200) {
      data.setData("phone", getIt<Auth>().myCountryDialCode + mobile);
      setBusy(false);
      return true;
    } else {
      setBusy(false);
      return false;
    }
  }

  Widget returnchildPinforProfile(String login) {
    if (!busy) {
      return Padding(
          padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
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

  Future<bool> getPinCodeSave(String code, String mobile) async {
    setBusy(true);
    final Response<dynamic> correct = await dio.put<dynamic>("save_phone",
        data: <String, dynamic>{
          "new_phone": getIt<Auth>().myCountryDialCode + mobile,
          "verfiy_code": code
        });
    if (correct.data == "false") {
      setBusy(false);
      return false;
    } else {
      getIt<Auth>().setUserData(null, null, null,
          getIt<Auth>().myCountryDialCode + mobile, null, null);
      setBusy(false);
      return true;
    }
  }
}
