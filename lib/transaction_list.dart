import 'package:flutter/foundation.dart';
import 'Utils/DBHelper.dart';
import 'Utils/transaction.dart';
import 'transaction_form.dart';
import 'package:personal_finance_management_app/events/delete_transactions.dart';
import 'package:personal_finance_management_app/events/set_transactions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/transaction_bloc.dart';
import 'filter.dart';
import 'stats.dart';
import 'settings.dart';

class TransactionList extends StatefulWidget {
  const TransactionList({Key key}) : super(key: key);

  @override
  _TransactionListState createState() => _TransactionListState();
}

class _TransactionListState extends State<TransactionList> {
  
  int sum;
  double budget = 30000.0;
  double percent = 0;
  String name = "User";
  String curmonth = "temp";
  List months = ['January','February','March','April','May','June','July','August','September','October','November','December'];
  var controller1 = new TextEditingController();
  var controller2 = new TextEditingController();

  @override
  void initState() {
    sum = 0;
    super.initState();
    DatabaseProvider.db.gettransactions().then(
      (transactionList) { 
        BlocProvider.of<TransactionBloc>(context).add(SetTransactions(transactionList));
      },
    );
    int cur = DateTime.now().month;
    curmonth = months[cur-1];
    
  }

  var temp;
  void _calcTotal() async{
    var total = (await DatabaseProvider.db.calculateTotal());
    print("njfsfj");
    print(total);
    if (total == null) {
      sum = 0;
      percent = ((budget - sum)/budget);
      print (percent);
      //int cur = DateTime.now().month;
      //print  (months[cur-1]);
      //curmonth = months[cur-1];
      return;
    }

    percent = ((budget - sum)/budget);
    print (percent);  
    /*int cur = DateTime.now().month;
    print  (months[cur-1]);*/

    setState(() {
      sum = total;
      percent = percent;
      //curmonth = months[cur+1];
    });  
}

  int selectedIndex = 0;
  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  final widgetOptions = [
    Text("Home"),
    Text("Filter")
  ];

