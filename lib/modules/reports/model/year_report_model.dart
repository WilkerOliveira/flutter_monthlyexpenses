import 'package:mobx/mobx.dart';
import 'package:summarizeddebts/model/expense_model.dart';
import 'package:summarizeddebts/model/summarized_expenses_model.dart';

part 'year_report_model.g.dart';

class YearReportModel = _YearReportModel with _$YearReportModel;

abstract class _YearReportModel with Store {
  @observable
  double total;

  @observable
  ObservableList<ExpenseModel> items;

  ObservableList<SummarizedExpensesModel> chartData;

  _YearReportModel() {
    total = 0;
  }
}
