import 'package:get_it/get_it.dart';

import 'package:afyamkononi/src/state/managers/auth_manager.dart';
import 'package:afyamkononi/src/state/services/api_service.dart';

GetIt sl = GetIt.instance;

void setUpServiceLocator() {
  // Services
  sl.registerLazySingleton<APIService>(() => APIServiceInstance());

  // Managers
  sl.registerLazySingleton<AuthManager>(() => AuthManagerInstance());
}
