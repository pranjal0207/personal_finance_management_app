import 'Utils/DBHelper.dart';
import 'Utils/transaction.dart';
import 'transaction_form.dart';
import 'package:personal_finance_management_app/events/add_transactions.dart';
import 'package:personal_finance_management_app/events/delete_transactions.dart';
import 'package:personal_finance_management_app/events/transaction_event.dart';
import 'package:personal_finance_management_app/events/set_transactions.dart';
import 'package:personal_finance_management_app/events/update_transactions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/transaction_bloc.dart';

class TransactionList extends StatefulWidget {
  const TransactionList({Key key}) : super(key: key);

  @override
  _TransactionListState createState() => _TransactionListState();
}

class _TransactionListState extends State<TransactionList> {
  @override
  void initState() {
    super.initState();
    DatabaseProvider.db.gettransactions().then(
      (transactionList) {
        BlocProvider.of<TransactionBloc>(context).add(SetTransactions(transactionList));
      },
    );
  }

  showtransactionDialog(BuildContext context, OTransaction transaction, int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(transaction.name),
        content: Text("Amount Rs.${transaction.amount}"),
        actions: <Widget>[
          FlatButton(
            onPressed: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => TransactionForm(transaction: transaction, transactionIndex: index),
              ),
            ),
            child: Text("Update"),
          ),
          FlatButton(
            onPressed: () => DatabaseProvider.db.delete(transaction.id).then((_) {
              BlocProvider.of<TransactionBloc>(context).add(
                Deletetransaction(index),
              );
              Navigator.pop(context);
            }),
            child: Text("Delete"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    print("Building entire transaction list scaffold");
    return Scaffold(
      appBar: AppBar(title: Text("Ttansaction List")),
      body: Container(
        child: BlocConsumer<TransactionBloc, List<OTransaction>>(
          builder: (context, transactionList) {
            return ListView.separated(
              itemBuilder: (BuildContext context, int index) {
                print("Transaction List: $transactionList");

                OTransaction trans = transactionList[index];
                return ListTile(
                    title: Text(trans.name, style: TextStyle(fontSize: 30)),
                    subtitle: Text(
                      "Amount: Rs. ${trans.amount}",
                      style: TextStyle(fontSize: 20),
                    ),
                    onTap: () => showtransactionDialog(context, trans, index));
              },
              itemCount: transactionList.length,
              separatorBuilder: (BuildContext context, int index) => Divider(color: Colors.black),
            );
          },
          listener: (BuildContext context, transList) {},
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (BuildContext context) => TransactionForm()),
        ),
      ),
    );
  }
}