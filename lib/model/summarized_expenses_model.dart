import 'package:summarizeddebts/model/expense_model.dart';

class SummarizedExpensesModel {
  String type;
  double total;
  bool debt;
  List<ExpenseModel> items;

  SummarizedExpensesModel();

  SummarizedExpensesModel.chart(double total, String month){
    this.total = total;
    this.type = month;
  }

  SummarizedExpensesModel.init(bool debt){
    this.type = "";
    this.total = 0;
    this.debt = debt;
    items = [];
  }
}
