import 'package:afyamkononi/src/models/auth.dart';
import 'package:afyamkononi/src/models/consent.dart';
import 'package:afyamkononi/src/models/medical_data.dart';
import 'package:afyamkononi/src/models/profile.dart';
import 'package:afyamkononi/src/models/transactions.dart';
import 'package:afyamkononi/src/utils/http/network.dart';
import 'package:afyamkononi/src/utils/serializer/serializers.dart';

abstract class APIService {
  Future<dynamic> signInUser(Map credentials);
  Future<ConsentResult> fetchConsentRequests(String govId);
  Future<MedicalData> fetchPatientMedicalData(String govId);
  Future<TransactionData> fetchPatientTransactions(String govId);
  Future<UserProfile> fetchPatientProfile(String govId);
}

class APIServiceInstance implements APIService {
  NetworkUtil _networkUtil = new NetworkUtil();

  String _baseUrl = 'https://afyamkononi.herokuapp.com/api';

  @override
  Future<SignInResult> signInUser(Map credentials) async {
    final String signInUrl = '$_baseUrl/auth/sign_in';

    dynamic response = await _networkUtil.postReq(signInUrl, body: {
      'email': credentials['email'],
      'password': credentials['password']
    });

    if (response == null) return null;
    if (response['error'] == null)
      return serializers.deserializeWith(SignInResult.serializer, response);
    else
      throw Exception(response["error"]);
  }

  @override
  Future<ConsentResult> fetchConsentRequests(String govId) async {
    final String consentUrl = '$_baseUrl/consent/$govId';

    dynamic response = await _networkUtil.getReq(consentUrl);

    if (response == null) return null;
    if (response['error'] == null)
      return serializers.deserializeWith(ConsentResult.serializer, response);
    else
      throw Exception(response['error']);
  }

  @override
  Future<MedicalData> fetchPatientMedicalData(String govId) async {
    final String patientMedicalData = '$_baseUrl/records/$govId';
    dynamic response = await _networkUtil.getReq(patientMedicalData);

    if (response == null) return null;
    if (response['error'] == null)
      return serializers.deserializeWith(MedicalData.serializer, response);
    else
      throw Exception(response['error']);
  }

  @override
  Future<TransactionData> fetchPatientTransactions(String govId) async {
    final String patientTransactionsUrl = '$_baseUrl/transactions/$govId';
    dynamic response = await _networkUtil.getReq(patientTransactionsUrl);
    print(serializers.deserializeWith(TransactionData.serializer, response));

    if (response == null) return null;
    if (response['error'] == null)
      return serializers.deserializeWith(TransactionData.serializer, response);
    else
      throw Exception(response['error']);
  }

  @override
  Future<UserProfile> fetchPatientProfile(String govId) async {
    final String profileUrl = '$_baseUrl/accounts/gov_id/$govId';
    final response = await _networkUtil.getReq(profileUrl);

    if (response == null) return null;
    if (response['error'] == null)
      return serializers.deserializeWith(UserProfile.serializer, response);
    else
      throw Exception(response['error']);
  }
}
