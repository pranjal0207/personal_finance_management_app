import 'package:personal_finance_management_app/events/set_filter.dart';
import 'Utils/DBHelper.dart';
import 'Utils/transaction.dart';
import 'package:personal_finance_management_app/events/delete_transactions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/transaction_bloc.dart';
import 'package:intl/intl.dart';

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