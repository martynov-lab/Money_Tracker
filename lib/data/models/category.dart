import 'package:money_tracker/data/models/transaction.dart';

class Category extends MyTransaction {
  String? id;
  String? name;
  String? color;
  int? icon;

  Category({
    this.id,
    this.name,
    this.color,
    this.icon,
  });

  Category.fromJson(Map<String, dynamic> json)
      : this(
          id: json['id'] as String,
          name: json['name'] as String,
          color: json['color'] as String,
          icon: json['icon'] as int,
        );

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'color': color,
      'icon': icon,
    };
  }
}
