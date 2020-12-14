import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  const Settings({Key key}) : super(key: key);

  @override
  SettingState createState() => SettingState();
}

class SettingState extends State<Settings> {
  var controller1 = new TextEditingController();
  var controller2 = new TextEditingController();
  var controller3 = new TextEditingController();
  var controller4 = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    print("Building entire filter list scaffold");
    return Scaffold(
      appBar: AppBar(title : Text("Settings")),
      body : SafeArea(
        child: Stack(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top :0, left : 10, right : 10),
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
              margin: EdgeInsets.only(top : 65, left : 10, right : 10),
              child: TextFormField(
              controller: controller2,
              //initialValue: budget.toString(),
              decoration: InputDecoration(labelText: 'Total Budget'),
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
              margin: EdgeInsets.only(top : 130, left : 10, right : 10),
              child: TextFormField(
              controller: controller3,
              //initialValue: budget.toString(),
              decoration: InputDecoration(labelText: 'Miscellaneous Budget'),
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
          ],
        ),         
        ),
        );
  }
}