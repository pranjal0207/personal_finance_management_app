import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class Stats extends StatefulWidget {
  final QuerySnapshot flist;
  final List l;
  const Stats({Key key, @required this.flist, this.l}) : super(key: key);


  @override
  StatState createState() { return StatState(this.flist, this.l);}
}

class StatState extends State<Stats> {

  QuerySnapshot flist;
  List l;

  StatState (this.flist, this.l);

  double foodbal = 0;
  double clothbal = 0;
  double dailybal = 0;  
  double misc = 0;
  double remaining = 0;

  void calc(){
    for (int i = 0; i<flist.docs.length; i++){
      if (flist.docs[i].data()['category'] == 'Food')
        foodbal = foodbal + flist.docs[i].data()['amount'];

      if (flist.docs[i].data()['category'] == 'Clothing')
        clothbal = clothbal + flist.docs[i].data()['amount']; 

      if (flist.docs[i].data()['category'] == 'Daily Needs')
        dailybal = dailybal + flist.docs[i].data()['amount']; 

      if (flist.docs[i].data()['category'] == 'Miscellaneous')
        misc = misc + flist.docs[i].data()['amount']; 

      remaining = l[1] - (foodbal + clothbal + dailybal + misc);
      print (remaining.toString());

      if (remaining < 0)
        remaining = 0;

      print(l[1].toString());
    }
  }

  List<charts.Series> seriesList;
 
  List<charts.Series<Stat, String>> _createRandomData() {
   // final random = Random();
 
    // ignore: non_constant_identifier_names
    final StatData = [
      Stat('Food', foodbal.toInt(), charts.MaterialPalette.purple.shadeDefault),
      Stat('Clothing', clothbal.toInt(), charts.MaterialPalette.green.shadeDefault),
      Stat('Daily Needs', dailybal.toInt(), charts.MaterialPalette.blue.shadeDefault),
      Stat('Misc', misc.toInt(), charts.MaterialPalette.red.shadeDefault),
      Stat('Remaining', remaining.toInt(), charts.MaterialPalette.gray.shadeDefault),
    ];
 
    
 
    return [
      charts.Series<Stat, String>(
        id: 'Stat',
        domainFn: (Stat amount, _) => amount.category,
        measureFn: (Stat amount, _) => amount.amount,
        colorFn: (Stat amount, _) => amount.color,
        data: StatData, 
        //labelAccessorFn: (Stat row, _) => '${row.amount}',
      ),
    ];
  }
 
  barChart() {
    return charts.BarChart(
      seriesList,
      animate: true,
      vertical: true,
    );
  }

  pieChart() {
    return charts.PieChart(
      seriesList,
      animate: true,
      defaultRenderer: charts.ArcRendererConfig(
         arcRendererDecorators: [charts.ArcLabelDecorator()],));
  }

  @override 
  void initState() {
    calc();
    super.initState();
    seriesList = _createRandomData();
    print(foodbal.toInt().toString() + " " + clothbal.toInt().toString() + " " + dailybal.toInt().toString() + " " + misc.toInt().toString() + " " + remaining.toInt().toString());
  }

  @override
  Widget build(BuildContext context) {
    print("Building bar graph");
    return Scaffold(
      appBar: AppBar(title : Text("Stats"),),
      body : Container(
        child: Stack(
          children: <Widget>[
            Container(
              child: Text("Bar Graph",
                style: TextStyle(fontSize: 20),
              ),
              padding: EdgeInsets.only(top: 20.0, left: 10.0),
            ),
            Container(
              child: barChart(),
              padding: EdgeInsets.only(top : 40.0, left: 10.0, right :10.0, bottom : 400.0),
            ),
            Container(
              child: Text("Pie Chart",
                style: TextStyle(fontSize: 20),
              ),
              padding: EdgeInsets.only(top: 340.0, left: 10.0),
            ),
            Container(
              child: pieChart(),
              padding: EdgeInsets.only(top : 350.0, left: 10.0, right : 10.0),
            ),
          ],
        ),          
        ),
    );
  }
  
  /*@override
  Widget buildpie(BuildContext context) {
    print("Building bar graph");
    return Scaffold(
      appBar: AppBar(title : Text("Stats"),),
      body : Container(
        padding: EdgeInsets.only(top : 500.0, left: 10.0, right :10.0, bottom : 10.0),
        child: pieChart(),          
        ),
    );
  }*/
}

class Stat {
  final String category;
  final int amount;
  final charts.Color color;

  Stat(this.category, this.amount, this.color);
}