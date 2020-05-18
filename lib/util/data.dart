import 'package:shared_preferences/shared_preferences.dart';

class Data {
  
  Future<String> getData(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
    
  }

  Future<bool> setData(String key, String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(key, value);
  }
}

final Data data = Data();