import 'dart:async';
import 'package:country_codes/country_codes.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:joker/constants/colors.dart';
import 'package:joker/constants/styles.dart';
import 'package:joker/localization/trans.dart';
import 'package:joker/util/data.dart';
import 'package:joker/util/dio.dart';
import 'package:joker/constants/config.dart';
import 'package:joker/providers/mainprovider.dart';
import 'package:joker/services/navigationService.dart';
import 'package:joker/util/service_locator.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
// import 'package:country_provider/country_provider.dart';

class Auth with ChangeNotifier {
  Auth() {
    // TODO(ahmed): do login by dio library
  }
  String myCountryCode;
  String myCountryDialCode;
  String dialCodeFav = "TR";
  String errorMessage;
  static List<String> validators = <String>[null, null];
  static List<String> keys = <String>[
    'phone',
    'password',
  ];
  static List<String> registervalidators = <String>[
    null,
    null,
    null,
    null,
    null,
    null
  ];
  static List<String> regkeys = <String>[
    'name',
    'email',
    'phone',
    'password',
    'birthdate',
    'location'
  ];
  Map<String, String> regValidationMap =
      Map<String, String>.fromIterables(regkeys, registervalidators);
  Map<String, String> loginValidationMap =
      Map<String, String>.fromIterables(keys, validators);
  static List<String> profileValidators = <String>[
    null,
    null,
    null,
    null,
    null,
    null
  ];
  static List<String> profilekeys = <String>[
    'name',
    'email',
    'phone',
    'password',
    'birthdate',
    'location'
  ];
  Map<String, String> profileValidationMap =
      Map<String, String>.fromIterables(profilekeys, profileValidators);

  static List<String> pinCodeProfileValidators = <String>[null, null];
  static List<String> pinCodeProfilekeys = <String>[
    'phone',
    'password',
  ];
  Map<String, String> pinCodeProfileValidationMap =
      Map<String, String>.fromIterables(
          pinCodeProfilekeys, pinCodeProfileValidators);

  static List<String> changePassValidators = <String>[null, null];
  static List<String> changePasskeys = <String>['old_passwoed', 'new_password'];
  Map<String, String> changePassValidationMap =
      Map<String, String>.fromIterables(changePasskeys, changePassValidators);

  static List<String> forgetPassValidators = <String>[null];
  static List<String> forgetPasskeys = <String>[
    'phone',
  ];
  Map<String, String> forgetPassValidationMap =
      Map<String, String>.fromIterables(forgetPasskeys, forgetPassValidators);
  static List<String> resetPassValidators = <String>[null];
  static List<String> resetPasskeys = <String>[
    'password',
  ];
  Map<String, String> resetPassValidationMap =
      Map<String, String>.fromIterables(resetPasskeys, resetPassValidators);
  Future<void> getCountry(String countryCode) async {
    await CountryCodes
        .init(); // Optionally, you may provide a `Locale` to get countrie's localizadName

    print("dialCodeFav $myCountryDialCode $dialCodeFav");
    final CountryDetails details =
        CountryCodes.detailsForLocale(Locale(dialCodeFav, dialCodeFav));
    // final Country result = await CountryProvider.getCountryByCode(countryCode);
    myCountryDialCode = details.dialCode;
    print("myCountryDialCode $myCountryDialCode $dialCodeFav");
    notifyListeners();
    // print("numricCode:    ${result.callingCodes}");
  }

  void saveCountryCode(String code, String dialCode) {
    myCountryCode = code;
    myCountryDialCode = dialCode;
    data.setData("countryCodeTemp", code);
    data.setData("countryDialCodeTemp", dialCode);
    notifyListeners();
  }

  // void setDialCodee(String dialCode) {
  //   myCountryDialCode = dialCode;
  //
  //   notifyListeners();
  // }

