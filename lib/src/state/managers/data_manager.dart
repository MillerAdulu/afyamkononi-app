import 'package:afyamkononi/src/state/services/api_service.dart';
import 'package:afyamkononi/src/utils/service_locator.dart';
import 'package:rx_command/rx_command.dart';

import 'package:afyamkononi/src/models/consent.dart';

abstract class DataManager {
  RxCommand<String, ConsentResult> consentInfo;
}

class DataManagerInstance implements DataManager {
  @override
  RxCommand<String, ConsentResult> consentInfo;

  DataManagerInstance() {
    consentInfo = RxCommand.createAsync(sl<APIService>().fetchConsentRequests);
  }
}
