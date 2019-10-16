import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import 'package:afyamkononi/src/state/services/shared_preferences_service.dart';
import 'package:afyamkononi/src/utils/service_locator.dart';

class NetworkUtil {
  static NetworkUtil _networkUtil = new NetworkUtil.internal();
  NetworkUtil.internal();
  factory NetworkUtil() => _networkUtil;

  Future<dynamic> getReq(String url) async {
    final basicHeaders = await setBasicHeaders();
    http.Response response = await http.get(url, headers: {
      ...basicHeaders,
    });

    final String responseBody = response.body;

    if (responseBody.isEmpty) return null;

    return json.decode(responseBody);
  }

  Future<dynamic> postReq(String url, {Map body, encoding}) async {
    final basicHeaders = await setBasicHeaders();
    http.Response response = await http.post(url,
        headers: {
          ...basicHeaders,
        },
        body: body,
        encoding: encoding);

    final String responseBody = response.body;

    if (responseBody.isEmpty) return null;

    return json.decode(responseBody);
  }

  Future<dynamic> putReq(String url, {Map body, encoding}) async {
    final basicHeaders = await setBasicHeaders();
    http.Response response = await http.put(url,
        headers: {
          ...basicHeaders,
        },
        body: body,
        encoding: encoding);

    final String responseBody = response.body;

    if (responseBody.isEmpty) return null;

    return json.decode(responseBody);
  }

  Future<dynamic> patchReq(String url, {Map body, encoding}) async {
    final basicHeaders = await setBasicHeaders();
    http.Response response = await http.patch(url,
        headers: {
          ...basicHeaders,
        },
        body: body,
        encoding: encoding);

    final String responseBody = response.body;

    if (responseBody.isEmpty) return null;

    return json.decode(responseBody);
  }

  Future<dynamic> deleteReq(String url) async {
    final basicHeaders = await setBasicHeaders();
    http.Response response = await http.delete(url, headers: {
      ...basicHeaders,
    });

    final String responseBody = response.body;

    if (responseBody.isEmpty) return null;

    return json.decode(responseBody);
  }

  Future<dynamic> setBasicHeaders() async {
    String bearerToken = await getBearerToken();
    return {
      HttpHeaders.contentTypeHeader: 'application/x-www-form-urlencoded',
      HttpHeaders.acceptHeader: 'application/json',
      HttpHeaders.authorizationHeader: 'Bearer $bearerToken',
    };
  }

  Future<String> getBearerToken() async {
    return await sl<SharedPreferencesService>().getAccessToken();
  }
}