  showtransactionDialog(BuildContext context, OTransaction transaction, int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(transaction.name),
        content: Text("Amount Rs.${transaction.amount} \nDate : .${transaction.date}"),
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

  showsettingDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context){
        return AlertDialog(
          title: Text("Settings"),
          content : Stack(children: <Widget>[
            Container(
              margin: EdgeInsets.only(top :0),
              child: TextFormField(
              controller: controller1,
              //initialValue: name,
              decoration: InputDecoration(labelText: 'Name'),
              maxLength: 15,
              style: TextStyle(fontSize: 20),
              validator: (String value) {
                if (value.isEmpty) {
                  return 'Name is Required';
                }

                return null;
              }
            ),

            ),

            Container(
              margin: EdgeInsets.only(top : 65),
              child: TextFormField(
              controller: controller2,
              //initialValue: budget.toString(),
              decoration: InputDecoration(labelText: 'Budget'),
              maxLength: 15,
              style: TextStyle(fontSize: 20),
              validator: (String value) {
                int calories = int.tryParse(value);

                if (calories == null || calories == 0) {
                  return 'Amount must be greater than 0';
                }
                return null;
              },
              )
            ),  
    
            Container(
              margin: EdgeInsets.only(top : 140),
              child: FlatButton(
            onPressed: (){
                setState(() {
                  name = controller1.text;
                  budget = double.parse(controller2.text);
                  Navigator.pop(context);
                });                 
            }, 
            child: Text("Save")
            ),)
           
          ]
          ) 
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    print("Building entire transaction list scaffold");
    return Scaffold(
      
      body : SafeArea( 
        child : Container(
          child: Stack(
            children :  <Widget>[
              Container(  
                margin: EdgeInsets.only(bottom: 460),
                height: 450,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft : Radius.circular(30), 
                    bottomRight: Radius.circular(30),
                  ),
                  color : Colors.blue,
                ),           
              ),

              Container(
                height:  25,
                margin: EdgeInsets.only(top : 20, left : 17),
                child: Row(
                  
                  children : [
                    Text (
                      "Hello " + name + "!",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 25
                      ),
                    ),

                    
                  ]
                  ),
                ),

              Container(
                child : FlatButton(
                      padding: EdgeInsets.only(top : 20, left : 350),
                      onPressed : () => Navigator.push(context,MaterialPageRoute(builder: (BuildContext context) => Settings())) ,
                      child: Icon(
                          Icons.settings,
                          color : Colors.white,
                        )
                      )
              ),

              Container(
                height: 25,
                margin: EdgeInsets.only(top :55, left: 17),
                child: Text(
                  curmonth,                  
                  style : TextStyle(
                    color : Colors.white,
                    fontSize: 20
                  )
                )
              ),

              Container(
                height: 30,
                margin: EdgeInsets.only(top : 121, left: 17),
                child: Text(
                  '₹ ',
                  style : TextStyle(
                    color : Colors.white,
                    fontSize: 27
                  )
                )
              ),

              Container(
                height: 50,
                margin: EdgeInsets.only (top : 105, left : 40),
                child: Text(
                  (sum).toString(),
                  style: TextStyle(
                    color : Colors.white,
                    fontSize: 45
                  ),
                ),
              ),


              Container(
                height : 30,
                margin: EdgeInsets.only(top : 165, left: 20),
                child: Column(
                  children: [

                  Container(
                    margin: EdgeInsets.only(right: 80),
                    child: LinearProgressIndicator(
                    value : (percent),
                    backgroundColor: Colors.white,
                    valueColor: AlwaysStoppedAnimation(Colors.yellow),
                  ),
                  ),

                  

                  
                  ],
                ),
              ),

              Container(
                margin: EdgeInsets.only(top : 158, left : 340),
                child: Text(
                    ((budget-sum) / budget * 100).toStringAsFixed(0) + "%",
                    style: TextStyle(
                      color: Colors.white,
                    ),), 
              ),

              Container(
                margin: EdgeInsets.only (left :  17, top : 178),
                child : Text(
                  "Remaining Budget : ₹ "+ (budget-sum).toStringAsFixed(0),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                )
              ),

              Container(
                margin: EdgeInsets.only(top: 260, bottom: 0),
                child: BlocConsumer<TransactionBloc, List<OTransaction>>(
                builder: (context, transactionList) {
                return ListView.separated(
                  padding: EdgeInsets.only(top: 0),

                  itemBuilder: (BuildContext context, int index) {
                    print("Transaction List: $transactionList");

                    OTransaction trans = transactionList[index];
                    
                    return (
                      
                      Container(
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
                        child : 
                        ListTile(
                          title: Text(trans.name, style: TextStyle(fontSize: 30)),
                          subtitle: Text(
                          "₹ ${trans.amount} \nDate : ${trans.date}",
                            style: TextStyle(
                              fontSize: 20),
                          ),
                          onTap: () => showtransactionDialog(context, trans, index)),
                      )
                    );
                  },
                  itemCount: transactionList.length,
                  separatorBuilder: (BuildContext context, int index) => Divider(color: Colors.black),
                  );
                },
                listener: (BuildContext context, transList) {},
              ),
            ),
          ]
          )           
        ),
      ),
       
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.blue,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.home), title: Text('Home')),
          BottomNavigationBarItem(
              icon: Icon(Icons.add), title: Text('Add')),
          BottomNavigationBarItem(
              icon: Icon(Icons.equalizer), title: Text('Stats')),
          BottomNavigationBarItem(
              icon: Icon(Icons.filter_list), title: Text('Filters')),
        ],
        currentIndex: selectedIndex,
        unselectedItemColor: Colors.white,
        fixedColor: Colors.yellow,
        onTap: (index)  {
            setState((){
              selectedIndex = index;
              if (selectedIndex == 1){
                Navigator.push(context,MaterialPageRoute(builder: (BuildContext context) => TransactionForm()));
                selectedIndex = 0;
              }
              if (selectedIndex == 2)
                Navigator.push(context,MaterialPageRoute(builder: (BuildContext context) => Stats()));
              if (selectedIndex == 3)
                Navigator.push(context,MaterialPageRoute(builder: (BuildContext context) => Filter()));
              if (selectedIndex == 0){
                  _calcTotal();
                  //initState();    
              }
            });
          }
      ),
    );
  }
}