import 'package:flutter/material.dart';
import 'package:rx_command/rx_command.dart';

import 'package:afyamkononi/src/models/consent.dart';
import 'package:afyamkononi/src/state/managers/data_manager.dart';
import 'package:afyamkononi/src/utils/service_locator.dart';

class PatientPermissions extends StatefulWidget {
  @override
  _PatientPermissionsState createState() => _PatientPermissionsState();
}

class _PatientPermissionsState extends State<PatientPermissions> {
  @override
  void initState() {
    sl<DataManager>().consentInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(top: 48),
          alignment: AlignmentDirectional.center,
          child: Text(
            'Permission Requests',
            style: TextStyle(
              fontSize: 32,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        Divider(),
        StreamBuilder<CommandResult<ConsentResult>>(
          stream: sl<DataManager>().consentInfo.results,
          builder: (context, snapshot) {
            final result = snapshot.data;
            if (result != null) {
              if (result.isExecuting) return CircularProgressIndicator();
              return Flexible(
                  child: ListView.builder(
                primary: true,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  final entry = result.data.data[index];
                  return _permissionsCard(entry, index);
                },
                itemCount: result.data.data.length,
              ));
            }
            return CircularProgressIndicator();
          },
        )
      ],
    ));
  }

  Widget _permissionsCard(entry, index) {
    return ListTile(
      key: Key('$index'),
      leading: _returnAvatar(entry.status),
      title: Text(entry.requestorName),
      subtitle: Text('wants ${entry.permission} abilities.'),
    );
  }

  Widget _returnAvatar(String status) {
    Widget widget;
    switch (status) {
      case "pending":
        widget = CircleAvatar(
          backgroundColor: Colors.pinkAccent,
          child: Icon(Icons.timer),
        );
        break;
      case "revoked":
        widget = CircleAvatar(
          backgroundColor: Colors.red,
          child: Icon(Icons.cancel),
        );
        break;
      case "granted":
        widget = CircleAvatar(
          backgroundColor: Colors.green,
          child: Icon(Icons.check),
        );
        break;
      default:
        widget = CircleAvatar(
          backgroundColor: Colors.grey,
        );
    }

    return widget;
  }
}
