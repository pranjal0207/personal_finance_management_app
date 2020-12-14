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
      Stat('Food', random.nextInt(5000)),
      Stat('Clothing', random.nextInt(5000)),
      Stat('Daily Needs', random.nextInt(5000)),
      Stat('Misc', random.nextInt(5000)),
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
        data: StatData,
        fillColorFn: (Stat amount, _) {
          return charts.MaterialPalette.blue.shadeDefault;
        },
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
      /*barGroupingType: charts.BarGroupingType.grouped,
      defaultRenderer: charts.BarRendererConfig(
        groupingType: charts.BarGroupingType.grouped,
        strokeWidthPx: 1.0,
      ),
      domainAxis: charts.OrdinalAxisSpec(
        renderSpec: charts.NoneRenderSpec(),
      ),*/
    );
  }

  @override
  void initState() {
    super.initState();
    seriesList = _createRandomData();
  }

  @override
  Widget build(BuildContext context) {
    print("Building entire filter list scaffold");
    return Scaffold(
      appBar: AppBar(title : Text("Stats"),),
      body : Container(
        padding: EdgeInsets.only(top : 10.0, left: 10.0, right :10.0, bottom : 400.0),
        child: barChart(),           
        ),
    );
  }
}

class Stat {
  final String category;
  final int amount;
 
  Stat(this.category, this.amount);
}