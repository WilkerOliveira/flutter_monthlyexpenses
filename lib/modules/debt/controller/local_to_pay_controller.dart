import 'package:mobx/mobx.dart';
import 'package:summarizeddebts/controller/base/base_controller.dart';
import 'package:summarizeddebts/exceptions/error_exception.dart';
import 'package:summarizeddebts/model/local_to_pay_model.dart';
import 'package:summarizeddebts/modules/debt/business/local_to_pay_business.dart';

part 'local_to_pay_controller.g.dart';

class LocalToPayController = LocalToPayBaseController
    with _$LocalToPayController;

abstract class LocalToPayBaseController extends BaseController with Store {
  final LocalToPayBusiness _business;

  @observable
  ObservableList<LocalToPayModel> items = ObservableList.of([]);

  LocalToPayBaseController(this._business);

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

  Future<void> save(LocalToPayModel model) async {
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
