import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:money_tracker/data/models/transaction.dart';
import 'package:money_tracker/data/models/user.dart';
import 'package:money_tracker/data/repository/user_repository.dart';
import 'package:uuid/uuid.dart';

class TransactionRepository {
  UserRepository userRepository = UserRepository();
  MyTransaction transaction = MyTransaction();

  final FirebaseFirestore transactionDb = FirebaseFirestore.instance;

  CollectionReference<MyTransaction> collectionReference(MyAppUser user) {
    var collectionPath = '${user.name}_${user.id}';

    var transactionRef = transactionDb
        .collection(collectionPath)
        .doc('Transaction ${user.name}')
        .collection('Transaction')
        .withConverter<MyTransaction>(
          fromFirestore: (snapshot, _) =>
              MyTransaction.fromJson(snapshot.data()!),
          toFirestore: (transaction, _) => transaction.toJson(),
        );
    return transactionRef;
  }

  //*ДОБАВЛЕНИЕ ТРАНЗАКЦИИ
  Future<void> addTransaction({
    required String currentDate,
    required String amount,
    required String categoryId,
    required String categoryName,
    required String categoryColor,
    required int categoryIcon,
    required String comment,
    required String typeTransaction,
  }) async {
    final user = await userRepository.fetchCurrentUser();
    //var collectionPath = '${user.name}_${user.id}';
    var uuid = const Uuid().v4();

    // CollectionReference<MyTransaction> transactionRef = transactionDb
    //     .collection(collectionPath)
    //     .doc('Transaction ${user.name}')
    //     .collection('Transaction')
    //     .withConverter<MyTransaction>(
    //       fromFirestore: (snapshot, _) =>
    //           MyTransaction.fromJson(snapshot.data()!),
    //       toFirestore: (transaction, _) => transaction.toJson(),
    //     );

    await collectionReference(user).doc(uuid).set(
          MyTransaction(
            id: uuid,
            amount: amount,
            comment: comment,
            categoryId: categoryId,
            categoryName: categoryName,
            categoryColor: categoryColor,
            categoryIcon: categoryIcon,
            currentDate: currentDate,
            typeTransaction: typeTransaction,
          ),
        );
  }

  //*ПОЛУЧЕНИЕ ТРАНЗАКЦИИ ИЗ FIREBASE
  Future<List<MyTransaction>> fetchTransaction() async {
    final user = await userRepository.fetchCurrentUser();
    // var collectionPath = '${user.name}_${user.id}';

    // var transactionRef = transactionDb
    //     .collection(collectionPath)
    //     .doc('Transaction ${user.name}')
    //     .collection('Transaction')
    //     .withConverter<MyTransaction>(
    //       fromFirestore: (snapshot, _) =>
    //           MyTransaction.fromJson(snapshot.data()!),
    //       toFirestore: (transaction, _) => transaction.toJson(),
    //     );

    var querySnapshot = await collectionReference(user).get();
    final allData = querySnapshot.docs.map((doc) => doc.data()).toList();

    return allData;
  }

  //*ОБНАВЛЕНИЕ ТРАНЗАКЦИИ В FIREBASE
  Future<void> updateTransaction(
    String id,
    String currentDate,
    String amount,
    String categoryId,
    String categoryName,
    String categoryColor,
    int categoryIcon,
    String comment,
    String typeTransaction,
  ) async {
    final user = await userRepository.fetchCurrentUser();

    await collectionReference(user).doc(id).update({
      'id': id,
      'currentDate': currentDate,
      'amount': amount,
      'categoryId': categoryId,
      'categoryName': categoryName,
      'categoryColor': categoryColor,
      'categoryIcon': categoryIcon,
      'comment': comment,
      'typeTransaction': typeTransaction,
    });
  }

  //*УДАЛЕНИЕ ТРАНЗАКЦИИ ИЗ FIREBASE
  Future<void> deleteTransaction(String id) async {
    final user = await userRepository.fetchCurrentUser();

    await collectionReference(user).doc(id).delete();
  }
}
