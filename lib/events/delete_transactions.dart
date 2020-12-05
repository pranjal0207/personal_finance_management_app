import 'package:sqflite/sqflite.dart';

import 'transaction_event.dart';

class Deletetransaction extends TransactionEvent {
  int transactionIndex;

  Deletetransaction(int index) {
    transactionIndex = index;
  }
}
