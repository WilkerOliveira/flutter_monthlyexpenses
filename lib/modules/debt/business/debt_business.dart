import 'package:summarizeddebts/common/utility.dart';
import 'package:summarizeddebts/exceptions/alert_exception.dart';
import 'package:summarizeddebts/exceptions/exception_messages.dart';
import 'package:summarizeddebts/extensions/list_extensions.dart';
import 'package:summarizeddebts/extensions/string_extensions.dart';
import 'package:summarizeddebts/model/debt_detail_model.dart';
import 'package:summarizeddebts/model/expense_model.dart';
import 'package:summarizeddebts/model/local_to_pay_model.dart';
import 'package:summarizeddebts/model/summarized_expenses_model.dart';
import 'package:summarizeddebts/modules/debt/repository/api/debt_request.dart';
import 'package:summarizeddebts/modules/debt/repository/api/local_to_pay_request.dart';
import 'package:summarizeddebts/modules/debt/repository/debt_repository.dart';
import 'package:summarizeddebts/modules/debt/repository/local_to_pay_repository.dart';

class DebtBusiness {
  final DebtRepository _debtRepository;
  final LocalToPayRepository _localToPayRepository;

  DebtBusiness(this._debtRepository, this._localToPayRepository);

  Future<List<ExpenseModel>> loadAll() async {
    List<ExpenseModel> debts = await _debtRepository.loadAll();
    List<ExpenseModel> response = [];

    if (debts != null && debts.isNotEmpty) {
      var groupDebts = debts.groupBy((m) => m.month);

      ExpenseModel newItem;

      for (String key in groupDebts.keys) {
        newItem = ExpenseModel();
        newItem.month = key;

        newItem.amount =
            groupDebts[key].fold(0, (curr, next) => curr + next.amount);

        newItem.paid = groupDebts[key].where((item) => !item.paid).length == 0;

        response.add(newItem);
      }

      response.sort((a, b) => a.month
          .parseMonthYearToDateTime()
          .compareTo(b.month.parseMonthYearToDateTime()));
    }

    return response;
  }

  Future<List<LocalToPayModel>> consultLocalToPay() async {
    List<LocalToPayModel> response = await this._localToPayRepository.consult();

    if (response == null || response.isEmpty)
      throw AlertException(message: ExceptionMessages.localToPayNotFound);

    response.sort((a, b) => a.description.compareTo(b.description));

    return response;
  }

  Future<void> save(ExpenseModel debtModel) async {
    DebtRequest request = DebtRequest()..debt = debtModel;

    if (debtModel.localToPayId == null || debtModel.localToPayId.isEmpty) {
      throw AlertException(message: ExceptionMessages.localToPayNotSelected);
    }

    if (debtModel.id == null || debtModel.id.isEmpty) {
      request.debt.id = DateTime.now().toString();
      request.debt.paid = false;
    }

    request.debt.month = request.debt.dueDate.getMonthYear();

    await _debtRepository.save(request);
  }

  Future<void> delete(ExpenseModel debtModel) async {
    DebtRequest request = DebtRequest()..debt = debtModel;
    request.registerId = debtModel.id;

    await _debtRepository.delete(request);
  }

  Future<DebtDetailModel> consultDebtsByMonthV2(DateTime month) async {
    DebtRequest request = DebtRequest();
    request.debt = ExpenseModel()..month = Utility.formatMonthYear(month);

    List<ExpenseModel> debts =
        await _debtRepository.consultDebtsByMonth(request);
    DebtDetailModel response = DebtDetailModel.init();
    response.month = request.debt.month;

    if (debts != null && debts.isNotEmpty) {
      debts.sort((a, b) => a.dueDate.compareTo(b.dueDate));

      response.debts = SummarizedExpensesModel();
      response.debts.items = debts;
    }

    return response;
  }

  Future<LocalToPayModel> getLocalToPay(String localToPayId) async {
    return await this
        ._localToPayRepository
        .getById(LocalToPayRequest()..registerId = localToPayId);
  }

