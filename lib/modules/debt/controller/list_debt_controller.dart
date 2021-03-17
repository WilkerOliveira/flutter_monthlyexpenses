import 'package:mobx/mobx.dart';
import 'package:summarizeddebts/controller/base/base_controller.dart';
import 'package:summarizeddebts/exceptions/alert_exception.dart';
import 'package:summarizeddebts/exceptions/error_exception.dart';
import 'package:summarizeddebts/model/expense_model.dart';
import 'package:summarizeddebts/modules/debt/business/debt_business.dart';

part 'list_debt_controller.g.dart';

class ListDebtController = ListDebtBaseController with _$ListDebtController;

abstract class ListDebtBaseController extends BaseController with Store {
  final DebtBusiness _debtBusiness;
  @observable
  ObservableList<ExpenseModel> items = ObservableList.of([]);

  ListDebtBaseController(this._debtBusiness);

  @action
  Future<void> loadAll() async {
    setState(ViewState.Busy);
    try {
      this.error = false;
      this.customErrorMessage = null;

      var response = await _debtBusiness.loadAll();

      if (response != null) this.items = response.asObservable();
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
  Future<void> payAll() async {
    setState(ViewState.Busy);

    try {
      this.error = false;
      this.alert = false;
      this.customErrorMessage = null;

      await _debtBusiness.payAll(this.items.toList());
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

  Future<void> delete() async {
    setState(ViewState.Busy);

    try {
      this.error = false;
      this.alert = false;
      this.customErrorMessage = null;

      await _debtBusiness.deleteAll(this.items.toList());
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

}
