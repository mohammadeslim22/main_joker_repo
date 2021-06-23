import 'package:flutter/material.dart';
import 'package:joker/constants/config.dart';
import 'package:joker/providers/auth.dart';
import 'package:joker/util/data.dart';
import 'package:joker/util/dio.dart';
import 'package:dio/dio.dart';
import 'package:joker/util/service_locator.dart';

import '../base_model.dart';

class ProfileModle extends BaseModel {
  bool visibilityObs = false;
  void togelocationloading(bool state) {
    visibilityObs = state;
    notifyListeners();
  }

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

  Future<dynamic> changeProfilePic(dynamic formData) async {
    final Response<dynamic> response = await dio.post<dynamic>(
      "avatar",
      data: formData,
      onSendProgress: (int sent, int total) {},
    );
    return response;
  }

  Future<Map<String, String>> getUserData() async {
    final String userData = await data.getData("user_data");
    return <String, String>{
      "name": userData.split("::")[0],
      "image": userData.split("::")[1],
      "email": userData.split("::")[2],
      "phone": userData.split("::")[3],
      "birthdate": userData.split("::")[4],
      "address": userData.split("::")[5]
    };
  }

  Future<bool> updateProfile(
      String username, String birthDate, String email, String address) async {
    setBusy(true);
    final Response<dynamic> response =
        await dio.post<dynamic>("update", data: <String, dynamic>{
      "name": username,
      "birth_date": birthDate,
      "email": email,
      "country_id": 1,
      "city_id": 1,
      "address": address,
      "longitude": config.long,
      "latitude": config.lat
    });
    if (response.statusCode == 422) {
      response.data['errors'].forEach((String k, dynamic vv) {
        profileValidationMap[k] = vv[0].toString();
      });

      setBusy(false);
      return false;
    } else {
      if (response.statusCode == 200) {
        data.setData("user_data",
            "$username::${getIt<Auth>().userPicture.toString()}::$email::${getIt<Auth>().mobile}::$birthDate::$address");
        getIt<Auth>()
            .setUserData(null, email, username, null, birthDate, address);
        setBusy(false);
        return true;
      } else {
        setBusy(false);
        return false;
      }
    }
  }

  Widget returnchildforProfile(String login) {
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
