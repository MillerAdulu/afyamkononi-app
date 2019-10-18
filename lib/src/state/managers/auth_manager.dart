import 'package:afyamkononi/src/state/services/shared_preferences_service.dart';
import 'package:rx_command/rx_command.dart';
import 'package:rxdart/subjects.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:afyamkononi/src/models/auth.dart';
import 'package:afyamkononi/src/state/services/api_service.dart';
import 'package:afyamkononi/src/utils/service_locator.dart';
import 'package:afyamkononi/src/utils/validators/email_validator.dart';
import 'package:afyamkononi/src/utils/validators/password_validator.dart';
import 'package:afyamkononi/src/utils/misc.dart';

abstract class AuthManager {
  RxCommand<AuthStatus, AuthStatus> authStatus;
  RxCommand<Map, SignInResult> signInUser;
  RxCommand<void, bool> signOutUser;
  RxCommand<void, bool> fetchSavedCredentials;
  RxCommand<SignInResult, void> saveCredentials;

  Function(String) get onEmailChanged;
  Stream<String> get email;
  Function(String) get onPasswordChanged;
  Stream<String> get password;
}

class AuthManagerInstance
    with EmailValidator, PasswordValidator, JWTToObject
    implements AuthManager {
  @override
  RxCommand<AuthStatus, AuthStatus> authStatus;

  @override
  RxCommand<Map, SignInResult> signInUser;

  @override
  RxCommand<void, bool> fetchSavedCredentials;

  @override
  RxCommand<SignInResult, void> saveCredentials;

  @override
  RxCommand<void, bool> signOutUser;

  AuthManagerInstance() {
    authStatus = RxCommand.createSync<AuthStatus, AuthStatus>(
        (authStatus) => authStatus);

    signInUser =
        RxCommand.createAsync<Map, SignInResult>(sl<APIService>().signInUser);

    // Return authentication status which can be used as the last result
    // to perform auth checks as opposed to making the API calls again
    signInUser.results
        .where((authResult) => authResult.data != null)
        .listen((authResult) {
      saveCredentials(authResult.data);
      authStatus(AuthStatus.LOGGED_IN);
    });

    saveCredentials =
        RxCommand.createAsyncNoResult<SignInResult>((signInResult) async {
      final accessToken = signInResult.accessToken;
      SharedPreferences _prefs = await SharedPreferences.getInstance();
      await _prefs.setString('accessToken', accessToken);

      final decClaimSet = parseJwt(accessToken);

      _prefs.setInt('userId', decClaimSet["id"]);
      _prefs.setString('govId', decClaimSet['govId']);
      _prefs.setString('name', decClaimSet['name']);
    });

    signOutUser = RxCommand.createAsyncNoParam<bool>(() async {
      await Future.delayed(Duration(seconds: 5));
      return Future.value(true);
    });

    // Return authentication status which can be used as the last result
    // to perform auth checks as opposed to making the API calls again
    signOutUser.results
        .where((authResult) => authResult.data != null)
        .listen((authResult) {
      authStatus(AuthStatus.LOGGED_OUT);
    });

    fetchSavedCredentials = RxCommand.createAsyncNoParam<bool>(() async {
      final token = await sl<SharedPreferencesService>().getAccessToken();
      final govId = await sl<SharedPreferencesService>().getGovId();

      if (token != null && govId != null && token != '' && govId != '')
        return Future.value(true);
      return Future.value(false);
    });
  }

  final PublishSubject<String> _emailController = PublishSubject<String>();
  Function(String) get onEmailChanged => _emailController.sink.add;
  Stream<String> get email => _emailController.stream.transform(validateEmail);

  final PublishSubject<String> _passwordController = PublishSubject<String>();
  Function(String) get onPasswordChanged => _passwordController.sink.add;
  Stream<String> get password =>
      _passwordController.stream.transform(validatePassword);

  void dispose() {
    _emailController?.close();
    _passwordController?.close();
  }
}
