import 'package:personal_finance_management_app/utils/DBHelper.dart';

class OTransaction {
  int id;
  String fid;
  String name;
  int amount;
  String date;
  String category;
  
  OTransaction({this.id, this.name, this.amount, this.date, this.category});
 
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      DatabaseProvider.COLUMN_NAME : name,
      DatabaseProvider.COLUMN_AMOUNT : amount,
      DatabaseProvider.COLUMN_DATE : date,
      DatabaseProvider.COLUMN_CATEGORY : category
    };
    return map;
  }
 
  OTransaction.fromMap(Map<String, dynamic> map) {
    name = map[DatabaseProvider.COLUMN_NAME];
    amount = map[DatabaseProvider.COLUMN_AMOUNT];
    date = map[DatabaseProvider.COLUMN_DATE];
    category = map[DatabaseProvider.COLUMN_DATE];
  }
}