import 'Utils/DBHelper.dart';
import 'Utils/transaction.dart';
import 'transaction_form.dart';
import 'package:personal_finance_management_app/events/delete_transactions.dart';
import 'package:personal_finance_management_app/events/set_transactions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/transaction_bloc.dart';

class TransactionList extends StatefulWidget {
  const TransactionList({Key key}) : super(key: key);

  @override
  _TransactionListState createState() => _TransactionListState();
}

class _TransactionListState extends State<TransactionList> {
  
  int sum;

  @override
  void initState() {
    sum = 0;
    super.initState();
    DatabaseProvider.db.gettransactions().then(
      (transactionList) { 
        BlocProvider.of<TransactionBloc>(context).add(SetTransactions(transactionList));
      },
    );
  }

  var temp;
  void _calcTotal() async{

    var total = (await DatabaseProvider.db.calculateTotal());
    print("njfsfj");
    print(total);
    if (total == null) {
      sum = 0;
      return;
    }
    setState(() => sum = total);

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
      
      body : SafeArea( 
        child : Container(
          child: Stack(
            children :  <Widget>[
              Container(  
                margin: EdgeInsets.only(bottom: 450),
                height: 450,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft : Radius.circular(20), 
                    bottomRight: Radius.circular(30),
                  ),
                  color : Colors.blue,
                   
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(sum.toString()),
                  ],
                ),
              ),

              Container(

              ),

              Container(
                margin: EdgeInsets.only(top: 250, bottom: 0),
                child: BlocConsumer<TransactionBloc, List<OTransaction>>(
                builder: (context, transactionList) {
                return ListView.separated(
                  padding: EdgeInsets.only(top: 0),

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

            
          ]
          )           
        ),
      ),
       
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.grey,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.home), title: Text('Home')),
          BottomNavigationBarItem(
              icon: Icon(Icons.add), title: Text('ADD')),
          BottomNavigationBarItem(
              icon: Icon(Icons.filter_list), title: Text('Filters')),
        ],
        currentIndex: selectedIndex,
        fixedColor: Colors.deepPurple,
        onTap: (index)  {
            setState((){
              selectedIndex = index;
              if (selectedIndex == 1){
                Navigator.push(context,MaterialPageRoute(builder: (BuildContext context) => TransactionForm()));
                selectedIndex = 0;
              }

              if (selectedIndex == 2)
                print ("hello world");

              if (selectedIndex == 0)
                _calcTotal();
            });
          }
      ),
    );
  }
}