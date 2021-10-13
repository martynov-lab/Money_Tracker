part of 'category_bloc.dart';

abstract class CategoryState extends Equatable {
  const CategoryState();

  @override
  List<Object> get props => [];
}

class CategoryEmptyState extends CategoryState {}

class CategoryLoadingState extends CategoryState {}

class CategoryLoadedState extends CategoryState {
  final List<Category> category;
  final List<MaterialColor> listColors;
  final List<IconData> listIcons;

  const CategoryLoadedState(this.category, this.listColors, this.listIcons);

  @override
  List<Object> get props => [category, listColors, listIcons];

  // @override
  // String toString() => 'TrasactionLoaded { trasaction: $loadedTrasaction }';
}

class CategoryErrorState extends CategoryState {}
