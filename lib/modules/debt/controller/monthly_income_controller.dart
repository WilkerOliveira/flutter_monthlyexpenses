import 'package:mobx/mobx.dart';
import 'package:summarizeddebts/controller/base/base_controller.dart';
import 'package:summarizeddebts/exceptions/error_exception.dart';
import 'package:summarizeddebts/model/monthly_income_model.dart';
import 'package:summarizeddebts/modules/debt/business/monthly_income_business.dart';

part 'monthly_income_controller.g.dart';

class MonthlyIncomeController = MonthlyIncomeBaseController
    with _$MonthlyIncomeController;

abstract class MonthlyIncomeBaseController extends BaseController with Store {
  final MonthlyIncomeBusiness _business;

  @observable
  ObservableList<MonthlyIncomeModel> items = ObservableList.of([]);

  MonthlyIncomeBaseController(this._business);

  @action
  Future<void> consult() async {
    setState(ViewState.Busy);
    try {
      this.error = false;
      this.customErrorMessage = null;

      var response = await _business.consult();
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

  Future<void> save(MonthlyIncomeModel model) async {
    setState(ViewState.Busy);

    try {
      this.error = false;
      this.customErrorMessage = null;

      await this._business.save(model);

      consult();
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

  Future<void> delete(int index) async {
    setState(ViewState.Busy);

    try {
      this.error = false;
      this.customErrorMessage = null;

      await this._business.delete(this.items[index]);

      consult();
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
