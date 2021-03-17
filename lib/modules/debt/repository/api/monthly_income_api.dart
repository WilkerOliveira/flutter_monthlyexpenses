import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:summarizeddebts/modules/debt/repository/api/monthly_income_request.dart';
import 'package:summarizeddebts/repositories/api/base_api.dart';
import 'package:summarizeddebts/repositories/util/firestore_collection.dart';

class MonthlyIncomeApi extends BaseApi {
  Future<DocumentSnapshot> getById(MonthlyIncomeRequest request) async {
    DocumentSnapshot snapshot = await super
        .firestoreReference
        .collection(FirestoreCollection.monthlyIncome)
        .document(await getCurrentFirebaseUserId())
        .collection(FirestoreCollection.data)
        .document(request.registerId)
        .get();

    if (snapshot == null) return null;

    return snapshot;
  }

  Future<List<DocumentSnapshot>> consult() async {
    QuerySnapshot snapshot = await super
        .firestoreReference
        .collection(FirestoreCollection.monthlyIncome)
        .document(await getCurrentFirebaseUserId())
        .collection(FirestoreCollection.data)
        .getDocuments();

    return snapshot.documents;
  }

  Future<List<DocumentSnapshot>> getByMonth(
      MonthlyIncomeRequest request) async {
    QuerySnapshot snapshot = await super
        .firestoreReference
        .collection(FirestoreCollection.monthlyIncome)
        .document(await getCurrentFirebaseUserId())
        .collection(FirestoreCollection.data)
        .where("month", isEqualTo: request.monthlyIncomeModel.month)
        .getDocuments();

    return snapshot.documents;
  }

  Future<void> save(MonthlyIncomeRequest request) async {
    return Firestore.instance
        .document(FirestoreCollection.monthlyIncome +
            "/${await getCurrentFirebaseUserId()}" +
            "/${FirestoreCollection.data}" +
            "/${request.monthlyIncomeModel.id}")
        .setData(request.monthlyIncomeModel.toJson());
  }

  Future<void> delete(MonthlyIncomeRequest request) async {
    return Firestore.instance
        .document(FirestoreCollection.monthlyIncome +
            "/${await getCurrentFirebaseUserId()}" +
            "/${FirestoreCollection.data}" +
            "/${request.monthlyIncomeModel.id}")
        .delete();
  }
}
