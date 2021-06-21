import 'base_model.dart';

class FavoriteModle extends BaseModel {
  int favocurrentIndex = 0;
  bool _visible = true;
  bool __visible = false;
  bool get visible1 => _visible;
  bool get visible2 => __visible;
  void changeTabBarIndex(int id) {
    favocurrentIndex = id;
    _visible = !_visible;
    __visible = !__visible;
    notifyListeners();
  }
}
