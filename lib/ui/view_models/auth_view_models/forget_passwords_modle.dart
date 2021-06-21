import 'package:flutter/material.dart';
// import 'package:joker/constants/colors.dart';
import 'package:joker/constants/config.dart';
import 'package:joker/constants/styles.dart';
import 'package:joker/providers/auth.dart';
import 'package:joker/util/data.dart';
import 'package:joker/util/dio.dart';
import 'package:dio/dio.dart';
import 'package:joker/util/service_locator.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:joker/constants/colors.dart';
import '../base_model.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';

enum ViewState { Idle, Busy }

class ForgetPassModle extends BaseModel {
  ViewState state = ViewState.Idle;
  bool loading = false;
  // bool loadingforgetPass = false;
  bool codeArrived = false;
  // static AnimationController _controller;
  bool visibilityObs = false;
  static List<String> forgetPassValidators = <String>[null];
  static List<String> forgetPasskeys = <String>[
    'phone',
  ];
  Map<String, String> forgetPassValidationMap =
      Map<String, String>.fromIterables(forgetPasskeys, forgetPassValidators);
  void setState(ViewState viewState) {
    state = viewState;
    notifyListeners();
  }

  // final SpinKitDoubleBounce spinkit = SpinKitDoubleBounce(
  //     color: colors.white, size: 50.0, controller: _controller);
  Widget returnchildForgetPass(String login) {
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

  Future<void> verifyCode(String mobile, String v, BuildContext context) async {
    setBusy(true);
    final Response<dynamic> correct = await dio.post<dynamic>("verfiy",
        data: <String, dynamic>{
          "phone": getIt<Auth>().myCountryDialCode + mobile,
          "verfiy_code": v
        });
    if (correct.data == "false") {
      showToast('The Code You Enterd Was Not Correct',
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
      notifyListeners();
    } else {
      setBusy(false);
      Navigator.pushNamedAndRemoveUntil(context, '/Reset_pass', (_) => false);
    }
  }

  String mainButtonkey = "send_code";
  Future<bool> resendCode(String mobile) async {
    print(
        "getIt<Auth>().myCountryDialCode + mobile.toString() ${getIt<Auth>().myCountryDialCode + mobile.toString()}");
    setState(ViewState.Busy);
    final Response<dynamic> response = await dio.post<dynamic>("resend",
        data: <String, dynamic>{
          "phone": getIt<Auth>().myCountryDialCode + mobile.toString()
        });

    if (response.statusCode == 200) {
      await data.setData(
          "phone", getIt<Auth>().myCountryDialCode + mobile.toString());
      codeArrived = true;
      mainButtonkey = 'submet';
      setState(ViewState.Idle);
      notifyListeners();
      return true;
    } else {
      response.data['errors'].forEach((String k, dynamic vv) {
        forgetPassValidationMap[k] = vv[0].toString();
      });
      setState(ViewState.Idle);

      notifyListeners();
      return false;
    }
  }
}
