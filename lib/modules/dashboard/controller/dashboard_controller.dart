import 'package:mobx/mobx.dart';
import 'package:summarizeddebts/controller/base/base_controller.dart';
import 'package:summarizeddebts/exceptions/error_exception.dart';
import 'package:summarizeddebts/model/debt_detail_model.dart';
import 'package:summarizeddebts/model/summarized_expenses_model.dart';
import 'package:summarizeddebts/modules/dashboard/business/dashboard_business.dart';

part 'dashboard_controller.g.dart';

class DashboardController = DashboardBaseController with _$DashboardController;

abstract class DashboardBaseController extends BaseControllerBase with Store {
  final DashboardBusiness _business;

  @observable
  DebtDetailModel dashboardModel = DebtDetailModel.init();

  @observable
  List<SummarizedExpensesModel> dataChart = [];
  DateTime currentMonth = DateTime.now();

  DashboardBaseController(this._business);

  @action
  Future<void> consultDashboard() async {
    setState(ViewState.Busy);

    try {
      this.error = false;
      this.customErrorMessage = null;

      //async
      this.getDataChart();

      this.dashboardModel =
          await _business.consultDebtsByMonthV2(this.currentMonth);
    } on ErrorException catch (ex) {
      super.error = true;
      super.customErrorMessage = ex.status;
      return null;
    } catch (ex) {
      super.error = true;
      super.customErrorMessage = null;
      return null;
    } finally {
      setState(ViewState.Idle);
    }
  }

  @action
  Future<void> getDataChart() async {
    setSecondState(ViewState.Busy);

    try {
      this.error = false;
      this.customErrorMessage = null;

      var response = await _business.getDataChart(this.currentMonth);
      if (response != null && response.dataChart != null)
        dataChart = response.dataChart;
    } on ErrorException catch (ex) {
      super.error = true;
      super.customErrorMessage = ex.status;
      return null;
    } catch (ex) {
      super.error = true;
      super.customErrorMessage = null;
      return null;
    } finally {
      setSecondState(ViewState.Idle);
    }
  }

  getPreviousMonth() {
    this.currentMonth = DateTime(this.currentMonth.year,
        this.currentMonth.month - 1, this.currentMonth.day);
  }

  getNextMonth() {
    this.currentMonth = DateTime(this.currentMonth.year,
        this.currentMonth.month + 1, this.currentMonth.day);
  }
}
