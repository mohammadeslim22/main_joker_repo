import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:joker/localization/trans.dart';
import 'package:joker/ui/widgets/custom_toast_widget.dart';
import 'package:joker/util/data.dart';
import 'package:joker/util/dio.dart';
import 'package:joker/constants/config.dart';
import 'package:joker/providers/mainprovider.dart';
import 'package:joker/services/navigationService.dart';
import 'package:joker/util/service_locator.dart';
import 'package:country_provider/country_provider.dart';

class Auth with ChangeNotifier {
  Auth() {
    // TODO(ahmed): do login by dio library
  }
  String myCountryCode;
  String myCountryDialCode;
    String dialCodeFav;

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
  Map<String, String> validationMap =
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
      Map<String, String>.fromIterables(keys, validators);

  static List<String> pinCodeProfileValidators = <String>[null, null];
  static List<String> pinCodeProfilekeys = <String>[
    'phone',
    'password',
  ];
  Map<String, String> pinCodeProfileValidationMap =
      Map<String, String>.fromIterables(keys, validators);

  Future<void> getCountry(String countryCode) async {
    final Country result = await CountryProvider.getCountryByCode(countryCode);
    myCountryCode = result.callingCodes.first;
    print("numricCode:    ${result.callingCodes}");
  }

  void saveCountryCode(String code, String dialCode) {
    myCountryCode = dialCode;
    myCountryDialCode = code;
    data.setData("countryCodeTemp", code);
    data.setData("countryDialCodeTemp", dialCode);

    notifyListeners();
  }

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
        // validationMap.updateAll((String key, String value) {
        //   return null;
        // });
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
      String countryCodeTemp) async {
    bool res;
    await dio.post<dynamic>("register", data: <String, dynamic>{
      "name": username,
      "password": pass,
      "password_confirmation": pass,
      "birth_date": birth,
      "email": email,
      "phone": countryCodeTemp + mobile,
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

        // regValidationMap.updateAll((String key, String value) {
        //   return null;
        // });
        res = false;
      }
      if (value.statusCode == 201) {
        print(value.data);

        Navigator.pushNamed(context, '/pin',
            arguments: <String, String>{'mobileNo': countryCodeTemp + mobile});
        config.locationController.clear();
        await data.setData("id", value.data['data']['id'].toString());
        data.setData("email", email);
        data.setData("username", username);
        data.setData("password", pass);
        data.setData("phone", countryCodeTemp + mobile);
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

  void signOut() {
    data.setData('authorization', "");
    getIt<NavigationService>().navigateTo('/login', null);
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
      profileValidationMap.updateAll((String key, String value) {
        return null;
      });
      return false;
    } else {
      if (response.statusCode == 200) {
        data.setData("email", email);
        data.setData("username", username);
        data.setData("lat", config.lat.toString());
        data.setData("long", config.long.toString());
        data.setData("address", config.locationController.text.toString());
        return true;
      } else {
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

  Future<bool> getPinCode(String code, String mobile) async {
    final Response<dynamic> correct = await dio.put<dynamic>("save_phone",
        data: <String, dynamic>{
          "new_phone": myCountryCode + mobile,
          "verfiy_code": code
        });
    print(correct.data);
    if (correct.data == "false") {
      print(correct.data);
      return false;
    } else {
      print(correct.data);
      return true;
    }
  }

  Future<bool> verifyNewPhone(String password, String mobile) async {
    final Response<dynamic> response = await dio.put<dynamic>("update_phone",
        queryParameters: <String, dynamic>{
          "password": password,
          "new_phone": myCountryCode + mobile
        });

    if (response.statusCode == 422) {
      response.data['errors'].forEach((String k, dynamic vv) {
        pinCodeProfileValidationMap[k] = vv[0].toString();
      });
      pinCodeProfileValidationMap.updateAll((String key, String value) {
        return null;
      });
      return false;
    }
    if (response.statusCode == 200) {
      data.setData("phone", myCountryCode + mobile);
      return true;
    } else {
      return false;
    }
  }
}
