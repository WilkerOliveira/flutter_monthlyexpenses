import 'package:mobx/mobx.dart';
import 'package:summarizeddebts/controller/base/base_controller.dart';
import 'package:summarizeddebts/exceptions/alert_exception.dart';
import 'package:summarizeddebts/exceptions/error_exception.dart';
import 'package:summarizeddebts/model/debt_detail_model.dart';
import 'package:summarizeddebts/modules/debt/business/debt_business.dart';

part 'debt_detail_controller.g.dart';

class DebtDetailController = DebtDetailBaseController
    with _$DebtDetailController;

abstract class DebtDetailBaseController extends BaseControllerBase with Store {
  final DebtBusiness _business;

  @observable
  DebtDetailModel debtDetailModel = DebtDetailModel.init();

  DebtDetailBaseController(this._business);

  @action
  Future<void> loadDebt(DateTime month) async {
    setState(ViewState.Busy);

    try {
      this.error = false;
      this.customErrorMessage = null;

      debtDetailModel = await _business.consultDebtsByMonthV2(month);
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
  Future<void> payDebts() async {
    setState(ViewState.Busy);

    try {
      this.error = false;
      this.alert = false;
      this.customErrorMessage = null;

      await _business.doPayment(this.debtDetailModel);
    } on AlertException catch (ex) {
      super.alert = true;
      super.customErrorMessage = ex.message;
      return null;
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
  Future<void> reopenDebts() async {
    setState(ViewState.Busy);

    try {
      this.error = false;
      this.alert = false;
      this.customErrorMessage = null;

      await _business.doReopen(this.debtDetailModel);
    } on AlertException catch (ex) {
      super.alert = true;
      super.customErrorMessage = ex.message;
      return null;
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
  Future<void> deleteDebts() async {
    setState(ViewState.Busy);

    try {
      this.error = false;
      this.alert = false;
      this.customErrorMessage = null;

      await _business.doDelete(this.debtDetailModel);
    } on AlertException catch (ex) {
      super.alert = true;
      super.customErrorMessage = ex.message;
      return null;
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
  selectUnSelectAll(selectAll) {
    this.debtDetailModel.debts.items.forEach((element) {
      element.isSelected.value = selectAll;
    });
  }
}
