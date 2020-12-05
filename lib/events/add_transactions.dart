import 'package:personal_finance_management_app/Utils/transaction.dart';
import 'transaction_event.dart';

class Addtransaction extends TransactionEvent {
  OTransaction newTransaction;

  Addtransaction(OTransaction trans) {
    newTransaction = trans;
  }
}
