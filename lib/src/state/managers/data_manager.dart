import 'package:afyamkononi/src/state/services/api_service.dart';
import 'package:afyamkononi/src/state/services/shared_preferences_service.dart';
import 'package:afyamkononi/src/utils/service_locator.dart';
import 'package:rx_command/rx_command.dart';

import 'package:afyamkononi/src/models/consent.dart';

abstract class DataManager {
  RxCommand<void, ConsentResult> consentInfo;
}

class DataManagerInstance implements DataManager {
  @override
  RxCommand<void, ConsentResult> consentInfo;

  DataManagerInstance() {
    consentInfo = RxCommand.createAsyncNoParam(() async {
      final govId = await sl<SharedPreferencesService>().getGovId();

      return await sl<APIService>().fetchConsentRequests(govId);
    });
  }
}
