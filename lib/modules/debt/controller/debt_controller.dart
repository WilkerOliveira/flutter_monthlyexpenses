import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:summarizeddebts/controller/base/base_controller.dart';
import 'package:summarizeddebts/exceptions/alert_exception.dart';
import 'package:summarizeddebts/exceptions/error_exception.dart';
import 'package:summarizeddebts/model/expense_model.dart';
import 'package:summarizeddebts/model/local_to_pay_model.dart';
import 'package:summarizeddebts/modules/dashboard/controller/dashboard_controller.dart';
import 'package:summarizeddebts/modules/debt/business/debt_business.dart';
import 'package:summarizeddebts/modules/debt/controller/list_debt_controller.dart';

part 'debt_controller.g.dart';

class DebtController = DebtBaseController with _$DebtController;

abstract class DebtBaseController extends BaseController with Store {
  final DebtBusiness _debtBusiness;
  ExpenseModel currentExpense = ExpenseModel();
  @observable
  ObservableList<LocalToPayModel> localToPayList = ObservableList.of([]);
  @observable
  bool isRecurringExpense = false;

  DebtBaseController(this._debtBusiness);

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

  Future<void> save() async {
    setState(ViewState.Busy);

    try {
      this.error = false;
      this.alert = false;
      this.customErrorMessage = null;

      await this._debtBusiness.save(this.currentExpense);

      var dashboardController = Modular.get<DashboardController>();
      if (dashboardController != null) dashboardController.consultDashboard();

      var listDebtController = Modular.get<ListDebtController>();
      if (listDebtController != null) listDebtController.loadAll();
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

  Future<void> delete() async {
    setState(ViewState.Busy);

    try {
      this.error = false;
      this.customErrorMessage = null;

      await this._debtBusiness.delete(this.currentExpense);
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
  Future<void> getById(String id) async {
    setState(ViewState.Busy);

    try {
      this.error = false;
      this.customErrorMessage = null;

      this.currentExpense = await _debtBusiness.getById(id);

      this.isRecurringExpense = this.currentExpense.mainExpenseId != null &&
          this.currentExpense.mainExpenseId.isNotEmpty;

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

  String getLocalToPayName(localToPayId) {
    return this
        .localToPayList
        .where((element) => element.id == localToPayId)
        .first
        .description;
  }
}
