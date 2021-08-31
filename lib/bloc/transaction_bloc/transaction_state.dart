part of 'transaction_bloc.dart';

abstract class TransactionState extends Equatable {
  const TransactionState();

  @override
  List<Object> get props => [];
}

//class TransactionInitial extends TransactionState {}

class TransactionEmptyState extends TransactionState {}

class TransactionLoadingState extends TransactionState {}

class TransactionLoadedState extends TransactionState {
  final List<MyTransaction> loadedTrasaction;
  final double sum;

  const TransactionLoadedState(this.loadedTrasaction, this.sum);

  @override
  List<Object> get props => [loadedTrasaction, sum];

  // @override
  // String toString() => 'TrasactionLoaded { trasaction: $loadedTrasaction }';
}

class TransactionErrorState extends TransactionState {}
