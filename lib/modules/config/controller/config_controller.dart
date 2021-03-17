import 'package:summarizeddebts/controller/base/base_controller.dart';
import 'package:summarizeddebts/modules/config/business/config_business.dart';

class ConfigController extends BaseController {
  final ConfigBusiness _business;

  ConfigController(this._business);

  Future<void> signOut() {
    return this._business.signOut();
  }
}
