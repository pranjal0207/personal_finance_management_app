import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'dart:math';

class Stats extends StatefulWidget {
  const Stats({Key key}) : super(key: key);

  @override
  StatState createState() => StatState();
}

class StatState extends State<Stats> {
    List<charts.Series> seriesList;
 
  static List<charts.Series<Stat, String>> _createRandomData() {
    final random = Random();
 
    final StatData = [
      Stat('Food', random.nextInt(5000), charts.MaterialPalette.purple.shadeDefault),
      Stat('Clothing', random.nextInt(5000), charts.MaterialPalette.green.shadeDefault),
      Stat('Daily Needs', random.nextInt(5000), charts.MaterialPalette.blue.shadeDefault),
      Stat('Misc', random.nextInt(5000), charts.MaterialPalette.red.shadeDefault),
      Stat('Remaining', random.nextInt(5000), charts.MaterialPalette.gray.shadeDefault),
    ];
 
    /*final tabletStatData = [
      Stat('2015', random.nextInt(100)),
      Stat('2016', random.nextInt(100)),
      Stat('2017', random.nextInt(100)),
      Stat('2018', random.nextInt(100)),
      Stat('2019', random.nextInt(100)),
    ];
 
    final mobileStatData = [
      Stat('2015', random.nextInt(100)),
      Stat('2016', random.nextInt(100)),
      Stat('2017', random.nextInt(100)),
      Stat('2018', random.nextInt(100)),
      Stat('2019', random.nextInt(100)),
    ];*/
 
    return [
      charts.Series<Stat, String>(
        id: 'Stat',
        domainFn: (Stat amount, _) => amount.category,
        measureFn: (Stat amount, _) => amount.amount,
        colorFn: (Stat amount, _) => amount.color,
        data: StatData,
        /*fillColorFn: (Stat amount, _) {
          if (amount.category == 'Food'){
          return charts.MaterialPalette.yellow.shadeDefault;}
          if (amount.category == 'Clothing'){
          return charts.MaterialPalette.green.shadeDefault;}
          if (amount.category == 'Daily Needs'){
          return charts.MaterialPalette.blue.shadeDefault;}
          if (amount.category == 'Misc'){
          return charts.MaterialPalette.red.shadeDefault;}
        },*/
      )/*,
      charts.Series<Stat, String>(
        id: 'Stat',
        domainFn: (Stat amount, _) => amount.category,
        measureFn: (Stat amount, _) => amount.amount,
        data: tabletStatData,
        fillColorFn: (Stat amount, _) {
          return charts.MaterialPalette.green.shadeDefault;
        },
      ),
      charts.Series<Stat, String>(
        id: 'Stat',
        domainFn: (Stat amount, _) => amount.category,
        measureFn: (Stat amount, _) => amount.amount,
        data: mobileStatData,
        fillColorFn: (Stat amount, _) {
          return charts.MaterialPalette.teal.shadeDefault;
        },
      )*/
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
         arcRendererDecorators: [charts.ArcLabelDecorator()]));
  }

  @override
  void initState() {
    super.initState();
    seriesList = _createRandomData();
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