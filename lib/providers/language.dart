import 'package:flutter/material.dart';
import 'package:joker/util/data.dart';
import 'package:joker/constants/config.dart';

class Language with ChangeNotifier {
  Locale _language;

  Locale get currentLanguage => _language;

 Future< void> setLanguage(Locale language)async  {
    _language = language;
    print("iam in lang provider and this is the lang code  ${language.languageCode}");
   await data.setData('lang', language.languageCode);
    
    config.userLnag = language;
    notifyListeners();
  }
}
