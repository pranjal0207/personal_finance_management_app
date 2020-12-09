import 'package:personal_finance_management_app/events/add_transactions.dart';
import 'package:personal_finance_management_app/events/delete_transactions.dart';
import 'package:personal_finance_management_app/events/transaction_event.dart';
import 'package:personal_finance_management_app/events/set_transactions.dart';
import 'package:personal_finance_management_app/events/update_transactions.dart';
import 'package:personal_finance_management_app/Utils/transaction.dart';
import 'package:personal_finance_management_app/events/set_filter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TransactionBloc extends Bloc<TransactionEvent, List<OTransaction>> {
  @override
  List<OTransaction> get initialState => List<OTransaction>();

  @override
  Stream<List<OTransaction>> mapEventToState(TransactionEvent event) async* {
    if (event is SetTransactions) {
      yield event.transactionList;
    } else if (event is Addtransaction) {
      List<OTransaction> newState = List.from(state);
      if (event.newTransaction != null) {
        newState.add(event.newTransaction);
      }
      yield newState;
    } else if (event is Deletetransaction) {
      List<OTransaction> newState = List.from(state);
      newState.removeAt(event.transactionIndex);
      yield newState;
    } else if (event is Updatetransaction) {
      List<OTransaction> newState = List.from(state);
      newState[event.transactionIndex] = event.newTransaction;
      yield newState;
    }else if (event is SetFilter) {
      yield event.filterList;
    }
  }
}