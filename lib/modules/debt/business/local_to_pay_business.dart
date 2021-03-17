import 'package:summarizeddebts/exceptions/error_exception.dart';
import 'package:summarizeddebts/exceptions/exception_messages.dart';
import 'package:summarizeddebts/model/expense_model.dart';
import 'package:summarizeddebts/model/local_to_pay_model.dart';
import 'package:summarizeddebts/modules/debt/repository/api/debt_request.dart';
import 'package:summarizeddebts/modules/debt/repository/api/local_to_pay_request.dart';
import 'package:summarizeddebts/modules/debt/repository/debt_repository.dart';
import 'package:summarizeddebts/modules/debt/repository/local_to_pay_repository.dart';

class LocalToPayBusiness {
  final LocalToPayRepository _localToPayRepository;
  final DebtRepository _debtRepository;

  LocalToPayBusiness(this._localToPayRepository, this._debtRepository);

  Future<List<LocalToPayModel>> consult() async {
    List<LocalToPayModel> response = await this._localToPayRepository.consult();

    if (response != null && response.isNotEmpty) {
      response.sort((a, b) => a.description.compareTo(b.description));
    }

    return response;
  }

  Future<void> save(LocalToPayModel localToPayModel) async {
    LocalToPayRequest request = LocalToPayRequest()
      ..localToPayModel = localToPayModel;

    LocalToPayModel existModel =
        await this._localToPayRepository.getByDescription(request);

    if (existModel != null && (localToPayModel.id == null ||
        localToPayModel.id.isEmpty))
      throw new ErrorException.withCode(
          null, ExceptionMessages.localToPayExist);

    if (localToPayModel.id == null || localToPayModel.id.isEmpty)
      request.localToPayModel.id = DateTime.now().toString();

    return await _localToPayRepository.save(request);
  }

  Future<void> delete(LocalToPayModel localToPayModel) async {
    DebtRequest debtRequest = DebtRequest();
    debtRequest.debt = ExpenseModel()..localToPayId = localToPayModel.id;

    List<ExpenseModel> debts =
        await this._debtRepository.getByLocalToPay(debtRequest);

    if (debts != null && debts.isNotEmpty)
      throw new ErrorException.withCode(
          null, ExceptionMessages.localToPayInUse);
    LocalToPayRequest request = LocalToPayRequest();
    request.localToPayModel = localToPayModel;

    return await _localToPayRepository.delete(request);
  }

  Future<LocalToPayModel> getById(String localToPayId) async {
    return await this
        ._localToPayRepository
        .getById(LocalToPayRequest()..registerId = localToPayId);
  }
}
