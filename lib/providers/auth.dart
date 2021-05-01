import 'dart:async';
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
  String myCountryDialCode = "+90";
  String dialCodeFav = "TR";
  String errorMessage;
  String username = "username";
  String userPicture =
      "https://png.pngtree.com/png-clipart/20190924/original/pngtree-businessman-user-avatar-free-vector-png-image_4827807.jpg";

  int unredNotifications = 0;
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
  void getCountry(String countryCode) {
    // await CountryCodes.init();
    // print("dialCodeFav $myCountryDialCode $dialCodeFav");
    // final CountryDetails details =
    //     CountryCodes.detailsForLocale(Locale(dialCodeFav, dialCodeFav));
    // myCountryDialCode = details.dialCode;
    myCountryDialCode = countriesDialCodes[dialCodeFav];
    print("myCountryDialCode $myCountryDialCode $dialCodeFav");
    notifyListeners();
    // print("numricCode:    ${result.callingCodes}");
  }

  void setnotificationdCount(int count) {
    unredNotifications = count;
    notifyListeners();
  }

  Future<void> getNotificationsCount() async {
    // TODO(isleem): the application stops at split(" ")[1])
    print(dio.options.headers['authorization'].toString().split(" ")[1]);
    final Response<dynamic> res = await dio.get<dynamic>("notif_count",
        queryParameters: <String, String>{
          "token": dio.options.headers['authorization'].toString().split(" ")[1]
        });
    if (res.data.toString() == "unauthinicated") {
    } else {
      setnotificationdCount(int.parse(res.data.toString()));
    }
    print("Notification count in splash ${res.data}");
    //
  }

  void minnotificationdCount1() {
    unredNotifications--;
    notifyListeners();
  }

  void changeUsername(String name) {
    username = name;
    notifyListeners();
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
          data.setData("username", value.data['data']['name'].toString());
          data.setData("profile_pic", value.data['data']['image'].toString());
          config.profileUrl = value.data['data']['image'].toString();
          setUserPicture(value.data['data']['image'].toString());
          print("unredNotifications ${value.data['data']['unread_count']}");
          unredNotifications = value.data['data']['unread_count'] as int;
          notifyListeners();
          print("auth header ======= ${value.data['data']['api_token']}");
          dio.options.headers['authorization'] =
              'Bearer ${value.data['data']['api_token']}';
          print("dio header ======= ${dio.options.headers['authorization']}");
          await data.setData(
              "authorization", "Bearer ${value.data['data']['api_token']}");
          config.username = value.data['data']['name'].toString();
          changeUsername(value.data['data']['name'].toString());
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

  void setUserPicture(String pic) {
    userPicture = pic;
    notifyListeners();
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
    // await auth.getCountry(platformVersion);
    // try {
    //   final String platformVersion = await FlutterSimCountryCode.simCountryCode;
    //   print("platform country code : $platformVersion");
    //   dialCodeFav = platformVersion;
    //   Fluttertoast.showToast(msg: platformVersion);
    //   // auth.setDialCodee(platformVersion);
    //   await getCountry(platformVersion);
    // } on PlatformException {
    //   print('Failed to get platform version.');
    // }
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

  Map<String, String> countriesDialCodes = <String, String>{
    "AF": "+93",
    "AX": "+358",
    "AL": "+355",
    "DZ": "+213",
    "AS": "+1684",
    "AD": "+376",
    "AO": "+244",
    "AI": "+1264",
    "AQ": "+672",
    "AG": "+1268",
    "AR": "+54",
    "AM": "+374",
    "AW": "+297",
    "AU": "+61",
    "AT": "+43",
    "AZ": "+994",
    "BS": "+1242",
    "BH": "+973",
    "BD": "+880",
    "BB": "+1246",
    "BY": "+375",
    "BE": "+32",
    "BZ": "+501",
    "BJ": "+229",
    "BM": "+1441",
    "BT": "+975",
    "BO": "+591",
    "BA": "+387",
    "BW": "+267",
    "BV": "+47",
    "BR": "+55",
    "IO": "+246",
    "BN": "+673",
    "BG": "+359",
    "BF": "+226",
    "BI": "+257",
    "KH": "+855",
    "CM": "+237",
    "CA": "+1",
    "CV": "+238",
    "KY": "+1345",
    "CF": "+236",
    "TD": "+235",
    "CL": "+56",
    "CN": "+86",
    "CX": "+61",
    "CC": "+61",
    "CO": "+57",
    "KM": "+269",
    "CG": "+242",
    "CD": "+243",
    "CK": "+682",
    "CR": "+506",
    "CI": "+225",
    "HR": "+385",
    "CU": "+53",
    "CY": "+357",
    "CZ": "+420",
    "DK": "+45",
    "DJ": "+253",
    "DM": "+1767",
    "DO": "+1",
    "EC": "+593",
    "EG": "+20",
    "SV": "+503",
    "GQ": "+240",
    "ER": "+291",
    "EE": "+372",
    "ET": "+251",
    "FK": "+500",
    "FO": "+298",
    "FJ": "+679",
    "FI": "+358",
    "FR": "+33",
    "GF": "+594",
    "PF": "+689",
    "TF": "+262",
    "GA": "+241",
    "GM": "+220",
    "GE": "+995",
    "DE": "+49",
    "GH": "+233",
    "GI": "+350",
    "GR": "+30",
    "GL": "+299",
    "GD": "+1473",
    "GP": "+590",
    "GU": "+1671",
    "GT": "+502",
    "GG": "+44",
    "GN": "+224",
    "GW": "+245",
    "GY": "+592",
    "HT": "+509",
    "HM": "+0",
    "VA": "+379",
    "HN": "+504",
    "HK": "+852",
    "HU": "+36",
    "IS": "+354",
    "IN": "+91",
    "ID": "+62",
    "IR": "+98",
    "IQ": "+964",
    "IE": "+353",
    "IM": "+44",
    "IL": "+972",
    "IT": "+39",
    "JM": "+1876",
    "JP": "+81",
    "JE": "+44",
    "JO": "+962",
    "KZ": "+7",
    "KE": "+254",
    "KI": "+686",
    "KP": "+850",
    "KR": "+82",
    "XK": "+383",
    "KW": "+965",
    "KG": "+996",
    "LA": "+856",
    "LV": "+371",
    "LB": "+961",
    "LS": "+266",
    "LR": "+231",
    "LY": "+218",
    "LI": "+423",
    "LT": "+370",
    "LU": "+352",
    "MO": "+853",
    "MK": "+389",
    "MG": "+261",
    "MW": "+265",
    "MY": "+60",
    "MV": "+960",
    "ML": "+223",
    "MT": "+356",
    "MH": "+692",
    "MQ": "+596",
    "MR": "+222",
    "MU": "+230",
    "YT": "+262",
    "MX": "+52",
    "FM": "+691",
    "MD": "+373",
    "MC": "+377",
    "MN": "+976",
    "ME": "+382",
    "MS": "+1664",
    "MA": "+212",
    "MZ": "+258",
    "MM": "+95",
    "dial_code": "+264",
    "NA": "+674",
    "NP": "+977",
    "NL": "+31",
    "AN": "+599",
    "NC": "+687",
    "NZ": "+64",
    "NE": "+227",
    "NG": "+234",
    "NU": "+683",
    "NF": "+672",
    "MP": "+1670",
    "NO": "+47",
    "OM": "+968",
    "PK": "+92",
    "PW": "+680",
    "PS": "+970",
    "PA": "+507",
    "PG": "+675",
    "PY": "+595",
    "PE": "+51",
    "PH": "+63",
    "PN": "+64",
    "PL": "+48",
    "PT": "+351",
    "PR": "+1939",
    "QA": "+974",
    "RO": "+40",
    "RU": "+7",
    "RW": "+250",
    "RE": "+262",
    "BL": "+590",
    "SH": "+290",
    "KN": "+1869",
    "LC": "+1758",
    "MF": "+590",
    "PM": "+508",
    "VC": "+1784",
    "WS": "+685",
    "SM": "+378",
    "ST": "+239",
    "SA": "+966",
    "SN": "+221",
    "RS": "+381",
    "SC": "+248",
    "SL": "+232",
    "SG": "+65",
    "SK": "+421",
    "SI": "+386",
    "SB": "+677",
    "SO": "+252",
    "ZA": "+27",
    "SS": "+211",
    "GS": "+500",
    "ES": "+34",
    "LK": "+94",
    "SD": "+249",
    "SR": "+597",
    "SJ": "+47",
    "SZ": "+268",
    "SE": "+46",
    "CH": "+41",
    "SY": "+963",
    "TW": "+886",
    "TJ": "+992",
    "TZ": "+255",
    "TH": "+66",
    "TL": "+670",
    "TG": "+228",
    "TK": "+690",
    "TO": "+676",
    "TT": "+1868",
    "TN": "+216",
    "TR": "+90",
    "TM": "+993",
    "TC": "+1649",
    "TV": "+688",
    "UG": "+256",
    "UA": "+380",
    "AE": "+971",
    "GB": "+44",
    "US": "+1",
    "UY": "+598",
    "UZ": "+998",
    "VU": "+678",
    "VE": "+58",
    "VN": "+84",
    "VG": "+1284",
    "VI": "+1340",
    "WF": "+681",
    "YE": "+967",
    "ZM": "+260",
    "ZW": "+263"
  };
}
