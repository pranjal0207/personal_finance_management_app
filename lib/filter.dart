import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:personal_finance_management_app/utils/FirestoreHelper.dart';
import 'Utils/DBHelper.dart';
import 'Utils/transaction.dart';
import 'package:personal_finance_management_app/events/delete_transactions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/transaction_bloc.dart';
import 'package:intl/intl.dart';

class Filter extends StatefulWidget {
  const Filter({Key key}) : super(key: key);

  @override
  FilterState createState() => FilterState();
}

class FilterState extends State<Filter> {

  RangeValues values = RangeValues(1, 10000);
  RangeLabels labels = RangeLabels('1', '10000');
  TextEditingController datecontroller = new TextEditingController();
  


  DateTime _dateTime = DateTime.now();
  var date;

  QuerySnapshot fillist;
  final fs = OFirestoreService();

    void initState() {
      super.initState();
      fs.getData().then((result){
        setState(() {
          fillist = result; 
          print (fillist.docs[0].data()['name']);
        });
      });

      /*DatabaseProvider.db.gettransactions().then(
        (filterList) { 
          BlocProvider.of<TransactionBloc>(context).add(SetFilter(filterList));
        },
      );*/    
    }

  _transactionDate (BuildContext context) async{
    var pickdate = await showDatePicker(context: context, initialDate: _dateTime, firstDate: DateTime(2000), lastDate: _dateTime);

    if (pickdate!=null){
      setState(() {
        date =pickdate;

        datecontroller.text = DateFormat('dd-MM-yyyy').format(date);

      });
    }
  }

    showtransactionDialog(BuildContext context, OTransaction transaction, int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(transaction.name),
        content: Text("Amount ₹${transaction.amount} \nDate : .${transaction.date}"),
        actions: <Widget>[
          /*FlatButton(
            onPressed: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => TransactionForm(transaction: transaction, transactionIndex: index),
              ),
            ),
            child: Text("Update"),
          ),*/
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
    print("Building entire filter list scaffold");
    return Scaffold(
      appBar: AppBar(title : Text("Filters")),
      body : SafeArea( 
        child : Stack(
          children: <Widget>[
            Container(
              height: 100,
              margin: EdgeInsets.only(top : 20, left : 20),
              child: Text(
                "Amount",
                style: TextStyle(
                  fontSize: 20
                ),
              ),
            ),

            Container(
              height: 100,
              margin: EdgeInsets.only(top : 20),
              //color: Colors.grey,
              child: RangeSlider(
                        min : 1,
                        max : 10000,
                        divisions: 100,
                        values: values, 
                        labels: labels,
                        onChanged: (value) {
                          setState(() {
                            values = value;
                            labels = RangeLabels("₹ " + value.start.toInt().toString(), "Rs. " + value.end.toInt().toString());
                          });
                        }
                    ) 
            ),

            Container(
              margin: EdgeInsets.only(top : 70, left : 20, right : 20),
              child: TextFormField(
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
                },
              ),
            ),

            Container(
              margin : EdgeInsets.only(top : 145),
              alignment: Alignment.topCenter,
              child: 
                  RaisedButton(
                      onPressed: (){
                        fs.getFilter(values.start.toInt(),values.end.toInt() , datecontroller.text).then((result){
                          setState(() {
                            fillist = result; 
                            print (fillist.docs[0].data()['name']);
                          });
                        });
                      }, 
                      child: Text(
                        "Display Results",
                        style: TextStyle(
                          fontSize : 15,
                        ),
                      )
                  ),

                  /*RaisedButton(
                      onPressed: (){
                        setState(() {
                          values = RangeValues(1, 100000);
                          datecontroller.text = " ";
                        });
                        
                        DatabaseProvider.db.getfilters(values.start.toInt(), values.end.toInt(),  datecontroller.text).then(
                          (mine) { 
                            BlocProvider.of<TransactionBloc>(context).add(SetFilter(mine));
                            print(mine);
                          },

                        );
                      }, 
                      child: Text(
                        "Clear",
                        style: TextStyle(
                          fontSize : 15,
                        ),
                      )
                  ),*/

                
              
            ),

            Container(
                margin: EdgeInsets.only(top: 200, bottom: 0),
                child: BlocConsumer<TransactionBloc, List<OTransaction>>(
                builder: (context, filterlist) {
                return ListView.builder(
                    itemCount: fillist.docs.length,
                    itemBuilder: (context,i){
                    return Container( 
                      margin: EdgeInsets.only(left : 6, right : 6),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            bottomLeft : Radius.circular(10), 
                            bottomRight: Radius.circular(10),
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10)
                          ),
                          color: Colors.black12
                        ), 
                      child : new ListTile(
                      title: Text(fillist.docs[i].data()['name'], style: TextStyle(fontSize: 30)) ,
                      subtitle: Text("Amount : "+fillist.docs[i].data()['amount'].toString()+'\n'+"Date :"+fillist.docs[i].data()['date'], style: TextStyle(fontSize: 20)),
                      //onTap: () => showtransactionDialog(context, flist, i),
                    )) ; 
                  }
                );
                },
                listener: (BuildContext context, transList) {},
              ),
            ),
          ]
          )           
        ),
        );
  }
}