import 'package:flutter_modular/flutter_modular.dart';
import 'package:summarizeddebts/modules/login/controller/login_controller.dart';
import 'package:summarizeddebts/modules/login/controller/register_controller.dart';
import 'package:summarizeddebts/modules/login/repository/login_repository.dart';
import 'package:summarizeddebts/modules/login/screen/login_screen.dart';
import 'package:summarizeddebts/modules/login/screen/register_screen.dart';

class LoginModule extends ChildModule {
  static const String initial = "/login";
  static const String login = "/sigin";
  static const String signUp = "/newRegister";

  @override
  List<Bind> get binds => [
        Bind((i) => LoginController(i.get<LoginRepository>())),
        Bind((i) => RegisterController(i.get<LoginRepository>())),
      ];

  @override
  List<ModularRouter> get routers => [
    ModularRouter(login, child: (_, args) => LoginScreen()),
    ModularRouter(signUp, child: (_, args) => RegisterScreen()),
      ];
}
