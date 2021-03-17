import 'package:mobx/mobx.dart';
import 'package:summarizeddebts/controller/base/base_controller.dart';
import 'package:summarizeddebts/exceptions/alert_exception.dart';
import 'package:summarizeddebts/exceptions/error_exception.dart';
import 'package:summarizeddebts/modules/reports/business/report_business.dart';
import 'package:summarizeddebts/modules/reports/model/income_expenses_report_model.dart';
import 'package:summarizeddebts/modules/reports/model/year_report_model.dart';

part 'report_by_income_expenses_controller.g.dart';

class ReportByIncomeExpensesController = _ReportByIncomeExpensesController
    with _$ReportByIncomeExpensesController;

abstract class _ReportByIncomeExpensesController extends BaseController with Store {
  final ReportBusiness _reportBusiness;
  @observable
  IncomeExpensesReportModel reportModel = IncomeExpensesReportModel();

  @observable
  String filter = DateTime.now().year.toString();

  _ReportByIncomeExpensesController(this._reportBusiness);

  @action
  Future<void> consultByYear() async {
    setState(ViewState.Busy);

    try {
      this.error = false;
      super.alert = false;
      this.customErrorMessage = null;

      this.reportModel =
          await this._reportBusiness.consultByIncomeExpenses(int.parse(this.filter));
    } on AlertException catch (ex) {
      super.error = false;
      super.alert = true;
      super.customErrorMessage = ex.message;
    } on ErrorException catch (ex) {
      super.error = true;
      super.customErrorMessage = ex.status;
    } catch (ex) {
      super.error = true;
      super.customErrorMessage = null;
    } finally {
      setState(ViewState.Idle);
    }
  }
}
