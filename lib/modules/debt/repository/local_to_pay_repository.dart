import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:summarizeddebts/model/local_to_pay_model.dart';
import 'package:summarizeddebts/modules/debt/repository/api/local_to_pay_api.dart';
import 'package:summarizeddebts/modules/debt/repository/api/local_to_pay_request.dart';
import 'package:summarizeddebts/repositories/base/base_repository.dart';

class LocalToPayRepository extends BaseRepository {
  final LocalToPayApi _localToPayApi;

  LocalToPayRepository(this._localToPayApi);

  Future<LocalToPayModel> getById(LocalToPayRequest request) async {
    super.checkInternetConnection();

    DocumentSnapshot documentSnapshot =
        await this._localToPayApi.getById(request);

    if (documentSnapshot != null) {
      return LocalToPayModel.fromJson(documentSnapshot.data);
    }

    return null;
  }

  Future<LocalToPayModel> getByDescription(LocalToPayRequest request) async {
    super.checkInternetConnection();

    List<DocumentSnapshot> documentsSnapshot =
        await this._localToPayApi.getByDescription(request);

    if (documentsSnapshot != null && documentsSnapshot.isNotEmpty) {
      return LocalToPayModel.fromJson(documentsSnapshot.first.data);
    }

    return null;
  }

  Future<List<LocalToPayModel>> consult() async {
    super.checkInternetConnection();

    List<DocumentSnapshot> documents = await this._localToPayApi.consult();
    List<LocalToPayModel> response = [];
    if (documents != null) {
      for (DocumentSnapshot document in documents) {
        response.add(LocalToPayModel.fromJson(document.data));
      }
    }

    return response;
  }

  Future<void> save(LocalToPayRequest request) async =>
      await this._localToPayApi.save(request);

  Future<void> delete(LocalToPayRequest request) async =>
      await this._localToPayApi.delete(request);
}
