import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
//import 'Utils/DBHelper.dart';
import 'Utils/transaction.dart';
import 'transaction_form.dart';
//import 'package:personal_finance_management_app/events/delete_transactions.dart';
//import 'package:personal_finance_management_app/events/set_transactions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/transaction_bloc.dart';
import 'filter.dart';
import 'utils/FirestoreHelper.dart';
import 'stats.dart';
import 'settings.dart';

class TransactionList extends StatefulWidget {
  const TransactionList({Key key}) : super(key: key);

  @override
  _TransactionListState createState() => _TransactionListState();
}

class _TransactionListState extends State<TransactionList> {
  
  var result;
  double sum;
  double budget = 30000.0;
  double misc = 10000.0;
  double percent = 0;
  String name = "user";
  String curmonth = "temp";
  List months = ['January','February','March','April','May','June','July','August','September','October','November','December'];
  var controller1 = new TextEditingController();
  var controller2 = new TextEditingController();
  QuerySnapshot flist;
  final fs = OFirestoreService();
  double miscsum = 0;
  double tempmisc = 0;

  @override
  void initState() {
    sum = 0;
    super.initState();
    
      miscsum = 0;
      fs.getData().then((result){
        setState(() {
          flist = result; 
          print (flist.docs[0].data()['name']);
        });
      });

      /*name = result[0];
      budget = double.parse(result[1].toString());
      misc = double.parse(result[2].toString());*/

      print (name); 
      print (budget.toString());
    /*DatabaseProvider.db.gettransactions().then(
      (transactionList) { 
        BlocProvider.of<TransactionBloc>(context).add(SetTransactions(transactionList));
      },
    );*/

    int cur = DateTime.now().month;
    curmonth = months[cur-1]; 
  }

