import 'package:flutter/material.dart';
import 'package:joker/util/data.dart';
import 'package:joker/constants/config.dart';
import 'package:joker/util/dio.dart';

class Language with ChangeNotifier {
  Locale _language ;
  // = const Locale('en');

  Locale get currentLanguage => _language;

  Future<void> setLanguage(Locale language) async {
    const String arabicBaseUrl = "https://joker.altariq.ps/api/ar/v1/customer/";
    const String englishBaseUrl =
        "https://joker.altariq.ps/api/en/v1/customer/";
    const String turkishBaseUrl =
        "https://joker.altariq.ps/api/tr/v1/customer/";
    String baseUrl = await data.getData("baseUrl");
    if (baseUrl == "" || baseUrl.isEmpty || baseUrl == null) {
      baseUrl = config.baseUrl;
    }
    if (language.languageCode == "en") {
      dio.options.baseUrl = englishBaseUrl;
    } else if (language.languageCode == "ar") {
      dio.options.baseUrl = arabicBaseUrl;
    } else {
      dio.options.baseUrl = turkishBaseUrl;
    }
    await data.setData("baseUrl", dio.options.baseUrl);
    _language = language;
    await data.setData('ilang', language.languageCode);
    print(
        "tell me how many times language is accessed ? $_language  ${language.languageCode}");

    config.userLnag = language;
    notifyListeners();
  }
}
