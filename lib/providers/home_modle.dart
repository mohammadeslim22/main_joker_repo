
import 'package:joker/ui/view_models/base_model.dart';


class HomeModle extends BaseModel {
  int _currentIndex = 0;
  
  int get bottomNavIndex => _currentIndex;

  void changebottomNavIndex(int id) {
    _currentIndex = id;
    notifyListeners();
  }


  bool darkthemeIson = false;
  void changeTheme(bool state) {
    darkthemeIson = state;
    notifyListeners();
  }

}
