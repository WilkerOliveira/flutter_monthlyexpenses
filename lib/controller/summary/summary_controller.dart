import 'package:mobx/mobx.dart';
import 'package:summarizeddebts/business/summary/summary_business.dart';
import 'package:summarizeddebts/controller/base/base_controller.dart';
import 'package:summarizeddebts/exceptions/error_exception.dart';
import 'package:summarizeddebts/model/monthly_expenses_model.dart';

part 'summary_controller.g.dart';

class SummaryController = SummaryBaseController with _$SummaryController;

abstract class SummaryBaseController extends BaseController with Store {
  final SummaryBusiness _summaryBusiness;

  @observable
  MonthlyExpensesModel monthlyExpensesModel = MonthlyExpensesModel.init("");

  SummaryBaseController(this._summaryBusiness);

  @action
  Future<void> loadSummary(String month) async {

    try {
      this.error = false;
      this.customErrorMessage = null;

      this.monthlyExpensesModel =
          await this._summaryBusiness.consultByMonth(month);
    } on ErrorException catch (ex) {
      super.error = true;
      super.customErrorMessage = ex.status;
    } catch (ex) {
      super.error = true;
      super.customErrorMessage = null;
    }
  }
}
