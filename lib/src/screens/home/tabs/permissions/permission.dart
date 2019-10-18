import 'package:flutter/material.dart';
import 'package:rx_command/rx_command.dart';
import 'package:rx_command/rx_command_listener.dart';

import 'package:afyamkononi/src/state/managers/data_manager.dart';
import 'package:afyamkononi/src/utils/service_locator.dart';
import 'package:afyamkononi/src/models/consent.dart';

class Permission extends StatefulWidget {
  final ConsentResults consent;

  const Permission({Key key, this.consent}) : super(key: key);

  @override
  _PermissionState createState() => _PermissionState(consent);
}

class _PermissionState extends State<Permission> {
  final ConsentResults consent;

  _PermissionState(this.consent);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PermissionView(
        consent: consent,
      ),
    );
  }
}

class PermissionView extends StatefulWidget {
  final ConsentResults consent;

  const PermissionView({Key key, this.consent}) : super(key: key);

  @override
  _PermissionViewState createState() => _PermissionViewState(consent);
}

class _PermissionViewState extends State<PermissionView> {
  final ConsentResults consent;

  _PermissionViewState(this.consent);

  RxCommandListener _revokeListener, _grantListener, _messageListener;

  @override
  void initState() {
    super.initState();

    _revokeListener = RxCommandListener(sl<DataManager>().revokePermission,
        onError: (error) => _messageUser(error));
    _grantListener = RxCommandListener(sl<DataManager>().grantPermission,
        onError: (error) => _messageUser(error));
    _messageListener = RxCommandListener(sl<DataManager>().messageUser,
        onValue: (message) => _messageUser(message));
  }

  @override
  void dispose() {
    _revokeListener?.dispose();
    _grantListener?.dispose();
    _messageListener?.dispose();
    super.dispose();
  }

  void _messageUser(dynamic message) {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text('${message.toString()}'),
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

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.maxFinite,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Text('Requestor ID: ${consent.requestorId}'),
          Text('Requestor Name: ${consent.requestorName}'),
          Text('Grantor ID: ${consent.grantorId}'),
          Text('Grantor Name: ${consent.grantorName}'),
          Text('Permission: ${consent.permission}'),
          Text('Status: ${consent.status}'),
          Text('Created At: ${consent.createdAt}'),
          Text('Updated At: ${consent.updatedAt}'),
          _actionButton(consent),
        ],
      ),
    );
  }

  Widget _actionButton(consent) {
    Widget widget;
    switch (consent.status) {
      case "granted":
        widget = StreamBuilder<CommandResult<String>>(
          stream: sl<DataManager>().revokePermission.results,
          builder: (context, snapshot) {
            final result = snapshot.data;
            if (result != null) {
              if (result.isExecuting) return CircularProgressIndicator();
              if (result.data != null) return _actionButton(consent);
            }
            return FlatButton(
              child: Text('Revoke'),
              onPressed: () {
                sl<DataManager>().revokePermission(consent);
              },
            );
          },
        );

        break;
      default:
        widget = StreamBuilder<CommandResult<String>>(
          stream: sl<DataManager>().grantPermission.results,
          builder: (context, snapshot) {
            final result = snapshot.data;
            if (result != null) {
              if (result.isExecuting) return CircularProgressIndicator();
              if (result.data != null) return _actionButton(consent);
            }
            return FlatButton(
              child: Text('Grant'),
              onPressed: () {
                sl<DataManager>().grantPermission(consent);
              },
            );
          },
        );
    }

    return widget;
  }
}
