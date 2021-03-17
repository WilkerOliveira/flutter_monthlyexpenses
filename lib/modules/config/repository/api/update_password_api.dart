import 'package:firebase_auth/firebase_auth.dart';
import 'package:summarizeddebts/modules/config/repository/api/update_password_request.dart';
import 'package:summarizeddebts/repositories/api/base_api.dart';

class UpdatePasswordApi extends BaseApi {
  Future<void> updatePassword(UpdatePasswordRequest request) async {
    var currentFBUser = await super.getCurrentFirebaseUser();

    var currentUser = await this
        ._reauthenticate(currentFBUser.email, request.userModel.oldPassword);

    return await currentUser.updatePassword(request.userModel.password);
  }

  Future<FirebaseUser> _reauthenticate(String email, String password) async {
    var current = await getCurrentFirebaseUser();

    AuthCredential credential =
        EmailAuthProvider.getCredential(email: email, password: password);

    var result = await current.reauthenticateWithCredential(credential);

    return result.user;
  }
}
