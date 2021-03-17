import 'package:mobx/mobx.dart';
import 'package:summarizeddebts/controller/base/base_controller.dart';
import 'package:summarizeddebts/exceptions/alert_exception.dart';
import 'package:summarizeddebts/exceptions/error_exception.dart';
import 'package:summarizeddebts/model/user_model.dart';
import 'package:summarizeddebts/modules/config/business/update_password_business.dart';

part 'update_password_controller.g.dart';

class UpdatePasswordController = UpdatePasswordBaseController with _$UpdatePasswordController;

abstract class UpdatePasswordBaseController extends BaseController  with Store {
  final UpdatePasswordBusiness _business;
  @observable
  bool _isCustomLogin;

  bool get isCustomLogin => this._isCustomLogin;
  UserModel userModel = UserModel();

  UpdatePasswordBaseController(this._business);

  Future<void> updatePassword() async {
    setState(ViewState.Busy);

    try {
      super.error = false;
      super.alert = false;
      super.customErrorMessage = null;

      await this._business.updatePassword(userModel);
    } on AlertException catch (ex) {
      super.alert = true;
      super.error = false;
      super.customErrorMessage = ex.message;
      return null;
    } on ErrorException catch (ex) {
      super.error = true;
      super.customErrorMessage = ex.status;
      return null;
    } on Exception catch (ex) {
      super.error = true;
      super.customErrorMessage = null;
      return null;
    } finally {
      setState(ViewState.Idle);
    }
  }

  @action
  Future<void> checkCustomLogin() async {
    setState(ViewState.Busy);

    try {
      this._isCustomLogin = await this._business.isCustomLogin();
    } on Exception catch (ex) {
      super.error = true;
      super.customErrorMessage = null;
      return null;
    } finally {
      setState(ViewState.Idle);
    }
  }
}
