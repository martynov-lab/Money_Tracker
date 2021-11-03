part of 'transaction_bloc.dart';

abstract class TransactionState extends Equatable {
  const TransactionState();

  @override
  List<Object> get props => [];
}

class TransactionEmptyState extends TransactionState {}

class TransactionLoadingState extends TransactionState {}

class TransactionLoadedState extends TransactionState {
  final Map<String?, List<MyTransaction>> loadedGroupTrasactionData;
  final double sum;
  final List<Category> category;
  final Map<String?, List<MyTransaction>> loadedGroupTrasactionCategory;

  const TransactionLoadedState(this.loadedGroupTrasactionData, this.sum,
      this.category, this.loadedGroupTrasactionCategory);

  @override
  List<Object> get props =>
      [loadedGroupTrasactionData, sum, category, loadedGroupTrasactionCategory];

  // @override
  // String toString() => 'TrasactionLoaded { trasaction: $loadedTrasaction }';
}

class TransactionErrorState extends TransactionState {}
