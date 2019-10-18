import 'package:flutter/material.dart';

import 'package:afyamkononi/src/models/transactions.dart';
import 'package:afyamkononi/src/utils/misc.dart';

class Transaction extends StatefulWidget {
  final Transactions transaction;

  const Transaction({Key key, this.transaction}) : super(key: key);

  @override
  _TransactionState createState() => _TransactionState(transaction);
}

class _TransactionState extends State<Transaction> {
  final Transactions transaction;

  _TransactionState(this.transaction);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TransactionView(
        transaction: transaction,
      ),
    );
  }
}

class TransactionView extends StatefulWidget {
  final Transactions transaction;

  const TransactionView({Key key, this.transaction}) : super(key: key);

  @override
  _TransactionViewState createState() => _TransactionViewState(transaction);
}

class _TransactionViewState extends State<TransactionView> {
  final Transactions transaction;

  _TransactionViewState(this.transaction);

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(top: 48),
          alignment: AlignmentDirectional.center,
          child: Text(
            'Transaction Details',
            style: TextStyle(fontSize: 24),
            textAlign: TextAlign.center,
          ),
        ),
        Divider(),
        _card(transaction),
      ],
    );
  }

  Widget _card(Transactions entry) {
    return Card(
      child: Column(
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.info),
            title: Text('Action: ${entry.action}'),
            subtitle: Text('On: ${formatDate(entry.createdTime)}'),
          ),
          Divider(),
          ListTile(
            title: Text('Details'),
          ),
          _details(entry),
          ListTile(
            title: Text('Signatures'),
          ),
          _signatures(entry.signatures),
          ListTile(
            title: Text('Quorum: ${entry.quorum}'),
          )
        ],
      ),
    );
  }

  Widget _details(Transactions entry) {
    Widget widget;
    switch (entry.action) {
      case "grant_permission":
        widget = ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.green,
            child: Icon(Icons.check),
          ),
          title: Text('Granted: ${getPermission(entry.data.permission)}'),
          subtitle: Text('to: ${entry.data.accountId}'),
        );
        break;
      case "revoke_permission":
        widget = ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.red,
            child: Icon(Icons.cancel),
          ),
          title: Text('Revoked: ${getPermission(entry.data.permission)}'),
          subtitle: Text('which was given to: ${entry.data.accountId}'),
        );

        break;
      default:
        widget = ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.red,
            child: Icon(Icons.timer),
          ),
          title: Text('{entry.toString()}'),
        );
    }
    return widget;
  }

  Widget _signatures(dynamic signatures) {
    return ListView(
      shrinkWrap: true,
      children: signatures
          .map<Widget>((ent) => ListTile(
                title: Text('Public Key: ${ent.publicKey}'),
                subtitle: Text('Signature: ${ent.signature} '),
              ))
          .toList(),
    );
  }
}
