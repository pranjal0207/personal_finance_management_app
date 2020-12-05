import 'package:personal_finance_management_app/utils/DBHelper.dart';

class OTransaction {
  int id;
  String name;
  int amount;
  
  OTransaction({this.id, this.name, this.amount});
 
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      DatabaseProvider.COLUMN_NAME : name,
      DatabaseProvider.COLUMN_AMOUNT : amount,
    };
    return map;
  }
 
  OTransaction.fromMap(Map<String, dynamic> map) {
    name = map[DatabaseProvider.COLUMN_NAME];
    amount = map[DatabaseProvider.COLUMN_AMOUNT];
  }
}