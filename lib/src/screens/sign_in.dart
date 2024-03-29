import 'package:flutter/material.dart';
import 'package:rx_command/rx_command.dart';

import 'package:afyamkononi/src/models/auth.dart';
import 'package:afyamkononi/src/screens/home/home.dart';
import 'package:afyamkononi/src/state/managers/auth_manager.dart';
import 'package:afyamkononi/src/utils/service_locator.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SignInParent(),
    );
  }
}

class SignInParent extends StatefulWidget {
  @override
  _SignInParentState createState() => _SignInParentState();
}

class _SignInParentState extends State<SignInParent> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  RxCommandListener _signInListener;
  RxCommandListener _authStatusListener;

  @override
  void initState() {
    super.initState();

    _signInListener = RxCommandListener(sl<AuthManager>().signInUser,
        onError: (error) => _onErrorSignIn(error));

    _authStatusListener = RxCommandListener(sl<AuthManager>().authStatus,
        onValue: (authStatusValue) {
      if (authStatusValue == AuthStatus.LOGGED_IN)
        _redirectToPage(context, Home());
    });
  }

  @override
  void dispose() {
    _signInListener?.dispose();
    _authStatusListener?.dispose();
    _emailController?.dispose();
    _passwordController?.dispose();
    super.dispose();
  }

  void _onErrorSignIn(dynamic error) {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text('${error.toString()}'),
          action: SnackBarAction(
            label: "Dismiss",
            onPressed: () {
              Scaffold.of(context).hideCurrentSnackBar();
            },
          ),
        ),
      ),
    );
  }

  void _redirectToPage(BuildContext context, Widget page) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      MaterialPageRoute newRoute = MaterialPageRoute(
        builder: (BuildContext context) => page,
      );

      Navigator.of(context).pushAndRemoveUntil(
        newRoute,
        ModalRoute.withName('/login'),
      );
    });
  }

  // Prevents the use of the "back" button
  Future<bool> _onWillPopScope() async {
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPopScope,
      child: StreamBuilder<CommandResult<SignInResult>>(
          stream: sl<AuthManager>().signInUser.results,
          builder: (context, snapshot) {
            final result = snapshot.data;

            if (result != null) {
              if (result.isExecuting)
                return Center(
                  child: CircularProgressIndicator(),
                );
              if (result.hasError) return buildPage();
            }

            return buildPage();
          }),
    );
  }

  Widget buildPage() {
    return SingleChildScrollView(
      padding: EdgeInsets.only(left: 16, right: 16, top: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 48),
            alignment: AlignmentDirectional.center,
            child: Text(
              'Login',
              style: TextStyle(
                fontSize: 48,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Divider(
            height: 32,
          ),
          Container(
            child: Form(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  StreamBuilder<String>(
                    stream: sl<AuthManager>().email,
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      return TextField(
                        controller: _emailController,
                        decoration: InputDecoration(
                            labelText: 'Email', errorText: snapshot.error),
                        onChanged: sl<AuthManager>().onEmailChanged,
                        keyboardType: TextInputType.emailAddress,
                      );
                    },
                  ),
                  StreamBuilder<String>(
                    stream: sl<AuthManager>().password,
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      return TextField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                            labelText: 'Password', errorText: snapshot.error),
                        onChanged: sl<AuthManager>().onPasswordChanged,
                        obscureText: true,
                      );
                    },
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 40),
                    child: SizedBox(
                      width: double.maxFinite,
                      height: 50,
                      child: FlatButton(
                        color: Colors.blue,
                        child: Text(
                          'Sign In',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                        onPressed: () {
                          final credentials = new Map();
                          credentials['email'] = _emailController.text;
                          credentials['password'] = _passwordController.text;

                          sl<AuthManager>().signInUser(credentials);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
