import 'package:flutter/material.dart';
import 'package:rx_command/rx_command.dart';

import 'package:afyamkononi/src/models/profile.dart';
import 'package:afyamkononi/src/state/managers/data_manager.dart';
import 'package:afyamkononi/src/utils/service_locator.dart';

class PatientProfile extends StatefulWidget {
  @override
  _PatientProfileState createState() => _PatientProfileState();
}

class _PatientProfileState extends State<PatientProfile> {
  @override
  void initState() {
    sl<DataManager>().patientProfile();
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
              'Patient Profile',
              style: TextStyle(
                fontSize: 32,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Divider(),
          StreamBuilder<CommandResult<UserProfile>>(
              stream: sl<DataManager>().patientProfile.results,
              builder: (context, snapshot) {
                final result = snapshot.data;
                if (result != null) {
                  if (result.isExecuting) return CircularProgressIndicator();
                  return _profileCard(result.data);
                }
                return CircularProgressIndicator();
              }),
        ],
      ),
    );
  }

  Widget _profileCard(UserProfile profile) {
    return Card(
      child: ListView(
        shrinkWrap: true,
        children: <Widget>[
          _tile('Creator Account', profile.creator),
          _tile('Name', profile.data.name),
          _tile('Email', profile.data.email),
          _tile('Phone Number', profile.data.phoneNumber),
          _tile('ID Number', profile.data.govId),
        ],
      ),
    );
  }

  Widget _tile(String _det, String _val) {
    return ListTile(
      leading: Icon(Icons.info),
      title: Text(_val),
      subtitle: Text(_det),
    );
  }
}
