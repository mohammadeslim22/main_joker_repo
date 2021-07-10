import 'package:flutter/material.dart';
import 'package:joker/constants/config.dart';
import 'package:joker/providers/auth.dart';
import 'package:joker/util/data.dart';
import 'package:joker/util/dio.dart';
import 'package:dio/dio.dart';
import 'package:joker/util/service_locator.dart';
import '/../constants/colors.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../base_model.dart';

class RegistrationModel extends BaseModel {
  bool loading = false;

  static AnimationController _controller;
  bool visibilityObs = false;

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

  Future<bool> register(BuildContext context, String username, String pass,
      String birth, String email, String mobile, String address) async {
    setBusy(true);
    bool res;
    await dio.post<dynamic>("register", data: <String, dynamic>{
      "name": username,
      "password": pass,
      "password_confirmation": pass,
      "birth_date": birth,
      "email": email,
      "phone": getIt<Auth>().myCountryDialCode +
          mobile.replaceAll(RegExp(r'^0+(?=.)'), ''),
      "country_id": 1,
      "city_id": 1,
      "address": address,
      "longitude": config.long,
      "latitude": config.lat
    }).then((Response<dynamic> value) async {
      if (value.statusCode == 200) {
        print("errors ${value.data}");
        value.data['errors'].forEach((dynamic v) {
          regValidationMap[v.keys.first.toString()] = v.values.first.toString();
        });
        res = false;
      }
      if (value.statusCode == 201) {
        Navigator.pushNamed(context, '/pin', arguments: <String, String>{
          'mobileNo': getIt<Auth>().myCountryDialCode +
              mobile.replaceAll(RegExp(r'^0+(?=.)'), '')
        });

        await data.setData("id", value.data['data']['id'].toString());
        data.setData("email", email);
        data.setData("username", username);
        data.setData("password", pass);
        data.setData(
            "phone",
            getIt<Auth>().myCountryDialCode +
                mobile.replaceAll(RegExp(r'^0+(?=.)'), ''));
        data.setData("lat", config.lat.toString());
        data.setData("long", config.long.toString());
        data.setData("address", address);
        res = true;
      } else {
        res = false;
      }
    });
    setBusy(false);
    return res;
  }

  void togelocationloading(bool state) {
    visibilityObs = state;
    notifyListeners();
  }

  Widget changechildforRegister(String login) {
    if (!busy) {
      return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
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
