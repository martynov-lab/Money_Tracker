import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:money_tracker/data/models/transaction.dart';
import 'package:money_tracker/data/repository/transaction_repository.dart';

part 'transaction_event.dart';
part 'transaction_state.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  final TransactionRepository _transactionRepository;
  TransactionBloc(this._transactionRepository) : super(TransactionEmptyState());

  // final TransactionRepository _transactionRepository;
  // TransactionBloc({required TransactionRepository transactionRepository})
  //     : _transactionRepository = transactionRepository,
  //       super(TransactionEmptyState());

  @override
  Stream<TransactionState> mapEventToState(TransactionEvent event) async* {
    if (event is TransactionLoad) {
      yield* _mapLoadTransactionToState();
    } else if (event is TransactionAdd) {
      yield* _mapAddTransactionToState(event);
    } else if (event is TransactionUpdate) {
      yield* _mapUpdateTransactionToState();
    } else if (event is TransactionDelete) {
      yield* _mapDeleteTransactionToState();
    } else if (event is TransactionClearCompleted) {
      yield* _mapClearCompletedToState();
    }
  }

  Stream<TransactionState> _mapLoadTransactionToState() async* {
    try {
      yield TransactionLoadingState();
      List<MyTransaction> transaction =
          await _transactionRepository.fetchTransaction();
      double sum = 0.00;

      print("Данные: ${transaction}");

      if (transaction.isEmpty) {
        yield TransactionEmptyState();
      } else {
        for (MyTransaction item in transaction) {
          print('item: ${item.amount}');
          String value = item.amount;
          if (item.typeTransaction == 'income') {
            sum += double.parse(value);
          } else if (item.typeTransaction == 'expenditure') {
            sum -= double.parse(value);
          }
        }
        yield TransactionLoadedState(transaction, sum);
        print('Сумма расходов: $sum');
      }
      // if (state is TransactionLoadedState) {
      //   yield TransactionLoadedState(transaction);
      //   print("Данные если State is Loaded: ${transaction}");
      // }
    } catch (e) {
      print("Ошибка: $e");
      yield TransactionErrorState();
    }
  }

  Stream<TransactionState> _mapAddTransactionToState(
      TransactionAdd event) async* {
    _transactionRepository.addTransaction(event.transaction);
    // if (state is TransactionLoadedState) {
    //   var transaction = await _transactionRepository.fetchTransaction();
    //   yield TransactionLoadedState(transaction);
    // }
  }

  Stream<TransactionState> _mapUpdateTransactionToState() async* {}
  Stream<TransactionState> _mapDeleteTransactionToState() async* {}
  Stream<TransactionState> _mapClearCompletedToState() async* {}
}
