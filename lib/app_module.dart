import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:summarizeddebts/app_widget.dart';
import 'package:summarizeddebts/business/splashscreen/splashscreen_business.dart';
import 'package:summarizeddebts/business/summary/summary_business.dart';
import 'package:summarizeddebts/controller/splashscreen/splashcreen_controller.dart';
import 'package:summarizeddebts/controller/summary/summary_controller.dart';
import 'package:summarizeddebts/modules/config/business/config_business.dart';
import 'package:summarizeddebts/modules/config/config_module.dart';
import 'package:summarizeddebts/modules/config/controller/config_controller.dart';
import 'package:summarizeddebts/modules/config/repository/config_repository.dart';
import 'package:summarizeddebts/modules/dashboard/business/dashboard_business.dart';
import 'package:summarizeddebts/modules/dashboard/controller/dashboard_controller.dart';
import 'package:summarizeddebts/modules/dashboard/repository/api/dashboard_api.dart';
import 'package:summarizeddebts/modules/dashboard/repository/dashboard_repository.dart';
import 'package:summarizeddebts/modules/dashboard/screen/dashboard_screen.dart';
import 'package:summarizeddebts/modules/debt/business/debt_business.dart';
import 'package:summarizeddebts/modules/debt/controller/debt_detail_controller.dart';
import 'package:summarizeddebts/modules/debt/controller/list_debt_controller.dart';
import 'package:summarizeddebts/modules/debt/debt_module.dart';
import 'package:summarizeddebts/modules/debt/repository/api/debt_api.dart';
import 'package:summarizeddebts/modules/debt/repository/api/local_to_pay_api.dart';
import 'package:summarizeddebts/modules/debt/repository/api/monthly_income_api.dart';
import 'package:summarizeddebts/modules/debt/repository/debt_repository.dart';
import 'package:summarizeddebts/modules/debt/repository/local_to_pay_repository.dart';
import 'package:summarizeddebts/modules/debt/repository/monthly_income_repository.dart';
import 'package:summarizeddebts/modules/debt/screen/debt_detail_screen.dart';
import 'package:summarizeddebts/modules/debt/screen/edit_debt_screen.dart';
import 'package:summarizeddebts/modules/login/login_module.dart';
import 'package:summarizeddebts/modules/login/repository/api/login_api.dart';
import 'package:summarizeddebts/modules/login/repository/login_repository.dart';
import 'package:summarizeddebts/modules/reports/report_module.dart';
import 'package:summarizeddebts/repositories/summary/api/summary_api.dart';
import 'package:summarizeddebts/repositories/summary/summary_repository.dart';
import 'package:summarizeddebts/ui/screen/home/home_screen.dart';
import 'package:summarizeddebts/ui/screen/splash_screen.dart';
import 'package:summarizeddebts/ui/utility/routers.dart';

class AppModule extends MainModule {
  @override
  List<Bind> get binds => [
        Bind((i) => LoginApi()),
        Bind((i) => LoginRepository(i.get<LoginApi>())),
        Bind((i) => SplashScreenBusiness(i.get<LoginRepository>())),
        Bind((i) => SplashScreenController(i.get<SplashScreenBusiness>())),
        Bind((i) => MonthlyIncomeApi()),
        Bind((i) => MonthlyIncomeRepository(i.get<MonthlyIncomeApi>())),
        Bind((i) => DashboardApi()),
        Bind((i) => DashboardRepository(i.get<DashboardApi>())),
        Bind((i) => DashboardBusiness(
              dashboardRepository: i.get<DashboardRepository>(),
              monthlyIncomeRepository: i.get<MonthlyIncomeRepository>(),
            )),
        Bind((i) => DashboardController(i.get<DashboardBusiness>())),
        Bind((i) => SummaryApi()),
        Bind((i) => SummaryRepository(i.get<SummaryApi>())),
        Bind((i) => SummaryBusiness(
            i.get<SummaryRepository>(), i.get<MonthlyIncomeRepository>())),
        Bind((i) => SummaryController(i.get<SummaryBusiness>())),
        Bind((i) => LocalToPayApi()),
        Bind((i) => LocalToPayRepository(i.get<LocalToPayApi>())),
        Bind((i) => DebtApi()),
        Bind((i) => DebtRepository(i.get<DebtApi>())),
        Bind((i) => DebtBusiness(
            i.get<DebtRepository>(), i.get<LocalToPayRepository>())),
        Bind((i) => DebtDetailController(i.get<DebtBusiness>())),
        Bind((i) => ListDebtController(i.get<DebtBusiness>())),
        Bind((i) => ConfigRepository()),
        Bind((i) => ConfigBusiness(i.get<ConfigRepository>())),
        Bind((i) => ConfigController(i.get<ConfigBusiness>())),
      ];

  @override
  Widget get bootstrap => AppWidget();

  @override
  List<ModularRouter> get routers => [
    ModularRouter(Routers.initial, child: (_, args) => SplashScreen()),
    ModularRouter(Routers.home, child: (_, args) => HomeScreen()),
    ModularRouter(Routers.dashboard, child: (_, args) => DashboardScreen()),
    ModularRouter(LoginModule.initial, module: LoginModule()),
    ModularRouter(DebtModule.initial, module: DebtModule()),
    ModularRouter(DebtModule.detailDebt,
            child: (_, args) => DebtDetailScreen(currentMonth: args.data)),
    ModularRouter(DebtModule.editDebt,
            child: (_, args) => EditDebtScreen(currentMonth: args.data)),
    ModularRouter(ConfigModule.initial, module: ConfigModule()),
    ModularRouter(ReportModule.initial, module: ReportModule()),
      ];
}
