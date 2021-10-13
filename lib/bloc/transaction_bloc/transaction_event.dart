part of 'transaction_bloc.dart';

abstract class TransactionEvent extends Equatable {
  const TransactionEvent();

  @override
  List<Object> get props => [];
}

class TransactionLoad extends TransactionEvent {}

class TransactionAdd extends TransactionEvent {
  final String currentDate;
  final String amount;
  final String categoryId;
  final String categoryName;
  final String categoryColor;
  final int categoryIcon;
  final String comment;
  final String typeTransaction;

  TransactionAdd({
    required this.currentDate,
    required this.amount,
    required this.categoryId,
    required this.categoryName,
    required this.categoryColor,
    required this.categoryIcon,
    required this.comment,
    required this.typeTransaction,
  });

  @override
  List<Object> get props => [
        currentDate,
        amount,
        categoryId,
        categoryName,
        categoryColor,
        categoryIcon,
        comment,
        typeTransaction,
      ];

  // @override
  // String toString() => 'AddTransaction { transaction: $transaction }';
}

class TransactionUpdate extends TransactionEvent {
  final String id;
  final String currentDate;
  final String amount;
  final String categoryId;
  final String categoryName;
  final String categoryColor;
  final int categoryIcon;
  final String comment;
  final String typeTransaction;

  const TransactionUpdate({
    required this.id,
    required this.currentDate,
    required this.amount,
    required this.categoryId,
    required this.categoryName,
    required this.categoryColor,
    required this.categoryIcon,
    required this.comment,
    required this.typeTransaction,
  });

  @override
  List<Object> get props => [
        id,
        currentDate,
        amount,
        categoryId,
        categoryName,
        categoryColor,
        categoryIcon,
        comment,
        typeTransaction,
      ];

  // @override
  // String toString() =>
  //     'UpdateTransaction { updatedTransaction: $updateTransaction }';
}

class TransactionDelete extends TransactionEvent {
  final String id;
  const TransactionDelete({required this.id});

  @override
  List<Object> get props => [id];

  // @override
  // String toString() => 'deleteTransaction { deleteTransaction: $transaction }';
}

class TransactionClearCompleted extends TransactionEvent {}
