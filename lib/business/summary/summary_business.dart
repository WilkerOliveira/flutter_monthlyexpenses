import 'package:summarizeddebts/model/monthly_expenses_model.dart';
import 'package:summarizeddebts/model/monthly_income_model.dart';
import 'package:summarizeddebts/modules/debt/repository/api/monthly_income_request.dart';
import 'package:summarizeddebts/modules/debt/repository/monthly_income_repository.dart';
import 'package:summarizeddebts/repositories/summary/summary_repository.dart';

class SummaryBusiness {
  final SummaryRepository _summaryRepository;
  final MonthlyIncomeRepository _monthlyIncomeRepository;

  SummaryBusiness(this._summaryRepository, this._monthlyIncomeRepository);

  Future<MonthlyExpensesModel> consultByMonth(String month) async {
    MonthlyExpensesModel monthlyExpensesModel =
        await this._summaryRepository.consultByMonth(month);

    if (monthlyExpensesModel == null) {
      monthlyExpensesModel = MonthlyExpensesModel.init(month);
    }

    var monthlyModel = MonthlyIncomeModel()..month = month;
    MonthlyIncomeModel monthlyIncomeModel = await this
        ._monthlyIncomeRepository
        .getByMonth(MonthlyIncomeRequest()..monthlyIncomeModel = monthlyModel);
    monthlyExpensesModel.monthlyIncome = 0.0;
    if (monthlyIncomeModel != null &&
        monthlyIncomeModel.id != null &&
        monthlyIncomeModel.id.isNotEmpty)
      monthlyExpensesModel.monthlyIncome = monthlyIncomeModel.amount;

    return monthlyExpensesModel;
  }
}
