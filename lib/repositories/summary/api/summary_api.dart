import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:summarizeddebts/repositories/api/base_api.dart';
import 'package:summarizeddebts/repositories/summary/api/summary_request.dart';
import 'package:summarizeddebts/repositories/util/firestore_collection.dart';

class SummaryApi extends BaseApi {
  Future<List<DocumentSnapshot>> consultByMonth(SummaryRequest request) async {
    QuerySnapshot snapshot = await super
        .firestoreReference
        .collection(FirestoreCollection.summary)
        .document(await getCurrentFirebaseUserId())
        .collection(FirestoreCollection.data)
        .where("month", isEqualTo: request.month)
        .getDocuments();

    return snapshot.documents;
  }
}
