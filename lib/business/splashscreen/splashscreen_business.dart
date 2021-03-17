import 'package:summarizeddebts/modules/login/repository/login_repository.dart';

class SplashScreenBusiness {
  final LoginRepository _loginRepository;

  SplashScreenBusiness(this._loginRepository);

  Future<bool> isUserLoggedIn() async {
    var user = await this._loginRepository.mountUser(null, null);

    return user != null && user.userID != null && user.userID.isNotEmpty;
  }
}
