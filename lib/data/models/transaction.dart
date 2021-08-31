class MyTransaction {
  String id;
  String currentDate;
  String amount;
  String category;
  String comment;
  String typeTransaction;

  MyTransaction({
    this.id = '',
    this.amount = '0.00',
    this.currentDate = '',
    this.category = '',
    this.comment = '',
    this.typeTransaction = '',
  });

  MyTransaction.fromJson(Map<String, dynamic> json)
      : this(
          id: json['id'] as String,
          currentDate: json['currentDate'] as String,
          amount: json['amount'] as String,
          category: json['category'] as String,
          comment: json['comment'] as String,
          typeTransaction: json['typeTransaction'] as String,
        );

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'currentDate': currentDate,
      'amount': amount,
      'category': category,
      'comment': comment,
      'typeTransaction': typeTransaction,
    };
  }
}
