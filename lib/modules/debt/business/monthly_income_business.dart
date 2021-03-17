import 'package:summarizeddebts/exceptions/error_exception.dart';
import 'package:summarizeddebts/exceptions/exception_messages.dart';
import 'package:summarizeddebts/model/expense_model.dart';
import 'package:summarizeddebts/model/monthly_income_model.dart';
import 'package:summarizeddebts/modules/debt/repository/api/debt_request.dart';
import 'package:summarizeddebts/modules/debt/repository/api/monthly_income_request.dart';
import 'package:summarizeddebts/modules/debt/repository/monthly_income_repository.dart';

class MonthlyIncomeBusiness {
  final MonthlyIncomeRepository _monthlyIncomeRepository;

  MonthlyIncomeBusiness(this._monthlyIncomeRepository);

  Future<List<MonthlyIncomeModel>> consult() async {
    List<MonthlyIncomeModel> response = await this._monthlyIncomeRepository.consult();

    if(response != null && response.isNotEmpty){
      response.sort((a, b) => a.month.compareTo(b.month));
    }

    return response;

  }

  Future<void> save(MonthlyIncomeModel monthlyIncomeModel) async {
    MonthlyIncomeRequest request = MonthlyIncomeRequest()
      ..monthlyIncomeModel = monthlyIncomeModel;

    MonthlyIncomeModel existModel =
        await this._monthlyIncomeRepository.getByMonth(request);

    if (existModel != null && (monthlyIncomeModel.id == null ||
        monthlyIncomeModel.id.isEmpty) )
      throw new ErrorException.withCode(
          null, ExceptionMessages.monthlyIncomeExist);

    if (monthlyIncomeModel.id == null || monthlyIncomeModel.id.isEmpty)
      request.monthlyIncomeModel.id = DateTime.now().toString();

    return await _monthlyIncomeRepository.save(request);
  }

  Future<void> delete(MonthlyIncomeModel monthlyIncomeModel) async {
    DebtRequest debtRequest = DebtRequest();
    debtRequest.debt = ExpenseModel()..localToPayId = monthlyIncomeModel.id;

    MonthlyIncomeRequest request = MonthlyIncomeRequest();
    request.monthlyIncomeModel = monthlyIncomeModel;

    return await _monthlyIncomeRepository.delete(request);
  }

  Future<MonthlyIncomeModel> getById(String id) async {
    return await this
        ._monthlyIncomeRepository
        .getById(MonthlyIncomeRequest()..registerId = id);
  }
}
