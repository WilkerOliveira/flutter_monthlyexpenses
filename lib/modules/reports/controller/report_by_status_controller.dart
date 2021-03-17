import 'package:mobx/mobx.dart';
import 'package:summarizeddebts/common/utility.dart';
import 'package:summarizeddebts/controller/base/base_controller.dart';
import 'package:summarizeddebts/exceptions/alert_exception.dart';
import 'package:summarizeddebts/exceptions/error_exception.dart';
import 'package:summarizeddebts/model/debt_detail_model.dart';
import 'package:summarizeddebts/modules/reports/business/report_business.dart';

part 'report_by_status_controller.g.dart';

enum StatusReport { paid, notPaid }

class ReportByStatusController = _ReportByStatusController
    with _$ReportByStatusController;

abstract class _ReportByStatusController extends BaseController with Store {
  final ReportBusiness _reportBusiness;
  @observable
  DebtDetailModel debtDetailModel = DebtDetailModel.init();

  @observable
  String filter = Utility.formatMonthYear(DateTime.now());
  @observable
  bool paid = true;

  _ReportByStatusController(this._reportBusiness);

  @action
  Future<void> consultByStatus() async {
    setState(ViewState.Busy);

    try {
      this.error = false;
      super.alert = false;
      this.customErrorMessage = null;

      this.debtDetailModel =
          await this._reportBusiness.consultByStatus(this.filter, this.paid);

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

  @action
  setStatus(StatusReport statusReport) {
    this.paid = statusReport == StatusReport.paid;
  }
}
