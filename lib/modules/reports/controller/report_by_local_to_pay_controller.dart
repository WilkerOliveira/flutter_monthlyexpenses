import 'package:mobx/mobx.dart';
import 'package:summarizeddebts/common/utility.dart';
import 'package:summarizeddebts/controller/base/base_controller.dart';
import 'package:summarizeddebts/exceptions/alert_exception.dart';
import 'package:summarizeddebts/exceptions/error_exception.dart';
import 'package:summarizeddebts/model/debt_detail_model.dart';
import 'package:summarizeddebts/model/local_to_pay_model.dart';
import 'package:summarizeddebts/modules/debt/business/debt_business.dart';
import 'package:summarizeddebts/modules/reports/business/report_business.dart';

part 'report_by_local_to_pay_controller.g.dart';

class ReportByLocalToPayController = _ReportByLocalToPayController
    with _$ReportByLocalToPayController;

abstract class _ReportByLocalToPayController extends BaseController with Store {
  final ReportBusiness _reportBusiness;
  final DebtBusiness _debtBusiness;

  @observable
  DebtDetailModel debtDetailModel = DebtDetailModel.init();
  ObservableList<LocalToPayModel> localToPayList = ObservableList.of([]);
  @observable
  String localToPayFilter = "";
  @observable
  String monthFilter = Utility.formatMonthYear(DateTime.now());

  _ReportByLocalToPayController(this._reportBusiness, this._debtBusiness);

  @action
  Future<void> consultLocalToPay() async {
    setState(ViewState.Busy);

    try {
      this.error = false;
      super.alert = false;

      this.customErrorMessage = null;

      List<LocalToPayModel> response =
          await this._debtBusiness.consultLocalToPay();
      localToPayList.clear();
      localToPayList.addAll(response);
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
  Future<void> consultByLocalToPay() async {
    setState(ViewState.Busy);

    try {
      this.error = false;
      super.alert = false;
      this.customErrorMessage = null;

      this.debtDetailModel = await this
          ._reportBusiness
          .consultByLocalToPay(this.localToPayFilter, this.monthFilter);
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
