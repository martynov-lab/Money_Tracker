part of 'category_bloc.dart';

abstract class CategoryEvent extends Equatable {
  const CategoryEvent();

  @override
  List<Object> get props => [];
}

class CategoryLoad extends CategoryEvent {}

class CategoryAdd extends CategoryEvent {
  final String categoryName;
  final String categoryColor;
  final int categoryIcon;
  CategoryAdd({
    required this.categoryName,
    required this.categoryColor,
    required this.categoryIcon,
  });

  @override
  List<Object> get props => [
        categoryName,
        categoryColor,
        categoryIcon,
      ];

  // @override
  // String toString() => 'AddCategory { category: $category }';
}

class CategoryUpdate extends CategoryEvent {
  final String id;
  final String name;
  final String color;
  final int icon;

  const CategoryUpdate(
      {required this.id,
      required this.name,
      required this.color,
      required this.icon});

  @override
  List<Object> get props => [id, name, color, icon];

  // @override
  // String toString() =>
  //     'UpdateCategory { updatedCategory: $updateCategory }';
}

class CategoryDelete extends CategoryEvent {
  final String id;
  const CategoryDelete({
    required this.id,
  });

  @override
  List<Object> get props => [id];

  // @override
  // String toString() => 'deleteCategory { deleteCategory: $category }';
}
