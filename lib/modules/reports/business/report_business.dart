import 'package:mobx/mobx.dart';
import 'package:summarizeddebts/common/utility.dart';
import 'package:summarizeddebts/extensions/double_extensions.dart';
import 'package:summarizeddebts/extensions/string_extensions.dart';
import 'package:summarizeddebts/model/debt_detail_model.dart';
import 'package:summarizeddebts/model/expense_model.dart';
import 'package:summarizeddebts/model/monthly_expenses_model.dart';
import 'package:summarizeddebts/model/monthly_income_model.dart';
import 'package:summarizeddebts/model/summarized_expenses_model.dart';
import 'package:summarizeddebts/modules/debt/repository/api/debt_request.dart';
import 'package:summarizeddebts/modules/debt/repository/api/monthly_income_request.dart';
import 'package:summarizeddebts/modules/debt/repository/debt_repository.dart';
import 'package:summarizeddebts/modules/debt/repository/monthly_income_repository.dart';
import 'package:summarizeddebts/modules/reports/model/income_expenses_report_model.dart';
import 'package:summarizeddebts/modules/reports/model/report_expense_model.dart';
import 'package:summarizeddebts/modules/reports/model/year_report_model.dart';
import 'package:summarizeddebts/repositories/summary/summary_repository.dart';

class ReportBusiness {
  final DebtRepository _debtRepository;
  final SummaryRepository _summaryRepository;
  final MonthlyIncomeRepository monthlyIncomeRepository;

  ReportBusiness(this._debtRepository, this._summaryRepository,
      this.monthlyIncomeRepository);

  Future<DebtDetailModel> consultByMonth(String month) async {
    DebtRequest request = DebtRequest();
    request.debt = ExpenseModel()..month = month;

    //Get detail
    List<ExpenseModel> debts =
        await _debtRepository.consultDebtsByMonth(request);
    DebtDetailModel response = DebtDetailModel.init();
    response.month = request.debt.month;

    if (debts != null && debts.isNotEmpty) {
      debts.sort((a, b) => a.dueDate.compareTo(b.dueDate));

      response.debts = SummarizedExpensesModel();

      response.debts.items = debts;
    }

    //Get Summary
    MonthlyExpensesModel currentMonth =
        await this._summaryRepository.consultByMonth(month);

    DateTime monthDateTime = month.parseMonthYearToDateTime();

    DateTime lastDateTime = DateTime(
        monthDateTime.year, monthDateTime.month + -1, monthDateTime.day);

    MonthlyExpensesModel lastMonth = await this
        ._summaryRepository
        .consultByMonth(Utility.formatMonthYear(lastDateTime));
    response.totalDiffLastMonth = 0;
    response.percentageDiffLastMonth = 0;

    if (lastMonth != null && lastMonth.total > 0) {
      response.totalDiffLastMonth = currentMonth.total - lastMonth.total;
      response.percentageDiffLastMonth =
          ((response.totalDiffLastMonth / lastMonth.total) * 100)
              .roundTwoPlaces();
      response.isIncrease = true;

      if (response.percentageDiffLastMonth <= 0) {
        response.isIncrease = false;
        response.percentageDiffLastMonth *= -1;
      }
    }

    return response;
  }

  Future<YearReportModel> consultByYear(int year) async {
    DebtRequest request = DebtRequest();

    YearReportModel response = YearReportModel();

    ObservableList<ExpenseModel> items = ObservableList<ExpenseModel>.of([]);
    String searchMonth;
    ExpenseModel expenseModel;
    bool isPaid = false;
    double total = 0;
    for (int month = 1; month <= 12; month++) {
      searchMonth = Utility.formatMonthYear(DateTime(year, month, 1));

      request.debt = ExpenseModel()..month = searchMonth;

      MonthlyExpensesModel currentMonth =
          await this._summaryRepository.consultByMonth(searchMonth);

      List<ExpenseModel> debts =
          await _debtRepository.consultDebtsByMonth(request);

      if (debts != null && debts.isNotEmpty) {
        isPaid = debts.where((element) => !element.paid).toList().isEmpty;
      }

      expenseModel = ExpenseModel();
      expenseModel.month = searchMonth;
      expenseModel.amount = currentMonth == null ? 0.0 : currentMonth.total;
      expenseModel.paid = isPaid;

      total += expenseModel.amount;

      items.add(expenseModel);
    }

    response.total = total;
    response.items = items;
    response.chartData = ObservableList<SummarizedExpensesModel>();

    if (items != null && items.isNotEmpty) {
      for (ExpenseModel model in items) {
        response.chartData.add(
          SummarizedExpensesModel.chart(model.amount, model.month),
        );
      }
    }

    return response;
  }

