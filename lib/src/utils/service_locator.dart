import 'package:get_it/get_it.dart';

import 'package:afyamkononi/src/state/managers/auth_manager.dart';
import 'package:afyamkononi/src/state/managers/data_manager.dart';

import 'package:afyamkononi/src/state/services/api_service.dart';
import 'package:afyamkononi/src/state/services/shared_preferences_service.dart';

GetIt sl = GetIt.instance;

void setUpServiceLocator() {
  // Services
  sl.registerLazySingleton<APIService>(() => APIServiceInstance());
  sl.registerLazySingleton<SharedPreferencesService>(
      () => SharedPreferencesInstance());

  // Managers
  sl.registerLazySingleton<AuthManager>(() => AuthManagerInstance());
  sl.registerLazySingleton<DataManager>(() => DataManagerInstance());
}
