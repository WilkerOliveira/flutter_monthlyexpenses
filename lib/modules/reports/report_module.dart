import 'package:flutter_modular/flutter_modular.dart';
import 'package:summarizeddebts/modules/debt/business/debt_business.dart';
import 'package:summarizeddebts/modules/debt/repository/debt_repository.dart';
import 'package:summarizeddebts/modules/debt/repository/monthly_income_repository.dart';
import 'package:summarizeddebts/modules/reports/business/report_business.dart';
import 'package:summarizeddebts/modules/reports/controller/report_by_income_expenses_controller.dart';
import 'package:summarizeddebts/modules/reports/controller/report_by_local_to_pay_controller.dart';
import 'package:summarizeddebts/modules/reports/controller/report_by_month_controller.dart';
import 'package:summarizeddebts/modules/reports/controller/report_by_status_controller.dart';
import 'package:summarizeddebts/modules/reports/controller/report_by_year_controller.dart';
import 'package:summarizeddebts/modules/reports/screen/report_by_income_expenses_screen.dart';
import 'package:summarizeddebts/modules/reports/screen/report_by_local_to_pay_screen.dart';
import 'package:summarizeddebts/modules/reports/screen/report_by_month_screen.dart';
import 'package:summarizeddebts/modules/reports/screen/report_by_status_screen.dart';
import 'package:summarizeddebts/modules/reports/screen/report_by_year_screen.dart';
import 'package:summarizeddebts/repositories/summary/summary_repository.dart';

class ReportModule extends ChildModule {
  static const String initial = "/report";
  static const String byMonth = "/byMonth";
  static const String byYear = "/byYear";
  static const String byStatus = "/byStatus";
  static const String byPayment = "/byPayment";
  static const String byIncomeXExpenses = "/byIncomeXExpenses";

  @override
  List<Bind> get binds => [
        Bind((i) => ReportBusiness(i.get<DebtRepository>(),
            i.get<SummaryRepository>(), i.get<MonthlyIncomeRepository>())),
        Bind((i) => ReportByMonthController(i.get<ReportBusiness>())),
        Bind((i) => ReportByYearController(i.get<ReportBusiness>())),
        Bind((i) => ReportByStatusController(i.get<ReportBusiness>())),
        Bind((i) => ReportByLocalToPayController(
            i.get<ReportBusiness>(), i.get<DebtBusiness>())),
        Bind((i) => ReportByIncomeExpensesController(i.get<ReportBusiness>())),
      ];

  @override
  List<ModularRouter> get routers => [
    ModularRouter(byMonth, child: (_, args) => ReportByMonthScreen()),
    ModularRouter(byYear, child: (_, args) => ReportByYearScreen()),
    ModularRouter(byStatus, child: (_, args) => ReportByStatusScreen()),
    ModularRouter(byPayment, child: (_, args) => ReportByLocalToPayScreen()),
    ModularRouter(byIncomeXExpenses,
            child: (_, args) => ReportByIncomeExpensesScreen()),
      ];
}
