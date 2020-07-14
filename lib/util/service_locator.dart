import 'package:get_it/get_it.dart';
import 'package:joker/providers/map_provider.dart';
import 'package:joker/services/navigationService.dart';

GetIt getIt = GetIt.instance;
void setupLocator() {
getIt.registerLazySingleton(() => NavigationService());
getIt.registerLazySingleton(() => HOMEMAProvider());

}