import 'package:afyamkononi/src/models/medical_data.dart';
import 'package:afyamkononi/src/models/profile.dart';
import 'package:afyamkononi/src/models/transactions.dart';
import 'package:afyamkononi/src/state/services/api_service.dart';
import 'package:afyamkononi/src/state/services/shared_preferences_service.dart';
import 'package:afyamkononi/src/utils/service_locator.dart';
import 'package:rx_command/rx_command.dart';

import 'package:afyamkononi/src/models/consent.dart';

abstract class DataManager {
  RxCommand<void, ConsentResult> consentInfo;
  RxCommand<void, MedicalData> patientMedicalData;
  RxCommand<void, TransactionData> patientTransactions;
  RxCommand<void, UserProfile> patientProfile;
}

class DataManagerInstance implements DataManager {
  @override
  RxCommand<void, ConsentResult> consentInfo;

  @override
  RxCommand<void, MedicalData> patientMedicalData;

  @override
  RxCommand<void, TransactionData> patientTransactions;

  @override
  RxCommand<void, UserProfile> patientProfile;

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
        RxCommand.createAsyncNoParam<TransactionData>(() async {
      final govId = await sl<SharedPreferencesService>().getGovId();
      return await sl<APIService>().fetchPatientTransactions(govId);
    });

    patientProfile = RxCommand.createAsyncNoParam<UserProfile>(() async {
      final govId = await sl<SharedPreferencesService>().getGovId();
      return await sl<APIService>().fetchPatientProfile(govId);
    });
  }
}
