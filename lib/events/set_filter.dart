import 'package:personal_finance_management_app/Utils/transaction.dart';
import 'transaction_event.dart';

class SetFilter extends TransactionEvent {
  List<OTransaction> filterList;

  SetFilter(List<OTransaction> foods) {
    filterList = foods;
  }
}
