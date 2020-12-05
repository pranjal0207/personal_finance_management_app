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


class TransactionForm extends StatefulWidget {
  final   OTransaction transaction;
  final int transactionIndex;

  TransactionForm({this.transaction, this.transactionIndex});

  @override
  State<StatefulWidget> createState() {
    return TransactionFormState();
  }
}

class TransactionFormState extends State<TransactionForm> {
  String _name;
  int _amount;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Widget _buildName() {
    return TextFormField(
      initialValue: _name,
      decoration: InputDecoration(labelText: 'Name'),
      maxLength: 15,
      style: TextStyle(fontSize: 28),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Name is Required';
        }

        return null;
      },
      onSaved: (String value) {
        _name = value;
      },
    );
  }

  Widget _buildCalories() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Amount'),
      keyboardType: TextInputType.number,
      style: TextStyle(fontSize: 28),
      validator: (String value) {
        int calories = int.tryParse(value);

        if (calories == null || calories <= 0) {
          return 'Amount must be greater than 0';
        }

        return null;
      },
      onSaved: (String value) {
        _amount = int.parse(value);
      },
    );
  }

  @override
  void initState() {
    super.initState();
    if (widget.transaction != null) {
      _name = widget.transaction.name;
      _amount = widget.transaction.amount;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("transaction Form")),
      body: Container(
        margin: EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _buildName(),
              _buildCalories(),
              SizedBox(height: 16),

              SizedBox(height: 20),
              widget.transaction == null
                  ? RaisedButton(
                      child: Text(
                        'Submit',
                        style: TextStyle(color: Colors.blue, fontSize: 16),
                      ),
                      onPressed: () {
                        if (!_formKey.currentState.validate()) {
                          return;
                        }

                        _formKey.currentState.save();

                        OTransaction trans = OTransaction(
                          name: _name,
                          amount: _amount
                        );

                        DatabaseProvider.db.insert(trans).then(
                              (storedtransaction) => BlocProvider.of<TransactionBloc>(context).add(
                                Addtransaction(storedtransaction),
                              ),
                            );

                        Navigator.pop(context);
                      },
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        RaisedButton(
                          child: Text(
                            "Update",
                            style: TextStyle(color: Colors.blue, fontSize: 16),
                          ),
                          onPressed: () {
                            if (!_formKey.currentState.validate()) {
                              print("form");
                              return;
                            }

                            _formKey.currentState.save();

                            OTransaction transaction = OTransaction(
                              name: _name,
                              amount: _amount,
                            );

                            DatabaseProvider.db.update(widget.transaction).then(
                                  (storedtransaction) => BlocProvider.of<TransactionBloc>(context).add(
                                    Updatetransaction(widget.transactionIndex, transaction),
                                  ),
                                );

                            Navigator.pop(context);
                          },
                        ),
                        RaisedButton(
                          child: Text(
                            "Cancel",
                            style: TextStyle(color: Colors.red, fontSize: 16),
                          ),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }
}