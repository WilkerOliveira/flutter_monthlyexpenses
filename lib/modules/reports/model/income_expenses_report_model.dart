import 'package:mobx/mobx.dart';
import 'package:summarizeddebts/model/expense_model.dart';
import 'package:summarizeddebts/model/summarized_expenses_model.dart';
import 'package:summarizeddebts/modules/reports/model/report_expense_model.dart';

part 'income_expenses_report_model.g.dart';

class IncomeExpensesReportModel = _IncomeExpensesReportModel with _$IncomeExpensesReportModel;

abstract class _IncomeExpensesReportModel with Store {
  @observable
  double total;
  @observable
  double balance;
  @observable
  double expenses;
  @observable
  bool isPositive;

  @observable
  ObservableList<ReportExpenseModel> items;

  _IncomeExpensesReportModel() {
    total = 0;
    balance = 0;
    expenses = 0;
    isPositive = false;
  }
}
