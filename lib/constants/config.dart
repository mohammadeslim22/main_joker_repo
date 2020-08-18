import 'package:flutter/cupertino.dart';
import 'package:geocoder/geocoder.dart';

class Config {
  factory Config() {
    return _config;
  }

  Config._internal();

  static final Config _config = Config._internal();

  String baseUrl = "http://space.co.ps/joker/api/ar/v1/customer/";

  // TODO(fahjan): api key for onesignal push notifications
  String onesignal = "bc4208c6-1-48c0-b4d5-390029a340dc"; // ca9a
  String qRCodeUrl = "https://www.space.co.ps/joker/ar/qr-code/";
  // default country code prefix mobile number
  String countryCode = '+970';

  final TextEditingController locationController = TextEditingController();
  bool loggedin = true;
  Locale userLnag;
  Address first;
  Coordinates coordinates;
  List<Address> addresses;
  double lat = 0.0;
  double long = 0.0;
  String token = "";
  String profileUrl = "";
  String username;
  bool amIcomingFromHome = false;
  bool prifleNoVerfiyVisit = false;
  bool prifleNoVerfiyDone = false;
}

final Config config = Config();
