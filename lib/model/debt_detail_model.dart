import 'package:mobx/mobx.dart';
import 'package:summarizeddebts/model/summarized_expenses_model.dart';

part 'debt_detail_model.g.dart';

class DebtDetailModel = DebtDetailBaseModel with _$DebtDetailModel;

abstract class DebtDetailBaseModel with Store {
  @observable
  String month;
  @observable
  double totalMonth;

  @observable
  double monthlyIncome;

  @observable
  SummarizedExpensesModel debts;

  @observable
  ObservableList<SummarizedExpensesModel> dataChart;

  @observable
  double totalDiffLastMonth;
  @observable
  double percentageDiffLastMonth;
  @observable
  bool isIncrease;

  ObservableList<SummarizedExpensesModel> chartData;

  DebtDetailBaseModel();

  DebtDetailBaseModel.init() {
    month = DateTime.now().month.toString();
    totalMonth = 0;
    dataChart = ObservableList.of([]);
    debts = SummarizedExpensesModel.init(false);
    totalDiffLastMonth = 0;
    percentageDiffLastMonth = 0;
    isIncrease = true;
    monthlyIncome = 0;
  }
}
