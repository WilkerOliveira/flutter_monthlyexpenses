import 'package:mobx/mobx.dart';
import 'package:summarizeddebts/controller/base/base_controller.dart';
import 'package:summarizeddebts/exceptions/alert_exception.dart';
import 'package:summarizeddebts/exceptions/error_exception.dart';
import 'package:summarizeddebts/modules/reports/business/report_business.dart';
import 'package:summarizeddebts/modules/reports/model/year_report_model.dart';

part 'report_by_year_controller.g.dart';

class ReportByYearController = _ReportByYearController
    with _$ReportByYearController;

abstract class _ReportByYearController extends BaseController with Store {
  final ReportBusiness _reportBusiness;
  @observable
  YearReportModel reportModel = YearReportModel();

  @observable
  String filter = DateTime.now().year.toString();

  _ReportByYearController(this._reportBusiness);

  @action
  Future<void> consultByYear() async {
    setState(ViewState.Busy);

    try {
      this.error = false;
      super.alert = false;
      this.customErrorMessage = null;

      this.reportModel =
          await this._reportBusiness.consultByYear(int.parse(this.filter));
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
