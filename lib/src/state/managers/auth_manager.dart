import 'package:jaguar_jwt/jaguar_jwt.dart';
import 'package:rx_command/rx_command.dart';
import 'package:rxdart/subjects.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:afyamkononi/src/models/auth.dart';
import 'package:afyamkononi/src/state/services/api_service.dart';
import 'package:afyamkononi/src/utils/service_locator.dart';
import 'package:afyamkononi/src/utils/validators/email_validator.dart';
import 'package:afyamkononi/src/utils/validators/password_validator.dart';

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
    with EmailValidator, PasswordValidator
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
      print("My ${authResult.data} is saved to local storage or database");
      saveCredentials(authResult.data);
      authStatus(AuthStatus.LOGGED_IN);
    });

    saveCredentials =
        RxCommand.createAsyncNoResult<SignInResult>((signInResult) async {
      final accessToken = signInResult.accessToken;
      SharedPreferences _prefs = await SharedPreferences.getInstance();
      await _prefs.setString('accessToken', accessToken);
      
      final JwtClaim decClaimSet = verifyJwtHS256Signature(
          accessToken, r'qajv^vwA9a2R@F0[$3~3;/O2d"W::H');
      print("Set: $decClaimSet");
      _prefs.setInt('userId', decClaimSet.payload["id"]);
      _prefs.setString('govId', decClaimSet.payload['govId']);
      _prefs.setString('name', decClaimSet.payload['name']);
      print("Muhahahahahaha!!!");
    });

    signOutUser = RxCommand.createAsyncNoParam<bool>(() {
      Future.delayed(Duration(seconds: 5));
      return Future.value(true);
    });

    // Return authentication status which can be used as the last result
    // to perform auth checks as opposed to making the API calls again
    signOutUser.results
        .where((authResult) => authResult.data != null)
        .listen((authResult) {
      print("Successfully logged out");
      authStatus(AuthStatus.LOGGED_OUT);
    });

    fetchSavedCredentials = RxCommand.createAsyncNoParam<bool>(() async {
      print("Fetching credentials");
      await Future.delayed(Duration(seconds: 3));
      print("Finished fetching");
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
