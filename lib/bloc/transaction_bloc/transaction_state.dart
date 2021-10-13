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
  final Map<String?, List<MyTransaction>> loadedGroupTrasaction;
  final double sum;
  final List<Category> category;

  const TransactionLoadedState(
      this.loadedGroupTrasaction, this.sum, this.category);

  @override
  List<Object> get props => [loadedGroupTrasaction, sum];

  // @override
  // String toString() => 'TrasactionLoaded { trasaction: $loadedTrasaction }';
}

class TransactionErrorState extends TransactionState {}
