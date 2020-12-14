
import 'package:flutter/material.dart';


class Stats extends StatefulWidget {
  const Stats({Key key}) : super(key: key);

  @override
  StatState createState() => StatState();
}

class StatState extends State<Stats> {


  @override
  Widget build(BuildContext context) {
    print("Building entire filter list scaffold");
    return Scaffold(
      appBar: AppBar(title : Text("Stats")),
      body : SafeArea(
        child: Text("TEMP"),           
        ),
        );
  }
}