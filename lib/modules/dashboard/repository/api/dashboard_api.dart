import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:summarizeddebts/modules/dashboard/repository/api/dashboard_request.dart';
import 'package:summarizeddebts/repositories/api/base_api.dart';
import 'package:summarizeddebts/repositories/util/firestore_collection.dart';

class DashboardApi extends BaseApi {
  Future<List<DocumentSnapshot>> consultDebtsByMonth(
      DashboardRequest request) async {
    QuerySnapshot snapshot = await super
        .firestoreReference
        .collection(FirestoreCollection.debts)
        .document(await getCurrentFirebaseUserId())
        .collection(FirestoreCollection.data)
        .where("month", isEqualTo: request.month)
        .getDocuments();

    return snapshot.documents;
  }
}
