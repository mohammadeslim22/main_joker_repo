import 'package:get_it/get_it.dart';
import 'package:joker/providers/auth.dart';
import 'package:joker/providers/mainprovider.dart';
import 'package:joker/providers/map_provider.dart';
import 'package:joker/providers/salesProvider.dart';
import 'package:joker/services/navigationService.dart';
import 'package:joker/providers/merchantsProvider.dart';
import 'package:joker/providers/location_provider.dart';
// import 'package:joker/providers/globalVars.dart';

GetIt getIt = GetIt.instance;
void setupLocator() {
  getIt.registerLazySingleton(() => NavigationService());
  getIt.registerLazySingleton(() => MainProvider());
  getIt.registerLazySingleton(() => HOMEMAProvider());
  getIt.registerLazySingleton(() => MerchantProvider());
  getIt.registerLazySingleton(() => SalesProvider());
  getIt.registerLazySingleton(() => Auth());
  getIt.registerLazySingleton(() => LocationProvider());
  // getIt.registerLazySingleton(() => GlobalVars());
  
}
