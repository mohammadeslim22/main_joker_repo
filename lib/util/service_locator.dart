import 'package:get_it/get_it.dart';
import 'package:joker/providers/auth.dart';
import 'package:joker/providers/map_provider.dart';
import 'package:joker/services/navigationService.dart';
import 'package:joker/providers/merchantsProvider.dart';

GetIt getIt = GetIt.instance;
void setupLocator() {
getIt.registerLazySingleton(() => NavigationService());
getIt.registerLazySingleton(() => HOMEMAProvider());
getIt.registerLazySingleton(() => MerchantProvider());
getIt.registerLazySingleton(() => Auth());

}