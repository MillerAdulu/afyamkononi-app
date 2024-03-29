import 'package:rx_command/rx_command.dart';

import 'package:afyamkononi/src/models/consent.dart';
import 'package:afyamkononi/src/models/medical_data.dart';
import 'package:afyamkononi/src/models/profile.dart';
import 'package:afyamkononi/src/models/transactions.dart';
import 'package:afyamkononi/src/state/services/api_service.dart';
import 'package:afyamkononi/src/state/services/shared_preferences_service.dart';
import 'package:afyamkononi/src/utils/service_locator.dart';

abstract class DataManager {
  RxCommand<void, ConsentResult> consentInfo;
  RxCommand<void, MedicalData> patientMedicalData;
  RxCommand<void, TransactionParent> patientTransactions;
  RxCommand<void, UserProfile> patientProfile;
  RxCommand<ConsentResults, String> revokePermission;
  RxCommand<ConsentResults, String> grantPermission;
  RxCommand<String, String> messageUser;
}

class DataManagerInstance implements DataManager {
  @override
  RxCommand<void, ConsentResult> consentInfo;

  @override
  RxCommand<void, MedicalData> patientMedicalData;

  @override
  RxCommand<void, TransactionParent> patientTransactions;

  @override
  RxCommand<void, UserProfile> patientProfile;

  @override
  RxCommand<ConsentResults, String> revokePermission;

  @override
  RxCommand<ConsentResults, String> grantPermission;

  @override
  RxCommand<String, String> messageUser;

  DataManagerInstance() {
    consentInfo = RxCommand.createAsyncNoParam<ConsentResult>(() async {
      final govId = await sl<SharedPreferencesService>().getGovId();
      return await sl<APIService>().fetchConsentRequests(govId);
    });

    patientMedicalData = RxCommand.createAsyncNoParam<MedicalData>(() async {
      final govId = await sl<SharedPreferencesService>().getGovId();
      return await sl<APIService>().fetchPatientMedicalData(govId);
    });

    patientTransactions =
        RxCommand.createAsyncNoParam<TransactionParent>(() async {
      final govId = await sl<SharedPreferencesService>().getGovId();
      return await sl<APIService>().fetchPatientTransactions(govId);
    });

    patientProfile = RxCommand.createAsyncNoParam<UserProfile>(() async {
      final govId = await sl<SharedPreferencesService>().getGovId();
      return await sl<APIService>().fetchPatientProfile(govId);
    });

    revokePermission =
        RxCommand.createAsync<ConsentResults, String>((consent) async {
      return await sl<APIService>()
          .revokePermission(consent.grantorId, consent.requestorId);
    });

    revokePermission.results
        .where((revokeRes) => revokeRes.data != null)
        .listen((revokeRes) {
      messageUser(revokeRes.data);
      consentInfo();
    });

    grantPermission =
        RxCommand.createAsync<ConsentResults, String>((consent) async {
      return await sl<APIService>()
          .grantPermission(consent.grantorId, consent.requestorId);
    });

    grantPermission.results
        .where((grantRes) => grantRes.data != null)
        .listen((grantRes) {
      messageUser(grantRes.data);
      consentInfo();
    });

    messageUser = RxCommand.createSync<String, String>((message) => message);
  }
}
