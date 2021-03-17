import 'package:mobx/mobx.dart';
import 'package:summarizeddebts/common/utility.dart';
import 'package:summarizeddebts/controller/base/base_controller.dart';
import 'package:summarizeddebts/exceptions/alert_exception.dart';
import 'package:summarizeddebts/exceptions/error_exception.dart';
import 'package:summarizeddebts/model/debt_detail_model.dart';
import 'package:summarizeddebts/modules/reports/business/report_business.dart';

part 'report_by_month_controller.g.dart';

class ReportByMonthController = _ReportByMonthController
    with _$ReportByMonthController;

abstract class _ReportByMonthController extends BaseController with Store {
  final ReportBusiness _reportBusiness;
  @observable
  DebtDetailModel debtDetailModel = DebtDetailModel.init();

  @observable
  String filter = Utility.formatMonthYear(DateTime.now());

  _ReportByMonthController(this._reportBusiness);

  @action
  Future<void> consultByMonth() async {
    setState(ViewState.Busy);

    try {
      this.error = false;
      super.alert = false;
      this.customErrorMessage = null;

      this.debtDetailModel =
          await this._reportBusiness.consultByMonth(this.filter);
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