  Future<void> doPayment(DebtDetailModel debtDetailModel) async {
    //get checked debts to pay
    List<ExpenseModel> items = debtDetailModel.debts.items
        .where((element) => element.isSelected.value && !element.paid)
        .toList();

    if (items == null || items.isEmpty) {
      throw AlertException(message: ExceptionMessages.nothingToPay);
    }
    DebtRequest request;
    for (ExpenseModel debtModel in items) {
      debtModel.paid = true;
      debtModel.payDate = DateTime.now().toString();

      debtModel.removeRecurring = false;
      debtModel.applyChanges = false;

      request = DebtRequest()..debt = debtModel;
      await _debtRepository.save(request);
    }
  }

  Future<void> doReopen(DebtDetailModel debtDetailModel) async {
    //get checked debts to pay
    List<ExpenseModel> items = debtDetailModel.debts.items
        .where((element) => element.isSelected.value && element.paid)
        .toList();

    if (items == null || items.isEmpty) {
      throw AlertException(message: ExceptionMessages.nothingToReopen);
    }
    DebtRequest request;

    for (ExpenseModel debtModel in items) {
      debtModel.paid = false;
      debtModel.payDate = null;

      debtModel.removeRecurring = false;
      debtModel.applyChanges = false;

      request = DebtRequest()..debt = debtModel;
      await _debtRepository.save(request);
    }
  }

  Future<void> doDelete(DebtDetailModel debtDetailModel) async {
    //get checked debts to pay
    List<ExpenseModel> items = debtDetailModel.debts.items
        .where((element) => element.isSelected.value)
        .toList();

    if (items == null) items = [];
    items.addAll(debtDetailModel.debts.items
        .where((element) => element.isSelected.value)
        .toList());

    if (items == null || items.isEmpty) {
      throw AlertException(message: ExceptionMessages.nothingToDelete);
    }

    DebtRequest request;
    for (ExpenseModel debtModel in items) {
      request = DebtRequest()..registerId = debtModel.id;

      await _debtRepository.delete(request);
    }
  }

  Future<void> payAll(List<ExpenseModel> expensesToPay) async {
    if (expensesToPay == null) {
      throw AlertException(message: ExceptionMessages.nothingToPay);
    }

    List<ExpenseModel> itemsToPay = expensesToPay
        .where((element) => element.isSelected.value && !element.paid)
        .toList();

    if (itemsToPay == null || itemsToPay.isEmpty) {
      throw AlertException(message: ExceptionMessages.noOpenExpensesToPay);
    }

    DebtRequest request = DebtRequest();
    List<ExpenseModel> debts;
    for (ExpenseModel item in itemsToPay) {
      request.debt = ExpenseModel()..month = item.month;
      debts = await _debtRepository.consultDebtsByMonth(request);

      if (debts != null && debts.isNotEmpty) {
        debts.sort((a, b) => a.dueDate.compareTo(b.dueDate));

        for (ExpenseModel debtModel in debts) {
          if (!debtModel.paid) {
            request = DebtRequest();
            debtModel.payDate = DateTime.now().toString();
            debtModel.paid = true;
            request.debt = debtModel;

            await _debtRepository.save(request);
          }
        }
      }
    }
  }

  Future<void> deleteAll(List<ExpenseModel> expensesToPay) async {
    if (expensesToPay == null) {
      throw AlertException(message: ExceptionMessages.nothingToDelete);
    }

    List<ExpenseModel> itemsToDelete =
        expensesToPay.where((element) => element.isSelected.value).toList();

    if (itemsToDelete == null || itemsToDelete.isEmpty) {
      throw AlertException(message: ExceptionMessages.nothingToDelete);
    }
    DebtRequest request = DebtRequest();
    List<ExpenseModel> debts;
    for (ExpenseModel item in itemsToDelete) {
      request.debt = ExpenseModel()..month = item.month;
      debts = await _debtRepository.consultDebtsByMonth(request);

      if (debts != null && debts.isNotEmpty) {
        debts.sort((a, b) => a.dueDate.compareTo(b.dueDate));
        for (ExpenseModel debtModel in debts) {
          DebtRequest request = DebtRequest()..registerId = debtModel.id;
          await _debtRepository.delete(request);
        }
      }
    }
  }

  Future<ExpenseModel> getById(String id) async {
    DebtRequest request = DebtRequest()..registerId = id;

    return await _debtRepository.getById(request);
  }
}
