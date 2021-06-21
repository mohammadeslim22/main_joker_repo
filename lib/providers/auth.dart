import 'dart:async';
import 'package:flutter/material.dart';
import 'package:joker/localization/trans.dart';
import 'package:joker/services/navigationService.dart';
import 'package:joker/util/data.dart';
import 'package:joker/util/dio.dart';
import 'package:joker/constants/config.dart';
import 'package:joker/util/service_locator.dart';

class Auth with ChangeNotifier {
  bool isAuthintecated = false;

  String myCountryCode;
  String myCountryDialCode = "+90";
  String dialCodeFav = "TR";
  String errorMessage;
  String email;
  String username;
  String mobile;
  String dateOfBirth;
  String address;
  String userPicture =
      "https://png.pngtree.com/png-clipart/20190924/original/pngtree-businessman-user-avatar-free-vector-png-image_4827807.jpg";

  void getCountry(String countryCode) {
    myCountryDialCode = config.countriesDialCodes[dialCodeFav];
    notifyListeners();
  }

  void saveCountryCode(String code, String dialCode) {
    myCountryDialCode = dialCode;
    data.setData("countryCodeTemp", code);
    data.setData("countryDialCodeTemp", dialCode);
    notifyListeners();
  }

  void changeAddress(String address) {
    address = address;
    notifyListeners();
  }

  Future<void> setUserPicture(String pic) async {
    userPicture = pic;
    print("userPicture $userPicture");
    notifyListeners();
    await data.setData("user_data",
        "$username::$userPicture::$email::$mobile::$dateOfBirth::$address");
  }

  void setUserData(String pic, String useremail, String name, String mpbile,
      String dob, String adres) {
    email = useremail;
    username = name;
    mobile = mobile;
    userPicture = pic;
    dateOfBirth = dob;
    address = adres;
    notifyListeners();
  }

  void changeUsername(String name) {
    username = name;
    notifyListeners();
  }

  void changeIsAuthToFalse() {
    isAuthintecated = false;

    notifyListeners();
  }

  void changeIsAuthToTrue() {
    isAuthintecated = true;
    notifyListeners();
  }

  Future<void> setUserAndPicture() async {
    if (config.loggedin) {
      final String userData = await data.getData("user_data");

      changeIsAuthToTrue();
      if (userData.isEmpty || userData == null) {
      } else {
        final List<String> ss = userData.split("::");
        setUserData(ss[1], ss[2], ss[0], ss[3], ss[4], ss[5]);
        ss.clear();
      }
    } else {
      changeIsAuthToFalse();
      changeUsername(getIt<NavigationService>()
          .translateWithNoContext("login_or_sign_up"));
    }
    notifyListeners();
  }

  Future<void> signOut(BuildContext c) async {
    await data.setData('authorization', null);
    dio.options.headers['authorization'] = "";
    config.loggedin = false;
    isAuthintecated = false;
    setUserPicture(
        "https://png.pngtree.com/png-clipart/20190924/original/pngtree-businessman-user-avatar-free-vector-png-image_4827807.jpg");
    changeUsername(trans(c, "login_or_sign_up"));
    notifyListeners();
    getIt<NavigationService>().navigateTo('/login', null);
  }
}
