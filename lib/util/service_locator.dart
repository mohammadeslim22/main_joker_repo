import 'package:get_it/get_it.dart';
import 'package:joker/providers/auth.dart';
import 'package:joker/providers/language.dart';
import 'package:joker/providers/home_modle.dart';
import 'package:joker/providers/map_provider.dart';
import 'package:joker/providers/salesProvider.dart';
import 'package:joker/services/navigationService.dart';
import 'package:joker/providers/merchantsProvider.dart';
import 'package:joker/ui/view_models/auth_view_models/change_password_modle.dart';
import 'package:joker/ui/view_models/auth_view_models/forget_passwords_modle.dart';
import 'package:joker/ui/view_models/auth_view_models/login_model.dart';
import 'package:joker/ui/view_models/fav_merchants_modle.dart';
import 'package:joker/ui/view_models/fav_sales_modle.dart';
import 'package:joker/ui/view_models/favorite_modle.dart';
import 'package:joker/ui/view_models/notifications_modle.dart';
import 'package:joker/ui/view_models/auth_view_models/pin_code_model.dart';
import 'package:joker/ui/view_models/auth_view_models/profile_model.dart';
import 'package:joker/ui/view_models/auth_view_models/profile_pin_code_model.dart';
import 'package:joker/ui/view_models/auth_view_models/registration_model.dart';
import 'package:joker/ui/view_models/auth_view_models/reset_password_model.dart';
import 'package:joker/ui/view_models/settings_modle.dart';
// import 'package:joker/providers/globalVars.dart';

GetIt getIt = GetIt.instance;
void setupLocator() {
  getIt.registerLazySingleton(() => NavigationService());
  getIt.registerLazySingleton(() => HomeModle());
  getIt.registerLazySingleton(() => HOMEMAProvider());
  getIt.registerLazySingleton(() => MerchantProvider());
  getIt.registerLazySingleton(() => SalesProvider());
  getIt.registerLazySingleton(() => RegistrationModel());
  getIt.registerLazySingleton(() => LoginModel());
  getIt.registerLazySingleton(() => Auth());
  getIt.registerLazySingleton(() => ProfileModle());
  getIt.registerLazySingleton(() => ChangePasswordModle());
  getIt.registerLazySingleton(() => ForgetPassModle());
  getIt.registerLazySingleton(() => NotificationsModel());
  getIt.registerLazySingleton(() => PinCodeModle());
  getIt.registerLazySingleton(() => PinCodeProfileModle());
  getIt.registerLazySingleton(() => ResetPasswordModle());
  getIt.registerLazySingleton(() => SettingsModle());
  getIt.registerLazySingleton(() => Language ());
  getIt.registerLazySingleton(() => FavoriteMerchantsModle ());
  getIt.registerLazySingleton(() => FavoriteSalesModle ());
  getIt.registerLazySingleton(() => FavoriteModle ());
  
}
