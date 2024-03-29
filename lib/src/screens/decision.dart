import 'package:flutter/material.dart';
import 'package:rx_command/rx_command.dart';

import 'package:afyamkononi/src/screens/home/home.dart';
import 'package:afyamkononi/src/screens/sign_in.dart';
import 'package:afyamkononi/src/state/managers/auth_manager.dart';
import 'package:afyamkononi/src/utils/service_locator.dart';

class DecisionPage extends StatefulWidget {
  @override
  _DecisionPageState createState() => _DecisionPageState();
}

class _DecisionPageState extends State<DecisionPage> {
  @override
  void initState() {
    super.initState();

    sl<AuthManager>().fetchSavedCredentials();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<CommandResult<bool>>(
        stream: sl<AuthManager>().fetchSavedCredentials.results,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          final result = snapshot.data;

          if (result != null) {
            if (result?.data == true) _redirectToPage(context, Home());

            if (result?.data == null || result?.data == false)
              _redirectToPage(context, SignIn());
          }

          return Scaffold(
            body: Center(
              child: Text('Initializing ...'),
            ),
          );
        });
  }

  void _redirectToPage(BuildContext context, Widget page) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      MaterialPageRoute newRoute =
          MaterialPageRoute(builder: (BuildContext contenxt) => page);

      Navigator.of(context)
          .pushAndRemoveUntil(newRoute, ModalRoute.withName('/decision'));
    });
  }
}
