import 'package:intl/intl.dart';

import 'Utils/DBHelper.dart';
import 'Utils/transaction.dart';
import 'package:personal_finance_management_app/events/add_transactions.dart';
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
  var datecontroller = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  DateTime _dateTime = DateTime.now();
  var date;

  _transactionDate (BuildContext context) async{
    var pickdate = await showDatePicker(context: context, initialDate: _dateTime, firstDate: DateTime(2000), lastDate: _dateTime);

    if (pickdate!=null){
      setState(() {
        date =pickdate;

        datecontroller.text = DateFormat('dd-MM-yyyy').format(date);

      });
    }
  }

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

  Widget _buildAmount() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Amount'),
      keyboardType: TextInputType.number,
      style: TextStyle(fontSize: 28),
      validator: (String value) {
        int calories = int.tryParse(value);

        if (calories == null || calories == 0) {
          return 'Amount must be greater than 0';
        }

        return null;
      },
      onSaved: (String value) {
        _amount = int.parse(value);
      },
    );
  }

  Widget _builddate(BuildContext context) {
    return TextFormField(
      controller: datecontroller,
      decoration: InputDecoration(
        labelText: 'Date',
        prefixIcon: InkWell(
          onTap : (){
            _transactionDate(context);
          print(_dateTime);
          },
          child: Icon(Icons.calendar_today),
        )
      ),
      style: TextStyle(fontSize: 28),
      validator: (String value) {
        return null;
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
              _buildAmount(),
              _builddate(context),
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
                          amount: _amount,
                          date : datecontroller.text
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