import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:joker/constants/config.dart';
import '../base_model.dart';
import 'package:joker/util/data.dart';
import 'package:joker/util/dio.dart';

class ChangePasswordModle extends BaseModel {
  static List<String> changePassValidators = <String>[null, null];
  static List<String> changePasskeys = <String>['old_passwoed', 'new_password'];
  Map<String, String> changePassValidationMap =
      Map<String, String>.fromIterables(changePasskeys, changePassValidators);
  Future<bool> changePassword(
      String oldpassword, String newpassword, BuildContext context) async {
    setBusy(true);
    final Response<dynamic> response = await dio.post<dynamic>("changepassword",
        data: <String, dynamic>{
          'old_password': oldpassword.trim(),
          'new_password': newpassword.trim()
        });
    if (response.statusCode == 200) {
      data.setData("password", newpassword.trim());
      Navigator.pushNamedAndRemoveUntil(context, '/login', (_) => false);
      setBusy(false);
      return true;
    } else {
      if (response.statusCode == 422) {
        response.data['errors'].forEach((String k, dynamic vv) {
          changePassValidationMap[k] = vv[0].toString();
        });
      }
      setBusy(false);
      return false;
    }
  }
    Widget returnchildChangePass(String login) {
    
    if (!busy) {
      return Padding(
          padding: const EdgeInsets.fromLTRB(30, 5, 30, 5),
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
