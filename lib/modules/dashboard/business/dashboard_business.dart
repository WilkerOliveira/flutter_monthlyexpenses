import 'dart:async';

import 'package:mobx/mobx.dart';
import 'package:summarizeddebts/common/utility.dart';
import 'package:summarizeddebts/model/debt_detail_model.dart';
import 'package:summarizeddebts/model/expense_model.dart';
import 'package:summarizeddebts/model/monthly_income_model.dart';
import 'package:summarizeddebts/model/summarized_expenses_model.dart';
import 'package:summarizeddebts/modules/dashboard/repository/api/dashboard_request.dart';
import 'package:summarizeddebts/modules/dashboard/repository/dashboard_repository.dart';
import 'package:summarizeddebts/modules/debt/repository/api/monthly_income_request.dart';
import 'package:summarizeddebts/modules/debt/repository/monthly_income_repository.dart';

class DashboardBusiness {
  final DashboardRepository dashboardRepository;
  final MonthlyIncomeRepository monthlyIncomeRepository;

  DebtDetailModel currentDashboardModel;
  final int _totalToTake = 5;

  DashboardBusiness({this.dashboardRepository, this.monthlyIncomeRepository});

  Future<DebtDetailModel> consultDebtsByMonthV2(DateTime currentMonth) async {
    DashboardRequest request = DashboardRequest();
    request.month = Utility.formatMonthYear(currentMonth);

    var monthlyModel = MonthlyIncomeModel()..month = request.month;
    MonthlyIncomeModel monthlyIncomeModel = await this
        .monthlyIncomeRepository
        .getByMonth(MonthlyIncomeRequest()..monthlyIncomeModel = monthlyModel);

    List<ExpenseModel> debts =
        await dashboardRepository.consultDebtsByMonth(request);
    DebtDetailModel response = DebtDetailModel.init();
    response.debts = SummarizedExpensesModel.init(false);
    response.month = request.month;

    if (debts != null && debts.isNotEmpty) {
      debts.sort((a, b) => a.dueDate.compareTo(b.dueDate));

      response.totalMonth = debts.fold(0, (curr, next) => curr + next.amount);

      response.debts.items = debts;

      if (response.debts.items.length > this._totalToTake) {
        response.debts.items =
            response.debts.items.take(this._totalToTake).toList();
      }
    }
    this.currentDashboardModel = response;
    if (monthlyIncomeModel != null &&
        monthlyIncomeModel.id != null &&
        monthlyIncomeModel.id.isNotEmpty)
      response.monthlyIncome = monthlyIncomeModel.amount;

    return response;
  }

  Future<DebtDetailModel> getDataChart(DateTime currentMonth) async {
    DebtDetailModel response = DebtDetailModel.init();
    response.dataChart = ObservableList.of([]);

    var months = [
      currentMonth,
      DateTime(currentMonth.year, currentMonth.month + -1, currentMonth.day),
      DateTime(currentMonth.year, currentMonth.month + -2, currentMonth.day)
    ];
    DashboardRequest request = DashboardRequest();

    for (DateTime month in months) {
      request.month = Utility.formatMonthYear(month);

      List<ExpenseModel> debts =
          await dashboardRepository.consultDebtsByMonth(request);

      if (debts != null && debts.isNotEmpty) {
        var total = debts.fold(0, (curr, next) => curr + next.amount);
        response.dataChart
            .add(SummarizedExpensesModel.chart(total, request.month));
      } else {
        response.dataChart.add(SummarizedExpensesModel.chart(0, request.month));
      }
    }

    return response;
  }
}
