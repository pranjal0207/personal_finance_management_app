import 'package:personal_finance_management_app/Utils/transaction.dart';

import 'transaction_event.dart';

class Updatetransaction extends TransactionEvent {
  OTransaction newTransaction;
  int transactionIndex;

  Updatetransaction(int index, OTransaction trans) {
    newTransaction = trans;
    transactionIndex = index;
  }
}
