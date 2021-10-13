import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:money_tracker/data/models/category.dart';
import 'package:money_tracker/data/repository/category_repository.dart';
import 'package:money_tracker/data/repository/list_colors_category.dart';
import 'package:money_tracker/data/repository/list_icons_category.dart';

part 'category_bloc_event.dart';
part 'category_bloc_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final CategoryRepository _categoryRepository;
  final ColorsCategory _colorsCategory;
  final IconsCategory _iconsCategory;

  CategoryBloc(
      this._categoryRepository, this._colorsCategory, this._iconsCategory)
      : super(CategoryEmptyState());

  @override
  Stream<CategoryState> mapEventToState(CategoryEvent event) async* {
    if (event is CategoryLoad) {
      yield* _mapLoadCategoryToState();
    } else if (event is CategoryAdd) {
      yield* _mapAddCategoryToState(
        categoryName: event.categoryName,
        categoryColor: event.categoryColor,
        categoryIcon: event.categoryIcon,
      );
    } else if (event is CategoryUpdate) {
      yield* _mapUpdateCategoryToState(
        id: event.id,
        name: event.name,
        color: event.color,
        icon: event.icon,
      );
    } else if (event is CategoryDelete) {
      yield* _mapDeleteCategoryToState(
        id: event.id,
      );
    }
  }

  Stream<CategoryState> _mapLoadCategoryToState() async* {
    try {
      yield CategoryLoadingState();
      List<MaterialColor> listColors = _colorsCategory.colorsCategory;
      List<IconData> listIcons = _iconsCategory.iconsCategory;
      List<Category> category = await _categoryRepository.fetchCategory();

      if (category.isEmpty) {
        await _categoryRepository.addCategoryDeafult();
        var categoryDeafult = await _categoryRepository.fetchCategory();
        //print('categoryDeafult ---- $categoryDeafult');
        yield CategoryLoadedState(categoryDeafult, listColors, listIcons);
        //yield CategoryEmptyState();
      } else {
        yield CategoryLoadedState(category, listColors, listIcons);
      }
    } catch (e) {
      print('Ошибка: $e');
      yield CategoryErrorState();
    }
  }

  Stream<CategoryState> _mapAddCategoryToState({
    required String categoryName,
    required String categoryColor,
    required int categoryIcon,
  }) async* {
    await _categoryRepository.addCategory(
      categoryName: categoryName,
      categoryColor: categoryColor,
      categoryIcon: categoryIcon,
    );
    // if (state is TransactionLoadedState) {
    //   var transaction = await _transactionRepository.fetchTransaction();
    //   yield TransactionLoadedState(transaction);
    // }
  }

  Stream<CategoryState> _mapUpdateCategoryToState({
    required String id,
    required String name,
    required String color,
    required int icon,
  }) async* {
    //List<Category> category = await _categoryRepository.fetchCategory();

    await _categoryRepository.updateCategory(id, name, color, icon);
  }

  Stream<CategoryState> _mapDeleteCategoryToState({required String id}) async* {
    await _categoryRepository.deleteCategory(id);
  }
}
