import 'package:flutter_modular/flutter_modular.dart';
import 'package:summarizeddebts/modules/debt/business/debt_business.dart';
import 'package:summarizeddebts/modules/debt/business/local_to_pay_business.dart';
import 'package:summarizeddebts/modules/debt/business/monthly_income_business.dart';
import 'package:summarizeddebts/modules/debt/controller/debt_controller.dart';
import 'package:summarizeddebts/modules/debt/controller/local_to_pay_controller.dart';
import 'package:summarizeddebts/modules/debt/controller/monthly_income_controller.dart';
import 'package:summarizeddebts/modules/debt/repository/debt_repository.dart';
import 'package:summarizeddebts/modules/debt/repository/local_to_pay_repository.dart';
import 'package:summarizeddebts/modules/debt/repository/monthly_income_repository.dart';
import 'package:summarizeddebts/modules/debt/screen/local_to_pay_screen.dart';
import 'package:summarizeddebts/modules/debt/screen/monthy_income_screen.dart';
import 'package:summarizeddebts/modules/debt/screen/register_debt_screen.dart';

class DebtModule extends ChildModule {
  static const String initial = "/registers";
  static const String newDebt = "/newDebt";

  static const String localToPay = "/localToPay";
  static const String monthlyIncome = "/monthlyIncome";
  static const String detailDebt = "/detailDebt";
  static const String editDebt = "/editDebt";

  @override
  List<Bind> get binds => [
        Bind((i) => LocalToPayBusiness(
            i.get<LocalToPayRepository>(), i.get<DebtRepository>())),
        Bind((i) => MonthlyIncomeBusiness(i.get<MonthlyIncomeRepository>())),
        Bind((i) => LocalToPayController(i.get<LocalToPayBusiness>())),
        Bind((i) => MonthlyIncomeController(i.get<MonthlyIncomeBusiness>())),
        Bind((i) => DebtController(i.get<DebtBusiness>())),
      ];

  @override
  List<ModularRouter> get routers => [
    ModularRouter(localToPay, child: (_, args) => LocalToPayScreen()),
    ModularRouter(monthlyIncome, child: (_, args) => MonthlyIncomeScreen()),
    ModularRouter(newDebt,
            child: (_, args) => RegisterDebtScreen(
                  registerId: args.data,
                )),
      ];
}
