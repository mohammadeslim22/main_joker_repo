import 'package:flutter/material.dart';
import 'package:joker/constants/config.dart';
import 'package:joker/providers/auth.dart';
import 'package:joker/util/data.dart';
import 'package:joker/util/dio.dart';
import 'package:dio/dio.dart';
import 'package:joker/util/service_locator.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:joker/constants/colors.dart';
import 'package:joker/constants/styles.dart';

import '../base_model.dart';

class PinCodeModle extends BaseModel {
  Future<bool> getPinCode(String code) async {
    setBusy(true);
    final String phone = await data.getData("phone");
    final Response<dynamic> correct = await dio.post<dynamic>("verfiy",
        data: <String, dynamic>{"phone": phone, "verfiy_code": code});
    if (correct.data == "false") {
      setBusy(false);
      return false;
    } else {
      setBusy(false);
      return true;
    }
  }

  Future<bool> sendPinNewPhone(String newPhone, BuildContext context) async {
    setBusy(true);
    final String phone = await data.getData("phone");
    final String id = await data.getData("id");
    final String email = await data.getData("email");
    final Response<dynamic> correct =
        await dio.put<dynamic>("change_phone", data: <String, dynamic>{
      "id": id,
      "phone": phone,
      "email": email,
      "new_phone": getIt<Auth>().myCountryDialCode + newPhone
    });
    if (correct.statusCode == 422) {
      showToast(correct.data['errors']['new_phone'][0].toString(),
          context: context,
          textStyle: styles.underHeadblack,
          animation: StyledToastAnimation.scale,
          reverseAnimation: StyledToastAnimation.fade,
          position: StyledToastPosition.center,
          animDuration: const Duration(seconds: 1),
          duration: const Duration(seconds: 4),
          curve: Curves.elasticOut,
          backgroundColor: colors.white,
          reverseCurve: Curves.decelerate);
      setBusy(false);
      return false;
    } else if (correct.statusCode == 200) {
      setBusy(false);
      data.setData("phone", correct.data['phone'].toString());
      Navigator.pop(context);

      return true;
    } else {
      setBusy(false);
      return false;
    }
  }

  Widget returnchildforPinCode(String login) {
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