  Future<DebtDetailModel> consultByStatus(String month, bool paid) async {
    DebtRequest request = DebtRequest();
    request.debt = ExpenseModel()..month = month;
    request.debt.paid = paid;

    //Get detail
    List<ExpenseModel> debts =
        await _debtRepository.consultDebtsByMonthStatus(request);
    DebtDetailModel response = DebtDetailModel.init();
    response.month = request.debt.month;

    if (debts != null && debts.isNotEmpty) {
      debts.sort((a, b) => a.dueDate.compareTo(b.dueDate));

      response.debts = SummarizedExpensesModel();

      response.debts.items = debts;

      response.totalMonth = debts.fold(0, (curr, next) => curr + next.amount);
    }

    return response;
  }

  Future<DebtDetailModel> consultByLocalToPay(
      String localToPayId, String month) async {
    DebtRequest request = DebtRequest();
    request.debt = ExpenseModel()..localToPayId = localToPayId;
    request.debt.month = month;
    List<ExpenseModel> debts;

    if (localToPayId == null || localToPayId.isEmpty) {
      debts = await _debtRepository.consultDebtsByMonth(request);
    } else {
      debts = await _debtRepository.getByLocalToPayAndMonth(request);
    }

    DebtDetailModel response = DebtDetailModel.init();
    response.month = request.debt.month;

    if (debts != null && debts.isNotEmpty) {
      debts.sort((a, b) => a.dueDate.compareTo(b.dueDate));

      response.debts = SummarizedExpensesModel();

      response.debts.items = debts;

      response.totalMonth = debts.fold(0, (curr, next) => curr + next.amount);
    }

    response.chartData = ObservableList<SummarizedExpensesModel>();

    if (debts != null && debts.isNotEmpty) {
      for (ExpenseModel model in debts) {
        response.chartData.add(
          SummarizedExpensesModel.chart(model.amount, model.localToPayName),
        );
      }
    }

    return response;
  }

  Future<IncomeExpensesReportModel> consultByIncomeExpenses(int year) async {
    DebtRequest request = DebtRequest();

    IncomeExpensesReportModel response = IncomeExpensesReportModel();

    ObservableList<ReportExpenseModel> items =
        ObservableList<ReportExpenseModel>.of([]);
    String searchMonth;
    ReportExpenseModel expenseModel;
    double balanceTotal = 0;
    double expensesTotal = 0;
    double total = 0;

    for (int month = 1; month <= 12; month++) {
      searchMonth = Utility.formatMonthYear(DateTime(year, month, 1));

      var monthlyModel = MonthlyIncomeModel()..month = searchMonth;

      MonthlyIncomeModel monthlyIncomeModel = await this
          .monthlyIncomeRepository
          .getByMonth(
              MonthlyIncomeRequest()..monthlyIncomeModel = monthlyModel);

      request.debt = ExpenseModel()..month = searchMonth;

      MonthlyExpensesModel currentMonth =
          await this._summaryRepository.consultByMonth(searchMonth);

      expenseModel = ReportExpenseModel();
      expenseModel.month = searchMonth;
      expenseModel.expenses = currentMonth == null ? 0.0 : currentMonth.total;
      expenseModel.income = 0.0;

      if (monthlyIncomeModel != null &&
          monthlyIncomeModel.id != null &&
          monthlyIncomeModel.id.isNotEmpty) {
        expenseModel.income = monthlyIncomeModel.amount;
      }

      expenseModel.balance = expenseModel.income - expenseModel.expenses;

      expenseModel.isPositive = expenseModel.balance >= 0;

      balanceTotal += expenseModel.income;
      expensesTotal += expenseModel.expenses;

      items.add(expenseModel);
    }

    total = balanceTotal - expensesTotal;

    response.total = total;
    response.balance = balanceTotal;
    response.expenses = expensesTotal;
    response.isPositive = response.total >= 0;

    response.items = items;

    return response;
  }
}
