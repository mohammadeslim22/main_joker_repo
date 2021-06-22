import 'package:joker/ui/view_models/fav_merchants_modle.dart';
import 'package:joker/ui/view_models/fav_sales_modle.dart';
import 'package:joker/util/service_locator.dart';

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

  FavoriteSalesModle favSalesModle = getIt<FavoriteSalesModle>();
  FavoriteMerchantsModle favMerchantssModle = getIt<FavoriteMerchantsModle>();
}