  Future<bool> login(String username, String pass, BuildContext context) async {
    print(
        "loging info:${myCountryDialCode + username.replaceAll("^0+", "").toString().trim()}");
    bool res;
    final OSPermissionSubscriptionState status =
        await OneSignal.shared.getPermissionSubscriptionState();

    final String playerId = status.subscriptionStatus.userId;
    await dio.post<dynamic>("login", data: <String, dynamic>{
      "phone":
          myCountryDialCode + username.replaceAll("^0+", "").toString().trim(),
      "password": pass.toString(),
      "onesignal_player_id": playerId
    }).then((Response<dynamic> value) async {
      // print(value.data);

      if (value.statusCode == 422) {
        value.data['errors'].forEach((String k, dynamic vv) {
          loginValidationMap[k] = vv[0].toString();
        });

        res = false;
        notifyListeners();
      }

      if (value.statusCode == 200) {
        if (value.data != "fail") {
          data.setData("username", value.data['name'].toString());
          data.setData("profile_pic", value.data['image'].toString());
          await data.setData(
              "authorization", "Bearer ${value.data['api_token']}");
          dio.options.headers['authorization'] =
              'Bearer ${value.data['api_token']}';

          config.loggedin = true;

          Navigator.popAndPushNamed(context, '/MapAsHome',
              arguments: <String, dynamic>{
                "lat": config.lat,
                "long": config.long
              });
          // Navigator.popAndPushNamed(context, '/Home',
          //     arguments: <String, dynamic>{
          //       "salesDataFilter": false,
          //       "FilterData": null
          //     });
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
              // IconToastWidget.fail(msg: trans(context, 'wrong_user_or_pass')),
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
    notifyListeners();
    return res;
  }

  Future<bool> register(
    BuildContext context,
    MainProvider mainProv,
    String username,
    String pass,
    String birth,
    String email,
    String mobile,
  ) async {
    print("loging info:${myCountryDialCode + mobile.replaceAll("^0+", "")}");
    bool res;
    await dio.post<dynamic>("register", data: <String, dynamic>{
      "name": username,
      "password": pass,
      "password_confirmation": pass,
      "birth_date": birth,
      "email": email,
      "phone": myCountryDialCode + mobile.replaceAll("^0+", ""),
      "country_id": 1,
      "city_id": 1,
      "address": config.locationController.text,
      "longitude": config.long,
      "latitude": config.lat
    }).then((Response<dynamic> value) async {
      if (value.statusCode == 422) {
        value.data['errors'].forEach((String k, dynamic vv) {
          regValidationMap[k] = vv[0].toString();
        });
        res = false;
      }
      if (value.statusCode == 201) {
        print(value.data);

        Navigator.pushNamed(context, '/pin', arguments: <String, String>{
          'mobileNo': myCountryDialCode + mobile.replaceAll("^0+", "")
        });
        config.locationController.clear();
        await data.setData("id", value.data['data']['id'].toString());
        data.setData("email", email);
        data.setData("username", username);
        data.setData("password", pass);
        data.setData("phone", myCountryDialCode + mobile.replaceAll("^0+", ""));
        data.setData("lat", config.lat.toString());
        data.setData("long", config.long.toString());
        data.setData("address", config.locationController.text.toString());
        res = true;
      } else {
        res = false;
      }
      mainProv.togelf(false);
    });
    notifyListeners();
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

  Future<void> signOut() async {
    await data.setData('authorization', null);
    dio.options.headers['authorization'] = "";
    config.loggedin = false;
    getIt<NavigationService>().navigateTo('/login', null);
  }

  Future<bool> changePassword(
      String oldpassword, String newpassword, BuildContext context) async {
    final Response<dynamic> response = await dio.post<dynamic>("changepassword",
        data: <String, dynamic>{
          'old_password': oldpassword.trim(),
          'new_password': newpassword.trim()
        });
    if (response.statusCode == 200) {
      notifyListeners();
      data.setData("password", newpassword.trim());
      Navigator.pushNamed(context, '/login');
      return true;
    } else {
      if (response.statusCode == 422) {
        response.data['errors'].forEach((String k, dynamic vv) {
          changePassValidationMap[k] = vv[0].toString();
        });
      }
      notifyListeners();
      return false;
    }
  }

  Future<bool> resendCode(String mobile) async {
    final Response<dynamic> response = await dio.post<dynamic>("resend",
        data: <String, dynamic>{
          "phone": myCountryDialCode + mobile.toString()
        });

    if (response.statusCode == 200) {
      await data.setData("phone", myCountryDialCode + mobile.toString());
      notifyListeners();
      return true;
    } else {
      response.data['errors'].forEach((String k, dynamic vv) {
        forgetPassValidationMap[k] = vv[0].toString();
      });

      notifyListeners();
      return false;
    }
  }

  Future<void> verifyCode(String mobile, String v, BuildContext context) async {
    final Response<dynamic> correct = await dio.post<dynamic>("verfiy",
        data: <String, dynamic>{
          "phone": myCountryDialCode + mobile,
          "verfiy_code": v
        });
    print(correct.data);
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
      notifyListeners();
    } else {
      Navigator.pushNamedAndRemoveUntil(context, '/Reset_pass', (_) => false);
    }
  }

  Future<bool> getPinCode(String code) async {
    final String phone = await data.getData("phone");
    print("phone  $phone");
    final Response<dynamic> correct = await dio.post<dynamic>("verfiy",
        data: <String, dynamic>{"phone": phone, "verfiy_code": code});
    print("correct data : ${correct.data}");
    if (correct.data == "false") {
      notifyListeners();
      return false;
    } else {
      notifyListeners();
      return true;
    }
  }

  Future<bool> updateProfile(
      String username, String birthDate, String email) async {
    final Response<dynamic> response =
        await dio.post<dynamic>("update", data: <String, dynamic>{
      "name": username,
      "birth_date": birthDate,
      "email": email,
      "country_id": 1,
      "city_id": 1,
      "address": config.locationController.text,
      "longitude": config.long,
      "latitude": config.lat
    });
    if (response.statusCode == 422) {
      response.data['errors'].forEach((String k, dynamic vv) {
        profileValidationMap[k] = vv[0].toString();
      });

      notifyListeners();
      return false;
    } else {
      if (response.statusCode == 200) {
        data.setData("email", email);
        data.setData("username", username);
        data.setData("lat", config.lat.toString());
        data.setData("long", config.long.toString());
        data.setData("address", config.locationController.text.toString());
        notifyListeners();
        return true;
      } else {
        notifyListeners();
        return false;
      }
    }
  }

  Future<dynamic> changeProfilePic(dynamic formData) async {
    final Response<dynamic> response = await dio.post<dynamic>(
      "avatar",
      data: formData,
      onSendProgress: (int sent, int total) {},
    );
    return response;
  }

  Future<bool> getPinCodeSave(String code, String mobile) async {
    final Response<dynamic> correct = await dio.put<dynamic>("save_phone",
        data: <String, dynamic>{
          "new_phone": myCountryDialCode + mobile,
          "verfiy_code": code
        });
    if (correct.data == "false") {
      notifyListeners();
      return false;
    } else {
      notifyListeners();
      return true;
    }
  }

  Future<bool> verifyNewPhone(String password, String mobile) async {
    final Response<dynamic> response = await dio.put<dynamic>("update_phone",
        queryParameters: <String, dynamic>{
          "password": password,
          "new_phone": myCountryDialCode + mobile
        });

    if (response.statusCode == 422) {
      response.data['errors'].forEach((String k, dynamic vv) {
        pinCodeProfileValidationMap[k] = vv[0].toString();
      });
      return false;
    }
    if (response.statusCode == 200) {
      data.setData("phone", myCountryDialCode + mobile);
      notifyListeners();
      return true;
    } else {
      notifyListeners();
      return false;
    }
  }

  Future<bool> sendPinNewPhone(String newPhone, BuildContext context) async {
    final String phone = await data.getData("phone");
    final String id = await data.getData("id");
    final String email = await data.getData("email");
    final Response<dynamic> correct =
        await dio.put<dynamic>("change_phone", data: <String, dynamic>{
      "id": id,
      "phone": phone,
      "email": email,
      "new_phone": myCountryDialCode + newPhone
    });
    if (correct.statusCode == 422) {
      errorMessage = correct.data['errors']['new_phone'][0].toString();
      showToast(errorMessage,
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
      return false;
    } else if (correct.statusCode == 200) {
      notifyListeners();
      data.setData("phone", correct.data['phone'].toString());
      Navigator.pop(context);

      return true;
    } else {
      notifyListeners();
      return false;
    }
  }

  Future<bool> resetpassword(String phone, String newPassword) async {
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
          notifyListeners();
          return true;
        } else {
          notifyListeners();
          return false;
        }
      } else {
        notifyListeners();
        return false;
      }
    }
  }
}
