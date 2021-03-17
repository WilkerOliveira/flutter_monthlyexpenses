import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:summarizeddebts/model/monthly_expenses_model.dart';
import 'package:summarizeddebts/repositories/base/base_repository.dart';
import 'package:summarizeddebts/repositories/summary/api/summary_api.dart';
import 'package:summarizeddebts/repositories/summary/api/summary_request.dart';

class SummaryRepository extends BaseRepository {
  final SummaryApi _summaryApi;

  SummaryRepository(this._summaryApi);

  Future<MonthlyExpensesModel> consultByMonth(String month) async {
    super.checkInternetConnection();

    List<DocumentSnapshot> response =
        await this._summaryApi.consultByMonth(SummaryRequest()..month = month);

    if (response != null && response.isNotEmpty) {
      return MonthlyExpensesModel.fromJson(response[0].data);
    }

    return null;
  }
}
