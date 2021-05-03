import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pagewise/flutter_pagewise.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:joker/models/notification.dart';
import 'package:joker/providers/auth.dart';
import 'package:joker/util/dio.dart';
import 'package:joker/util/service_locator.dart';
import '../constants/colors.dart';

class MainProvider extends ChangeNotifier {
  bool darkthemeIson = false;
  bool loadingRegister = false;
  bool loadingProfile = false;
  bool loadingLogin = false;
  bool loadingResetPass = false;
  bool loadingChangePass = false;
  bool loadingPinCode = false;
  bool loadingforgetPass = false;
  bool loadingpinCoDeProfile = false;
  static TickerProvider c;
  static String loginbase = "login";
  static String registerbase = "register";

  static AnimationController _controller;
  int _currentIndex = 0;
  int favocurrentIndex = 0;
  String profileUrl = "";
  List<bool> fontlist = <bool>[false, true, false];
  List<bool> language = <bool>[false, false, false];
  bool _visible = true;
  bool __visible = false;
  bool visibilityObs = false;
  Jnotification n = Jnotification(data: <NotificationData>[]);
  List<bool> notificationSit = <bool>[true, false];
  PagewiseLoadController<dynamic> pagewiseNotificationsController;

  Future<void> openNotifications(int nId) async {
    await dio.post<dynamic>("notifications",
        queryParameters: <String, dynamic>{"id": nId});
    n.data.firstWhere((NotificationData element) {
      return element.id == nId;
    }).isread = 1;
    getIt<Auth>().minnotificationdCount1();
    notifyListeners();
  }

  Future<List<NotificationData>> getNotifications(int pageNumber) async {
    final Response<dynamic> response = await dio.get<dynamic>("notifications",
        queryParameters: <String, int>{"page": pageNumber + 1});
    n = Jnotification.fromJson(response.data);
    notifyListeners();
    return n.data;
  }

  int get bottomNavIndex => _currentIndex;
  bool get visible1 => _visible;
  List<bool> get font => fontlist;
  List<bool> get lang => language;

  bool get visible2 => __visible;
  void changebottomNavIndex(int id) {
    _currentIndex = id;

    notifyListeners();
  }

  void changeImageUrl(String path) {
    profileUrl = path;
    notifyListeners();
  }

  void changenotificationSit(int state) {
    notificationSit = state == 0 ? <bool>[true, false] : <bool>[false, true];
    notifyListeners();
  }

  void changeTheme(bool state) {
    darkthemeIson = state;
    notifyListeners();
  }

  void changelanguageindex(int index) {
    for (int i = 0; i < language.length; i++) {
      if (i == index) {
        language[i] = true;
      } else {
        language[i] = false;
      }
    }

    notifyListeners();
  }

  void changefontindex(int index) {
    for (int i = 0; i < fontlist.length; i++) {
      if (i == index) {
        fontlist[i] = true;
      } else {
        fontlist[i] = false;
      }
    }

    notifyListeners();
  }

  void changeTabBarIndex(int id) {
    favocurrentIndex = id;
    _visible = !_visible;
    __visible = !__visible;
    notifyListeners();
  }

  final SpinKitDoubleBounce spinkit = SpinKitDoubleBounce(
      color: colors.white, size: 50.0, controller: _controller);
  Widget f;
  Widget changechildforRegister(String login) {
    loginbase = login;
    if (!loadingRegister) {
      return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          child: Text(loginbase,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 25,
              )));
    } else {
      return spinkit;
    }
  }

  Widget changechildLogin(String login) {
    loginbase = login;
    if (!loadingLogin) {
      return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          child: Text(loginbase,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 25,
              )));
    } else {
      return spinkit;
    }
  }

  Widget returnchildForgetPass(String login) {
    loginbase = login;
    if (!loadingforgetPass) {
      return Padding(
          padding: const EdgeInsets.fromLTRB(30, 20, 30, 20),
          child: Text(loginbase,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 25,
              )));
    } else {
      return spinkit;
    }
  }

  Widget returnchildResetPass(String login) {
    loginbase = login;
    if (!loadingResetPass) {
      return Padding(
          padding: const EdgeInsets.fromLTRB(30, 20, 30, 20),
          child: Text(loginbase,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 25,
              )));
    } else {
      return spinkit;
    }
  }

  Widget returnchildforProfile(String login) {
    loginbase = login;
    if (!loadingProfile) {
      return Padding(
          padding: const EdgeInsets.fromLTRB(30, 5, 30, 5),
          child: Text(loginbase,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 25,
              )));
    } else {
      return spinkit;
    }
  }

  Widget returnchildPinforProfile(String login) {
    loginbase = login;
    if (!loadingpinCoDeProfile) {
      return Padding(
          padding: const EdgeInsets.fromLTRB(30, 5, 30, 5),
          child: Text(loginbase,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 25,
              )));
    } else {
      return spinkit;
    }
  }
  Widget returnchildChangePass(String login) {
    loginbase = login;
    if (!loadingChangePass) {
      return Padding(
          padding: const EdgeInsets.fromLTRB(30, 5, 30, 5),
          child: Text(loginbase,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 25,
              )));
    } else {
      return spinkit;
    }
  }
  void togelfLogin(bool state) {
    loadingLogin = state;
    notifyListeners();
  }

  void togelfRegister(bool state) {
    loadingRegister = state;
    notifyListeners();
  }

  void togelfProfile(bool state) {
    loadingProfile = state;
    notifyListeners();
  }

  void togelfPinCodeProfile(bool state) {
    loadingpinCoDeProfile = state;
    notifyListeners();
  }

  void togelfPinCode(bool state) {
    loadingPinCode = state;
    notifyListeners();
  }

  void togelfForgetPass(bool state) {
    loadingforgetPass = state;
    notifyListeners();
  }

  void togelfResetPass(bool state) {
    loadingResetPass = state;
    notifyListeners();
  }
    void togelfChangePass(bool state) {
    loadingChangePass = state;
    notifyListeners();
  }

  void togelocationloading(bool state) {
    visibilityObs = state;
    notifyListeners();
  }
}
