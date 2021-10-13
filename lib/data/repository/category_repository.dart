import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:money_tracker/data/models/category.dart';
import 'package:money_tracker/data/models/user.dart';
import 'package:money_tracker/data/repository/list_deafult_category.dart';

import 'package:money_tracker/data/repository/user_repository.dart';
import 'package:uuid/uuid.dart';

class CategoryRepository {
  final UserRepository userRepository = UserRepository();
  final FirebaseFirestore categoryDb = FirebaseFirestore.instance;

  CollectionReference<Category> collectionReference(MyAppUser user) {
    var collectionPath = '${user.name}_${user.id}';
    var categoryRef = categoryDb
        .collection(collectionPath)
        .doc('Transaction ${user.name}')
        .collection('Category')
        .withConverter<Category>(
          fromFirestore: (snapshot, _) => Category.fromJson(snapshot.data()!),
          toFirestore: (category, _) => category.toJson(),
        );
    return categoryRef;
  }

  //*ДОБАВЛЕНИЕ КАТЕГОРИЙ ПО УМОЛЧАНИЮ
  Future<void> addCategoryDeafult() async {
    final user = await userRepository.fetchCurrentUser();
    var categoryDeafult = ListDeafultCategory();

    categoryDeafult.listDeafultCategory.forEach((category) {
      var uuid = const Uuid().v4(); //новый id для каждой категории
      collectionReference(user).doc(uuid).set(
            Category(
              id: uuid,
              name: category['name'] as String,
              color: category['color'] as String,
              icon: category['icon'] as int,
            ),
          );
    });
  }

  //*ДОБАВЛЕНИЕ КАТЕГОРИЙ ПО СОБЫТИЮ
  Future<void> addCategory({
    required String categoryName,
    required String categoryColor,
    required int categoryIcon,
  }) async {
    final user = await userRepository.fetchCurrentUser();
    var uuid = const Uuid().v4();

    await collectionReference(user).doc(uuid).set(
          Category(
            id: uuid,
            name: categoryName,
            color: categoryColor,
            icon: categoryIcon,
          ),
        );
  }

  //*ПОЛУЧЕНИЕ КАТЕГОРИЙ ИЗ FIREBASE
  Future<List<Category>> fetchCategory() async {
    final user = await userRepository.fetchCurrentUser();

    var querySnapshot = await collectionReference(user).get();
    final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
    // print('querySnapshot $querySnapshot');
    // print('allData $allData');
    return allData;
  }

  //*ОБНАВЛЕНИЕ КАТЕГОРИЙ В FIREBASE
  Future<void> updateCategory(
      String id, String name, String color, int icon) async {
    final user = await userRepository.fetchCurrentUser();

    await collectionReference(user).doc(id).update({
      'id': id,
      'name': name,
      'color': color,
      'icon': icon,
    });
  }

  //*УДАЛЕНИЕ КАТЕГОРИЙ ИЗ FIREBASE
  Future<void> deleteCategory(String id) async {
    final user = await userRepository.fetchCurrentUser();

    await collectionReference(user).doc(id).delete();
  }
}
