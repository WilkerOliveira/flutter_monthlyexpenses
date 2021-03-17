import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:summarizeddebts/modules/debt/repository/api/debt_request.dart';
import 'package:summarizeddebts/repositories/api/base_api.dart';
import 'package:summarizeddebts/repositories/util/firestore_collection.dart';

class DebtApi extends BaseApi {
  Future<List<DocumentSnapshot>> loadAll() async {
    QuerySnapshot snapshot = await super
        .firestoreReference
        .collection(FirestoreCollection.debts)
        .document(await getCurrentFirebaseUserId())
        .collection(FirestoreCollection.data)
        .getDocuments();

    return snapshot.documents;
  }

  Future<List<DocumentSnapshot>> getByLocalToPay(DebtRequest request) async {
    QuerySnapshot snapshot = await super
        .firestoreReference
        .collection(FirestoreCollection.debts)
        .document(await getCurrentFirebaseUserId())
        .collection(FirestoreCollection.data)
        .where("localToPayId", isEqualTo: request.debt.localToPayId)
        .getDocuments();

    return snapshot.documents;
  }

  Future<void> save(DebtRequest request) async {
    return Firestore.instance
        .document(FirestoreCollection.debts +
            "/${await getCurrentFirebaseUserId()}" +
            "/${FirestoreCollection.data}" +
            "/${request.debt.id}")
        .setData(request.debt.toJson());
  }

  Future<void> saveToUpdateSummary(DebtRequest request) async {
    var data = Map<String, dynamic>();
    data.putIfAbsent("month", () => request.debt.month);
    data.putIfAbsent("dateTime", () => DateTime.now()).toString();

    return Firestore.instance
        .document(FirestoreCollection.updateSummary +
            "/${await getCurrentFirebaseUserId()}" +
            "/${FirestoreCollection.data}" +
            "/${request.debt.month.replaceAll("/", "_")}")
        .setData(data);
  }

  Future<void> delete(DebtRequest request) async {
    return Firestore.instance
        .document(FirestoreCollection.debts +
            "/${await getCurrentFirebaseUserId()}" +
            "/${FirestoreCollection.data}" +
            "/${request.registerId}")
        .delete();
  }

  Future<List<DocumentSnapshot>> consultDebtsByMonth(
      DebtRequest request) async {
    QuerySnapshot snapshot = await super
        .firestoreReference
        .collection(FirestoreCollection.debts)
        .document(await getCurrentFirebaseUserId())
        .collection(FirestoreCollection.data)
        .where("month", isEqualTo: request.debt.month)
        .getDocuments();

    return snapshot.documents;
  }

  Future<DocumentSnapshot> getById(DebtRequest request) async {
    DocumentSnapshot snapshot = await super
        .firestoreReference
        .collection(FirestoreCollection.debts)
        .document(await getCurrentFirebaseUserId())
        .collection(FirestoreCollection.data)
        .document(request.registerId)
        .get();

    return snapshot;
  }

  Future<List<DocumentSnapshot>> consultDebtsByMonthStatus(
      DebtRequest request) async {
    QuerySnapshot snapshot = await super
        .firestoreReference
        .collection(FirestoreCollection.debts)
        .document(await getCurrentFirebaseUserId())
        .collection(FirestoreCollection.data)
        .where("month", isEqualTo: request.debt.month)
        .where("paid", isEqualTo: request.debt.paid)
        .getDocuments();

    return snapshot.documents;
  }

  Future<List<DocumentSnapshot>> getByLocalToPayAndMonth(
      DebtRequest request) async {
    QuerySnapshot snapshot = await super
        .firestoreReference
        .collection(FirestoreCollection.debts)
        .document(await getCurrentFirebaseUserId())
        .collection(FirestoreCollection.data)
        .where("month", isEqualTo: request.debt.month)
        .where("localToPayId", isEqualTo: request.debt.localToPayId)
        .getDocuments();

    return snapshot.documents;
  }
}
