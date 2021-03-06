import 'package:flutter/cupertino.dart';
import 'package:geocoder/geocoder.dart';

class Config {
  factory Config() {
    return _config;
  }

  Config._internal();

  static final Config _config = Config._internal();
  String imageUrl = "http://joker.localhost.ps/web/image/";

  String baseUrl = "http://joker.localhost.ps/web/api/en/v1/customer/";

  String onesignal = "63367f9c-9d70-4ae8-9290-17ad17e2efd5"; // ca9a
  String qRCodeUrl = "https://www.space.co.ps/joker/ar/qr-code/";
  String registerURL = "https://www.space.co.ps/joker/en/registermerchant";
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
  String profileUrl =
      "https://png.pngtree.com/png-clipart/20190924/original/pngtree-businessman-user-avatar-free-vector-png-image_4827807.jpg";
  String username;
  bool amIcomingFromHome = false;
  bool prifleNoVerfiyVisit = false;
  bool prifleNoVerfiyDone = false;
}

final Config config = Config();
