import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:summarizeddebts/model/monthly_income_model.dart';
import 'package:summarizeddebts/modules/debt/repository/api/monthly_income_api.dart';
import 'package:summarizeddebts/modules/debt/repository/api/monthly_income_request.dart';
import 'package:summarizeddebts/repositories/base/base_repository.dart';

class MonthlyIncomeRepository extends BaseRepository {
  final MonthlyIncomeApi _monthlyIncomeApi;

  MonthlyIncomeRepository(this._monthlyIncomeApi);

  Future<MonthlyIncomeModel> getById(MonthlyIncomeRequest request) async {
    super.checkInternetConnection();

    DocumentSnapshot documentSnapshot =
        await this._monthlyIncomeApi.getById(request);

    if (documentSnapshot != null) {
      return MonthlyIncomeModel.fromJson(documentSnapshot.data);
    }

    return null;
  }

  Future<MonthlyIncomeModel> getByMonth(
      MonthlyIncomeRequest request) async {
    super.checkInternetConnection();

    List<DocumentSnapshot> documentsSnapshot =
        await this._monthlyIncomeApi.getByMonth(request);

    if (documentsSnapshot != null && documentsSnapshot.isNotEmpty) {
      return MonthlyIncomeModel.fromJson(documentsSnapshot.first.data);
    }

    return null;
  }

  Future<List<MonthlyIncomeModel>> consult() async {
    super.checkInternetConnection();

    List<DocumentSnapshot> documents = await this._monthlyIncomeApi.consult();
    List<MonthlyIncomeModel> response = [];
    if (documents != null) {
      for (DocumentSnapshot document in documents) {
        response.add(MonthlyIncomeModel.fromJson(document.data));
      }
    }

    return response;
  }

  Future<void> save(MonthlyIncomeRequest request) async =>
      await this._monthlyIncomeApi.save(request);

  Future<void> delete(MonthlyIncomeRequest request) async =>
      await this._monthlyIncomeApi.delete(request);
}
