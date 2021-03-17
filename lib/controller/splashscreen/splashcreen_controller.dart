import 'package:summarizeddebts/business/splashscreen/splashscreen_business.dart';
import 'package:summarizeddebts/controller/base/base_controller.dart';

class SplashScreenController extends BaseController {
  final SplashScreenBusiness _screenBusiness;

  SplashScreenController(this._screenBusiness);

  Future<bool> isLoggedInUser() async {
    try {
      return await this._screenBusiness.isUserLoggedIn();
    } catch (ex) {
      return false;
    }
  }
}
