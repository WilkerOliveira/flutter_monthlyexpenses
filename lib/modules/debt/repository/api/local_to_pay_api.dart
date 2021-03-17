import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:summarizeddebts/modules/debt/repository/api/local_to_pay_request.dart';
import 'package:summarizeddebts/repositories/api/base_api.dart';
import 'package:summarizeddebts/repositories/util/firestore_collection.dart';

class LocalToPayApi extends BaseApi {
  Future<DocumentSnapshot> getById(LocalToPayRequest request) async {
    DocumentSnapshot snapshot = await super
        .firestoreReference
        .collection(FirestoreCollection.localToPay)
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
        .collection(FirestoreCollection.localToPay)
        .document(await getCurrentFirebaseUserId())
        .collection(FirestoreCollection.data)
        .getDocuments();

    return snapshot.documents;
  }

  Future<List<DocumentSnapshot>> getByDescription(
      LocalToPayRequest request) async {
    QuerySnapshot snapshot = await super
        .firestoreReference
        .collection(FirestoreCollection.localToPay)
        .document(await getCurrentFirebaseUserId())
        .collection(FirestoreCollection.data)
        .where("description", isEqualTo: request.localToPayModel.description)
        .getDocuments();

    return snapshot.documents;
  }

  Future<void> save(LocalToPayRequest request) async {
    return Firestore.instance
        .document(FirestoreCollection.localToPay +
            "/${await getCurrentFirebaseUserId()}" +
            "/${FirestoreCollection.data}" +
            "/${request.localToPayModel.id}")
        .setData(request.localToPayModel.toJson());
  }

  Future<void> delete(LocalToPayRequest request) async {
    return Firestore.instance
        .document(FirestoreCollection.localToPay +
            "/${await getCurrentFirebaseUserId()}" +
            "/${FirestoreCollection.data}" +
            "/${request.localToPayModel.id}")
        .delete();
  }
}
