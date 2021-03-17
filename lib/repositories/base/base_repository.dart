import 'package:flutter/foundation.dart';
import 'package:summarizeddebts/exceptions/error_exception.dart';
import 'package:summarizeddebts/exceptions/exception_messages.dart';
import 'package:summarizeddebts/model/user_model.dart';
import 'package:summarizeddebts/repositories/database/local_db.dart';
import 'package:summarizeddebts/repositories/util/connectivity.dart';

abstract class BaseRepository {
  static final facebookLogin = "FACEBOOK";
  static final googleLogin = "GOOGLE";
  static final customLogin = "CUSTOM";

  Future<void> checkInternetConnection() async {
    if (!await Connectivity.hasInternetConnection()) {
      throw ErrorException.withCode(
          null, ExceptionMessages.noInternetConnection);
    }
  }

  @protected
  void saveUserDB(UserModel user) {
    LocalDB().saveUser(user);
  }

  Future<UserModel> getDbUser() async => await LocalDB().fetchUserData();

  Future<bool> isCustomLogin() async =>
      (await getDbUser()).customLogin == customLogin;
}