  var temp;
  void _calcTotal() async{
    double total = 0;
    //print("njfsfj");
    int flag = 0;
    tempmisc = 0;

    for (int i = 0; i < flist.docs.length; i++){
      total = total +  flist.docs[i].data()['amount'];

      if (flist.docs[i].data()['category'] == 'Miscellaneous'){
        tempmisc = tempmisc + flist.docs[i].data()['amount'];
        print ("loop" + flist.docs[i].data()['amount'].toString());
        flag =1;
      }
    }

    if (flag == 0 ){
      tempmisc = 0;
    }
    
    print(total);
    /*if (total == null) {
      sum = ;
      percent = ((budget - sum)/budget);
      print (percent);
      //int cur = DateTime.now().month;
      //print  (months[cur-1]);
      //curmonth = months[cur-1];
      return;
    }*/

    percent = ((budget - sum)/budget);
    print (percent);  
    /*int cur = DateTime.now().month;
    print  (months[cur-1]);*/

    setState(() {
      sum = total;
      percent = percent;
      miscsum = tempmisc;
      print ("calc miscsum = " +miscsum.toString());
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
  

  showtransactionDialog(BuildContext context, QuerySnapshot flist, var i) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(flist.docs[i].data()['name']),
        content: Text("Amount Rs.${flist.docs[i].data()['amount']} \nDate : .${flist.docs[i].data()['date']}"),
        actions: <Widget>[
          /*FlatButton(
            onPressed: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => TransactionForm(transaction: flist.docs[i], transactionIndex: i),
              ),
            ),
            child: Text("Update"),
          ),*/
         FlatButton(
            onPressed: (){
              fs.deletedata(flist.docs[i].id);
              print (flist.docs[i].id);
              Navigator.pop(context);
            },
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
                height:  33,
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
                margin: EdgeInsets.only(top : 10, left : 305),
                width: 50,
                child : FlatButton(
                      onPressed : () { 
                       fs.getData().then((result){
                          setState(() {
                            flist = result; 
                            _calcTotal();

                            print(miscsum.toString());

                            if (sum >= budget){
                              shownotiDialog1(context);
                            }

                            if (sum >= (0.9*budget) && sum < budget){
                              shownotiDialog2(context);
                            }

                            if (miscsum >= misc){
                              print("miscsum = "+miscsum.toString());
                              print("misc = "+misc.toString());
                              shownotiDialog3(context);
                            }
                          });
                        });
                      },
                      child: Icon(
                          Icons.refresh,
                          color : Colors.blue,
                      )
                )

              ),

              Container(
                margin: EdgeInsets.only(top : 10, left : 350),
                width: 50 ,
                child : FlatButton(
                      onPressed : () async{ 
                        final result = await Navigator.push(context,MaterialPageRoute(builder: (BuildContext context) => OSettings()));
                        print(result);
                        setState(() {
                          name = result[0];
                          budget = double.parse(result[1].toString());
                          misc = double.parse(result[2].toString());
                          print(name + ""+ budget.toString() + "" + misc.toString());
                        });
                      },
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
                  (sum).toStringAsFixed(0),
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
                margin: EdgeInsets.only(top : 158, left : 350),
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
                margin: EdgeInsets.only(top: 240, bottom: 0),
                child: BlocConsumer<TransactionBloc, List<OTransaction>>(
                builder: (context, transactionList) {
                  return ListView.builder(
                    itemCount: flist.docs.length,
                    itemBuilder: (context,i){
                    return Container( 
                      //padding: EdgeInsets.only(top : 5, bottom : 20),
                      margin: EdgeInsets.only(left : 6, right : 6),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            bottomLeft : Radius.circular(10), 
                            bottomRight: Radius.circular(10),
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10)
                          ),
                          color: Colors.white
                        ), 
                      child : new ListTile(
                      title: Text(flist.docs[i].data()['name'], style: TextStyle(fontSize: 30)) ,
                      subtitle: Text("Amount : ₹ "+flist.docs[i].data()['amount'].toString()+'\n'+"Date :"+flist.docs[i].data()['date']+"\nCategory : "+flist.docs[i].data()['category'], style: TextStyle(fontSize: 20)),
                      onTap: () => showtransactionDialog(context, flist, i),
                    )) ; 
                  }
                );
                /*ListView.separated(
                  padding: EdgeInsets.only(top: 0),
                  itemBuilder: (BuildContext context, int index) {
                    OTransaction trans =transactionList[index];                  
                    
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
                          title: Text(flist.docs[index].data()['amount'].toString(), style: TextStyle(fontSize: 30)),
                          subtitle: Text(
                          "₹ ${flist.docs[index].data()['name']} \nDate : ${flist.docs[index].data()['date']}",
                            style: TextStyle(
                              fontSize: 20),
                          ),
                          onTap: () => showtransactionDialog(context, trans, index)),
                      )
                    );
                  },
                  itemCount: transactionList.length,
                  separatorBuilder: (BuildContext context, int index) => Divider(color: Colors.black),
                  );*/
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
              // ignore: deprecated_member_use
              icon: Icon(Icons.home), title : Text('Home')),
          BottomNavigationBarItem(
            // ignore: deprecated_member_use
              icon: Icon(Icons.add), title: Text('Add')),
          BottomNavigationBarItem(
            // ignore: deprecated_member_use
              icon: Icon(Icons.equalizer), title: Text('Stats')),
          BottomNavigationBarItem(
            // ignore: deprecated_member_use
              icon: Icon(Icons.filter_list), title: Text('Filters')),
        ],
        currentIndex: selectedIndex,
        unselectedItemColor: Colors.white,
        fixedColor: Colors.yellow,
        onTap: (index)  {
            setState((){
              selectedIndex = index;
              if (selectedIndex == 1){
                Navigator.push(context,MaterialPageRoute(builder: (BuildContext context) => TransactionForm(budget: budget, sum : sum, misc: misc, miscsum: miscsum)));
                fs.getData().then((result){
                    setState(() {
                      flist = result; 
                      print (flist.docs[0].data()['name']);
                    });
                  });
              }

              if (selectedIndex == 2){
                Navigator.push(context,MaterialPageRoute(builder: (BuildContext context) => Stats(flist: flist, l: [name, budget, misc])));
              }

              if (selectedIndex == 3)
                Navigator.push(context,MaterialPageRoute(builder: (BuildContext context) => Filter()));
              if (selectedIndex == 0){
                  _calcTotal();
                  //Firebase.initializeApp();
                  //flist = fs.getEntries();
                  print (flist);
              
                  print ("dsadsjdfj" + flist.toString());
                  print (flist.docs[0].data()['name']);
                  fs.getData().then((result){
                    setState(() {
                      flist = result; 
                      print (flist.docs[0].data()['name']);
                    });
                  });
                  //initState();    
              }
            });
          }
      ),
    );
  }
}