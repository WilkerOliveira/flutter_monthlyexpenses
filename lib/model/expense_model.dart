import 'package:mobx/mobx.dart';
import 'package:summarizeddebts/model/local_to_pay_model.dart';

class ExpenseModel {

  String id;
  String month;
  String dueDate;
  double amount;
  String description;

  bool recurrent;
  int totalRecurrent;
  String mainExpenseId;

  String localToPayId;
  String localToPayName;
  bool paid;
  String payDate;
  bool directDebt;

  bool applyChanges;
  bool removeRecurring;

  String dueDateWithDescription;

  Observable<bool> isSelected = Observable(false);

  ExpenseModel();

  LocalToPayModel localToPay;

  ExpenseModel.fromJson(Map<String, dynamic> json) {
    this.id = json['id'];
    this.dueDate = json['dueDate'] as String;
    this.month = json['month'] as String;
    this.amount = json['amount'].toDouble();
    this.description = json['description'] as String;
    this.recurrent = json['recurrent'] as bool;
    this.totalRecurrent = json['totalRecurrent'] as int;
    this.mainExpenseId = json['mainExpenseId'] as String;
    this.localToPayId = json['localToPayId'] as String;
    this.localToPayName = json['localToPayName'] as String;
    this.paid = json['paid'] as bool;
    this.payDate = json['payDate'] as String;
    this.directDebt = json['directDebt'] as bool;
    this.applyChanges = json['applyChanges'] as bool;
    this.removeRecurring = json['removeRecurring'] as bool;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['id'] = this.id;
    data['dueDate'] = this.dueDate;
    data['month'] = this.month;
    data['amount'] = this.amount;
    data['description'] = this.description;
    data['recurrent'] = this.recurrent;
    data['totalRecurrent'] = this.totalRecurrent;
    data['mainExpenseId'] = this.mainExpenseId;
    data['localToPayId'] = this.localToPayId;
    data['paid'] = this.paid;
    data['payDate'] = this.payDate;
    data['directDebt'] = this.directDebt;
    data['applyChanges'] = this.applyChanges;
    data['removeRecurring'] = this.removeRecurring;
    data['localToPayName'] = this.localToPayName;

    return data;
  }

}