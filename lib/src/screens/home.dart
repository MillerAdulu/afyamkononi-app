import 'package:flutter/material.dart';
import 'package:rx_command/rx_command.dart';

import 'package:afyamkononi/src/screens/decision.dart';
import 'package:afyamkononi/src/state/managers/auth_manager.dart';
import 'package:afyamkononi/src/utils/service_locator.dart';

import 'package:afyamkononi/src/screens/tabs/permissions.dart';
import 'package:afyamkononi/src/screens/tabs/profile.dart';
import 'package:afyamkononi/src/screens/tabs/transactions.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: HomeParent(),
    );
  }
}

class HomeParent extends StatefulWidget {
  @override
  _HomeParentState createState() => _HomeParentState();
}

class _HomeParentState extends State<HomeParent> {
  RxCommandListener _userLogout;
  int _currentIndex = 0;

  final List<Widget> _children = [
    PatientProfile(),
    PatientPermissions(),
    PatientTransactions()
  ];

  @override
  void initState() {
    super.initState();

    _userLogout = RxCommandListener(sl<AuthManager>().signOutUser,
        onValue: (_) => _onValueSignOut(),
        onError: (error) => _onErrorSignOut(error));
  }

  @override
  void dispose() {
    _userLogout?.dispose();
    super.dispose();
  }

  void _onValueSignOut() {
    Future.delayed(Duration.zero, () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => DecisionPage(),
        ),
      );
    });
  }

  void _onErrorSignOut(dynamic error) {
    WidgetsBinding.instance
        .addPostFrameCallback((_) => Scaffold.of(context).showSnackBar(SnackBar(
              content: Text('${error.toString()}'),
            )));
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<CommandResult<bool>>(
      stream: sl<AuthManager>().signOutUser.results,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        final result = snapshot.data;

        if (result != null) {
          if (result.isExecuting)
            return Center(
              child: CircularProgressIndicator(),
            );

          if (result.hasError) return _buildPage();
        }

        return _buildPage();
      },
    );
  }

  Widget _buildPage() {
    return Scaffold(
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        items: <BottomNavigationBarItem>[
          // Patient Profile Tab
          BottomNavigationBarItem(
              icon: Icon(Icons.account_circle), title: Text('My Profile')),
          // Confidential Records Permissions
          BottomNavigationBarItem(
              icon: Icon(Icons.edit), title: Text('Permissions')),
          // Transactions List
          BottomNavigationBarItem(
              icon: Icon(Icons.list), title: Text('My Transactions'))
        ],
      ),
    );
  }

  void onTabTapped(int _index) {
    setState(() {
      _currentIndex = _index;
    });
  }

  void signOut() async {
    sl<AuthManager>().signOutUser();
  }
}
