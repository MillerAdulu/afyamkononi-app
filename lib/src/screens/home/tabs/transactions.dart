import 'package:flutter/material.dart';
import 'package:rx_command/rx_command.dart';

import 'package:afyamkononi/src/models/transactions.dart';
import 'package:afyamkononi/src/state/managers/data_manager.dart';
import 'package:afyamkononi/src/utils/service_locator.dart';
import 'package:afyamkononi/src/utils/timestamp_to_date.dart';

class PatientTransactions extends StatefulWidget {
  @override
  _PatientTransactionsState createState() => _PatientTransactionsState();
}

class _PatientTransactionsState extends State<PatientTransactions> {
  @override
  void initState() {
    sl<DataManager>().patientTransactions();
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
              'Your Transactions',
              style: TextStyle(
                fontSize: 32,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Divider(),
          StreamBuilder<CommandResult<TransactionParent>>(
            stream: sl<DataManager>().patientTransactions.results,
            builder: (context, snapshot) {
              final result = snapshot.data;
              if (result != null) {
                if (result.isExecuting) return CircularProgressIndicator();
                return Flexible(
                    child: ListView.builder(
                  primary: true,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    final entry = result
                        .data.data.transactionsPageResponse.transactions[index];
                    return _transactionCard(entry, index);
                  },
                  itemCount: result
                      .data.data.transactionsPageResponse.transactions.length,
                ));
              }
              return CircularProgressIndicator();
            },
          )
        ],
      ),
    );
  }

  Widget _transactionCard(entry, index) {
    return ListTile(
      key: Key('$index'),
      leading: CircleAvatar(
        backgroundColor: Colors.green,
        child: Icon(Icons.check),
      ),
      title: Text("On ${formatDate(entry.createdTime)},"),
      subtitle: Text("${entry.creatorAccountId} performed ${entry.action}"),
      trailing: Icon(Icons.touch_app),
    );
  }
}
