import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:summarizeddebts/model/expense_model.dart';
import 'package:summarizeddebts/modules/debt/repository/api/debt_api.dart';
import 'package:summarizeddebts/modules/debt/repository/api/debt_request.dart';
import 'package:summarizeddebts/repositories/base/base_repository.dart';

class DebtRepository extends BaseRepository {
  final DebtApi _api;

  DebtRepository(this._api);

  Future<List<ExpenseModel>> loadAll() async {
    super.checkInternetConnection();

    List<DocumentSnapshot> response = await this._api.loadAll();

    List<ExpenseModel> debts = [];

    if (response != null) {
      for (DocumentSnapshot document in response) {
        debts.add(ExpenseModel.fromJson(document.data));
      }
    }

    return debts;
  }

  Future<List<ExpenseModel>> getByLocalToPay(DebtRequest request) async {
    super.checkInternetConnection();

    List<DocumentSnapshot> response = await this._api.getByLocalToPay(request);

    List<ExpenseModel> debts = [];

    if (response != null) {
      for (DocumentSnapshot document in response) {
        debts.add(ExpenseModel.fromJson(document.data));
      }
    }

    return debts;
  }

  Future<void> save(DebtRequest request) async {
    await this._api.save(request);
  }

  Future<void> saveToUpdateSummary(DebtRequest request) async {
    await this._api.saveToUpdateSummary(request);
  }

  Future<void> delete(DebtRequest request) async =>
      await this._api.delete(request);

  Future<List<ExpenseModel>> consultDebtsByMonth(DebtRequest request) async {
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

  Future<ExpenseModel> getById(DebtRequest request) async {
    super.checkInternetConnection();

    DocumentSnapshot documentSnapshot = await this._api.getById(request);

    if (documentSnapshot != null) {
      return ExpenseModel.fromJson(documentSnapshot.data);
    }

    return null;
  }

  Future<List<ExpenseModel>> consultDebtsByMonthStatus(
      DebtRequest request) async {
    super.checkInternetConnection();

    List<DocumentSnapshot> response =
        await this._api.consultDebtsByMonthStatus(request);

    List<ExpenseModel> debts = [];

    if (response != null) {
      for (DocumentSnapshot document in response) {
        debts.add(ExpenseModel.fromJson(document.data));
      }
    }

    return debts;
  }

  Future<List<ExpenseModel>> getByLocalToPayAndMonth(
      DebtRequest request) async {
    super.checkInternetConnection();

    List<DocumentSnapshot> response =
        await this._api.getByLocalToPayAndMonth(request);

    List<ExpenseModel> debts = [];

    if (response != null) {
      for (DocumentSnapshot document in response) {
        debts.add(ExpenseModel.fromJson(document.data));
      }
    }

    return debts;
  }
}
