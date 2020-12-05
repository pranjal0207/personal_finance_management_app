import 'package:personal_finance_management_app/Utils/transaction.dart';
import 'transaction_event.dart';

class SetTransactions extends TransactionEvent {
  List<OTransaction> transactionList;

  SetTransactions(List<OTransaction> foods) {
    transactionList = foods;
  }
}
