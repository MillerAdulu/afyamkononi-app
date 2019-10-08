import 'package:afyamkononi/src/models/auth.dart';
import 'package:afyamkononi/src/utils/http/network.dart';
import 'package:afyamkononi/src/utils/serializer/serializers.dart';

abstract class APIService {
  Future<dynamic> signInUser(Map credentials);
}

class APIServiceInstance implements APIService {
  NetworkUtil _networkUtil = new NetworkUtil();

  String baseUrl = 'https://afyamkononi.herokuapp.com/api';

  @override
  Future<SignInResult> signInUser(Map credentials) async {
    final String signInUrl = '$baseUrl/auth/sign_in';

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
}
