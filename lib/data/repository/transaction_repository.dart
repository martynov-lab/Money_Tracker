import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:money_tracker/data/models/transaction.dart';
import 'package:money_tracker/data/models/user.dart';
import 'package:money_tracker/data/repository/user_repository.dart';
import 'package:uuid/uuid.dart';

class TransactionRepository {
  //MyAppUser user = MyAppUser();
  UserRepository userRepository = UserRepository();
  MyTransaction transaction = MyTransaction();

  // final user = userRepository.fetchCurrentUser();
  // String collectionPath = '${user.name}_${user.id}';

  final FirebaseFirestore transactionDb = FirebaseFirestore.instance;

  addTransaction(MyTransaction myTransaction) async {
    final user = await userRepository.fetchCurrentUser();
    String collectionPath = '${user.name}_${user.id}';
    var uuid = const Uuid().v4();

    CollectionReference<MyTransaction> transactionRef =
        transactionDb.collection(collectionPath).withConverter<MyTransaction>(
              fromFirestore: (snapshot, _) =>
                  MyTransaction.fromJson(snapshot.data()!),
              toFirestore: (transaction, _) => transaction.toJson(),
            );

    await transactionRef.doc(uuid).set(
          MyTransaction(
            id: uuid,
            amount: myTransaction.amount,
            comment: myTransaction.comment,
            category: myTransaction.category,
            currentDate: myTransaction.currentDate,
            typeTransaction: myTransaction.typeTransaction,
          ),
        );
  }

  Future<List<MyTransaction>> fetchTransaction() async {
    final user = await userRepository.fetchCurrentUser();
    String collectionPath = '${user.name}_${user.id}';
    //var uuid = const Uuid().v4();

    CollectionReference<MyTransaction> transactionRef =
        transactionDb.collection(collectionPath).withConverter<MyTransaction>(
              fromFirestore: (snapshot, _) =>
                  MyTransaction.fromJson(snapshot.data()!),
              toFirestore: (transaction, _) => transaction.toJson(),
            );

    var querySnapshot = await transactionRef.get();
    final allData = querySnapshot.docs.map((doc) => doc.data()).toList();

    return allData;
  }

  // Future<void> addTransaction(MyTransaction myTransaction) async {
  //   MyAppUser user = await userRepository.fetchCurrentUser();
  //   print('${user.name}');
  //   String collectionPath = '${user.name}_${user.id}';
  //   var uuid = const Uuid().v4();
  //   myTransaction.id = uuid;
  //   await transaction_db.collection(collectionPath).doc('$uuid').set({
  //     'id': uuid,
  //     'data': myTransaction.currentDate,
  //     'amount': myTransaction.amount,
  //     'category': myTransaction.category,
  //   });
  // }

  // fetchTransaction() async {
  //   MyAppUser user = await userRepository.fetchCurrentUser();
  //   String collectionPath = '${user.name}_${user.id}';
  //   Map<String, dynamic> _data = {};
  //   var docRef = await transaction_db.collection(collectionPath);
  //   var data = docRef.snapshots().listen((result) {
  //     result.docs.forEach((result) {
  //       print("Данные из: snapshots() - ${result.data()}");
  //     });
  //   });
  //   print("Данные из: _data) - ${_data}");
  // }
}
