import 'dart:async';

import 'package:mobx/mobx.dart';
import 'package:summarizeddebts/controller/base/base_controller.dart';
import 'package:summarizeddebts/exceptions/error_exception.dart';
import 'package:summarizeddebts/model/user_model.dart';
import 'package:summarizeddebts/modules/login/repository/api/login_request.dart';
import 'package:summarizeddebts/modules/login/repository/login_repository.dart';

part 'register_controller.g.dart';

class RegisterController = RegisterControllerBase with _$RegisterController;


abstract class RegisterControllerBase  extends BaseController with Store  {
  final LoginRepository _loginRepository;

  RegisterControllerBase(this._loginRepository);

  @action
  Future<UserModel> registerNewUser(UserModel newUser) async {
    setState(ViewState.Busy);

    try {
      super.error = false;
      super.customErrorMessage = null;

      LoginRequest request = LoginRequest(newUser);

      await _loginRepository.signUp(request);

      return newUser;
    } on ErrorException catch (ex) {
      super.error = false;
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
