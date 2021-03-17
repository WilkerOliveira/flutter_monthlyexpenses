import 'package:flutter/services.dart';
import 'package:summarizeddebts/exceptions/alert_exception.dart';
import 'package:summarizeddebts/exceptions/error_exception.dart';
import 'package:summarizeddebts/exceptions/exception_messages.dart';
import 'package:summarizeddebts/model/user_model.dart';
import 'package:summarizeddebts/modules/config/repository/api/update_password_request.dart';
import 'package:summarizeddebts/modules/config/repository/update_password_repository.dart';

class UpdatePasswordBusiness {
  final UpdatePasswordRepository _repository;

  UpdatePasswordBusiness(this._repository);

  Future<void> updatePassword(UserModel userModel) async {
    try {
      UpdatePasswordRequest request = UpdatePasswordRequest();
      request.userModel = userModel;

      await this._repository.updatePassword(request);
    } on PlatformException catch (ex) {
      if (ex.code == "ERROR_WRONG_PASSWORD") {
        throw AlertException(message: ExceptionMessages.invalidPassword);
      } else {
        throw ErrorException.withStatus(ExceptionMessages.error);
      }
    }
  }

  Future<bool> isCustomLogin() async => await _repository.isCustomLogin();
}
