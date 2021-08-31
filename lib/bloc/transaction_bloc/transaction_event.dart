part of 'transaction_bloc.dart';

abstract class TransactionEvent extends Equatable {
  const TransactionEvent();

  @override
  List<Object> get props => [];
}

class TransactionLoad extends TransactionEvent {}

class TransactionAdd extends TransactionEvent {
  final MyTransaction transaction;
  TransactionAdd(this.transaction);

  @override
  List<Object> get props => [transaction];

  // @override
  // String toString() => 'AddTransaction { transaction: $transaction }';
}

class TransactionUpdate extends TransactionEvent {
  final MyTransaction updateTransaction;

  const TransactionUpdate(this.updateTransaction);

  @override
  List<Object> get props => [updateTransaction];

  // @override
  // String toString() =>
  //     'UpdateTransaction { updatedTransaction: $updateTransaction }';
}

class TransactionDelete extends TransactionEvent {
  final MyTransaction transaction;
  const TransactionDelete(this.transaction);

  @override
  List<Object> get props => [transaction];

  // @override
  // String toString() => 'deleteTransaction { deleteTransaction: $transaction }';
}

class TransactionClearCompleted extends TransactionEvent {}
