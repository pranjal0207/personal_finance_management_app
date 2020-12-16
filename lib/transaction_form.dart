import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:intl/intl.dart';
import 'Utils/DBHelper.dart';
import 'Utils/transaction.dart';
import 'package:personal_finance_management_app/events/update_transactions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/transaction_bloc.dart';


class TransactionForm extends StatefulWidget {
  final OTransaction transaction;
  final int transactionIndex;
  final double budget;
  final double sum;
  final double miscsum;
  final double misc;

  TransactionForm({this.transaction, this.transactionIndex, this.budget, this.sum, this.miscsum, this.misc});

  @override
  State<StatefulWidget> createState() {
    return TransactionFormState();
  }
}

class TransactionFormState extends State<TransactionForm> {
  String _name;
  int _amount;
  int budget;
  int sum;
  int miscsum;
  int misc;
  var datecontroller = TextEditingController();
  final List<String> items = <String>[ 'Food', 'Clothing', 'Daily Needs', 'Miscellaneous'];
  String selectedItem = "Category";

  //TransactionFormState (this.budget, this.sum, this.miscsum, this.misc);

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

  shownotiDialog1 (BuildContext context){
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title : Text("Warning"),
        content: Text("You have exhausted your budget for the month."),
        actions: <Widget>[
          FlatButton(
            onPressed: (){
              Navigator.pop(context);
            }, 
            child: Text("Okay")
          )
        ],
      )
    );
  }

  shownotiDialog2 (BuildContext context){
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title : Text("Warning"),
        content: Text("You have exhausted 90% of your budget for the month. Spend wisely!"),
        actions: <Widget>[
          FlatButton(
            onPressed: (){
              Navigator.pop(context);
            }, 
            child: Text("Okay")
          )
        ],
      )
    );
  }

  shownotiDialog3 (BuildContext context){
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title : Text("Warning"),
        content: Text("You have exhausted your Miscellaneous budget for the month. Spend wisely!"),
        actions: <Widget>[
          FlatButton(
            onPressed: (){
              Navigator.pop(context);
            }, 
            child: Text("Okay")
          )
        ],
      )
    );
  }

  Widget _buildName() {
    return TextFormField(
      initialValue: _name,
      decoration: InputDecoration(
        labelText: 'Name',
        prefixIcon: InkWell(
          child : Icon(Icons.person) ,
        ),
      ),
      //maxLength: 15,
      style: TextStyle(fontSize: 20),
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
      decoration: InputDecoration(
        labelText: 'Amount',
        prefixIcon: InkWell(
          child : Icon(Icons.attach_money) ,
        ),  
      ),
      keyboardType: TextInputType.number,
      style: TextStyle(fontSize: 20),
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
      readOnly: true,
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
      style: TextStyle(fontSize: 20),
      validator: (String value) {
        
        return null;
      }
    );
  }

  Widget _buildcategories(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical : 10.0),
      child: DropdownButton<String>(
        //value: selectedItem,
        hint: Text ('Category'),
        onChanged: (String string) => setState(() => selectedItem = string),
        selectedItemBuilder: (BuildContext context) {
          return items.map<Widget>((String item) {
            return Text(item);
          }).toList();
        },
        items: items.map((String item) {
          return DropdownMenuItem<String>(
            child: Text('$item'),
            value: item,
          );
        }).toList(),
      
      ),
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
      appBar: AppBar(title: Text("Transaction Form")),
      body: Container(
        margin: EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              _buildName(),
              _buildAmount(),
              _builddate(context),
              SizedBox(height : 20),
              _buildcategories(context),
              //SizedBox(height: 5),

              //SizedBox(height: 5),
              widget.transaction == null
                  ? RaisedButton(
                      padding: EdgeInsets.only(top : 0),
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
                          amount : _amount,
                          date : datecontroller.text,
                          category : selectedItem
                        );

                        /*DatabaseProvider.db.insert(trans).then(
                              (storedtransaction) => BlocProvider.of<TransactionBloc>(context).add(
                                Addtransaction(storedtransaction),
                              ),
                            );*/


                            /*print (widget.sum.toString());
                            if (widget.sum >= widget.budget){
                              shownotiDialog1(context);
                            }

                            if (widget.sum >= (0.9*widget.budget) && widget.sum < widget.budget){
                              shownotiDialog2(context);
                            }

                            if (widget.miscsum >= widget.misc){
                              shownotiDialog3(context);
                            }*/

                        print (selectedItem);
                        Firebase.initializeApp();
                        CollectionReference collectionReference = FirebaseFirestore.instance.collection('records');
                        collectionReference.add(trans.toMap());
                                                
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