class MyTransaction {
  String? id;
  String? currentDate;
  String? amount;
  String? categoryId;
  String? categoryName;
  String? categoryColor;
  int? categoryIcon;
  String? comment;
  String? typeTransaction;

  MyTransaction({
    this.id,
    this.amount,
    this.currentDate,
    this.categoryId,
    this.categoryName,
    this.categoryColor,
    this.categoryIcon,
    this.comment,
    this.typeTransaction,
  });

  MyTransaction.fromJson(Map<String, dynamic> json)
      : this(
          id: json['id'] as String,
          currentDate: json['currentDate'] as String,
          amount: json['amount'] as String,
          categoryId: json['categoryId'] as String,
          categoryName: json['categoryName'] as String,
          categoryColor: json['categoryColor'] as String,
          categoryIcon: json['categoryIcon'] as int,
          comment: json['comment'] as String,
          typeTransaction: json['typeTransaction'] as String,
        );

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'currentDate': currentDate,
      'amount': amount,
      'categoryId': categoryId,
      'categoryName': categoryName,
      'categoryColor': categoryColor,
      'categoryIcon': categoryIcon,
      'comment': comment,
      'typeTransaction': typeTransaction,
    };
  }
}
