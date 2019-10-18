import 'package:flutter/material.dart';

import 'package:afyamkononi/src/models/medical_data.dart';

class MedicalEntry extends StatefulWidget {
  final MedicalRecords medicalentry;

  const MedicalEntry({Key key, this.medicalentry}) : super(key: key);

  @override
  _MedicalEntryState createState() => _MedicalEntryState(medicalentry);
}

class _MedicalEntryState extends State<MedicalEntry> {
  final MedicalRecords medicalentry;

  _MedicalEntryState(this.medicalentry);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MedicalEntryView(
        medicalentry: medicalentry,
      ),
    );
  }
}

class MedicalEntryView extends StatefulWidget {
  final MedicalRecords medicalentry;

  const MedicalEntryView({Key key, this.medicalentry}) : super(key: key);

  @override
  _MedicalEntryViewState createState() => _MedicalEntryViewState(medicalentry);
}

class _MedicalEntryViewState extends State<MedicalEntryView> {
  final MedicalRecords medicalentry;

  _MedicalEntryViewState(this.medicalentry);


  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: double.maxFinite,
        child: ListView(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 48),
              alignment: AlignmentDirectional.center,
              child: Text(
                'Session Information',
                style: TextStyle(
                  fontSize: 24,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Divider(),
            _tile('Added By', medicalentry.author),
            _tile('Symptoms', medicalentry.symptoms),
            _tile('Diagnosis', medicalentry.diagnosis),
            _tile('Treatment Plan', medicalentry.treatmentPlan),
            _tile('Seen By', medicalentry.seenBy),
          ],
        ),
      ),
    );
  }

  Widget _tile(String _title, String _detail) {
    return ListTile(
      title: Text(_detail),
      subtitle: Text(_title),
      trailing: Icon(Icons.check),
    );
  }

  
}
