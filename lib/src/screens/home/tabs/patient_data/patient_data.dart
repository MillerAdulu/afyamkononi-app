import 'package:afyamkononi/src/screens/home/tabs/patient_data/medical_entry.dart';
import 'package:flutter/material.dart';
import 'package:rx_command/rx_command.dart';

import 'package:afyamkononi/src/models/medical_data.dart';
import 'package:afyamkononi/src/state/managers/data_manager.dart';
import 'package:afyamkononi/src/utils/service_locator.dart';
import 'package:afyamkononi/src/utils/timestamp_to_date.dart';

class PatientData extends StatefulWidget {
  @override
  _PatientDataState createState() => _PatientDataState();
}

class _PatientDataState extends State<PatientData> {
  @override
  void initState() {
    sl<DataManager>().patientMedicalData();
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
            'Medical Data',
            style: TextStyle(
              fontSize: 32,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        Divider(),
        StreamBuilder<CommandResult<MedicalData>>(
          stream: sl<DataManager>().patientMedicalData.results,
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
                  return _medicalDataCard(entry, index);
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

  Widget _medicalDataCard(entry, index) {
    return ListTile(
      key: Key('$index'),
      leading: CircleAvatar(
        backgroundColor: Colors.green,
        child: Icon(Icons.check),
      ),
      title: Text("On ${formatDate(entry.timestamp)},"),
      subtitle: Text("${entry.seenBy} saw you."),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MedicalEntry(
              medicalentry: entry,
            ),
          ),
        );
      },
    );
  }
}
