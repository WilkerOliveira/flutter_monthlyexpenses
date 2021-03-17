import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:summarizeddebts/model/expense_model.dart';
import 'package:summarizeddebts/modules/dashboard/repository/api/dashboard_api.dart';
import 'package:summarizeddebts/modules/dashboard/repository/api/dashboard_request.dart';
import 'package:summarizeddebts/repositories/base/base_repository.dart';

class DashboardRepository extends BaseRepository {
  final DashboardApi _api;

  DashboardRepository(this._api);

  Future<List<ExpenseModel>> consultDebtsByMonth(DashboardRequest request) async {
    super.checkInternetConnection();

    List<DocumentSnapshot> response =
        await this._api.consultDebtsByMonth(request);

    List<ExpenseModel> debts = [];

    if (response != null) {
      for (DocumentSnapshot document in response) {
        debts.add(ExpenseModel.fromJson(document.data));
      }
    }

    return debts;
  }
}
