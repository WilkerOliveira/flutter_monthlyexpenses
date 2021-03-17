class ReportExpenseModel {
  String month;
  double income;
  double expenses;
  double balance;
  bool isPositive;

  ReportExpenseModel() {
    month = "";
    income = 0.0;
    expenses = 0.0;
    balance = 0.0;
    isPositive = false;
  }
}
