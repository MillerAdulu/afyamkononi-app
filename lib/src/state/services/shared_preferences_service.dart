import 'package:shared_preferences/shared_preferences.dart';

abstract class SharedPreferencesService {
  Future<int> getUserId();
  Future<String> getGovId();
  Future<String> getName();
  Future<String> getAccessToken();
  Future<void> clearSharedPrefs();
}

class SharedPreferencesInstance implements SharedPreferencesService {
  @override
  Future<int> getUserId() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    return _prefs.getInt('userId');
  }

  @override
  Future<String> getGovId() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    return _prefs.getString('govId');
  }

  @override
  Future<String> getName() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    return _prefs.getString('name');
  }

  @override
  Future<String> getAccessToken() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    return _prefs.getString('accessToken');
  }

  @override
  Future<void> clearSharedPrefs() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    _prefs.clear();
  }
}
