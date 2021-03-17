import 'package:flutter_modular/flutter_modular.dart';
import 'package:summarizeddebts/modules/config/business/update_password_business.dart';
import 'package:summarizeddebts/modules/config/controller/update_password_controller.dart';
import 'package:summarizeddebts/modules/config/repository/api/update_password_api.dart';
import 'package:summarizeddebts/modules/config/repository/update_password_repository.dart';
import 'package:summarizeddebts/modules/config/screen/update_password_screen.dart';

class ConfigModule extends ChildModule {
  static const String initial = "/config";
  static const String changePassword = "/changePassword";

  @override
  List<Bind> get binds => [
        Bind((i) => UpdatePasswordApi()),
        Bind((i) => UpdatePasswordRepository(i.get<UpdatePasswordApi>())),
        Bind((i) => UpdatePasswordBusiness(i.get<UpdatePasswordRepository>())),
        Bind((i) => UpdatePasswordController(i.get<UpdatePasswordBusiness>())),
      ];

  @override
  List<ModularRouter> get routers => [
    ModularRouter(changePassword, child: (_, args) => UpdatePasswordScreen()),
      ];
}
