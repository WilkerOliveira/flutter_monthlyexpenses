class MonthlyExpensesModel {
  String userId;
  String month;
  double total;
  double totalPaid;
  double totalOutstanding;
  double monthlyIncome;

  MonthlyExpensesModel();

  MonthlyExpensesModel.init(month) {
    this.month = month;
    this.total = 0.0;
    this.totalPaid = 0.0;
    this.totalOutstanding = 0.0;
    this.monthlyIncome = 0.0;
  }

  MonthlyExpensesModel.fromJson(Map<String, dynamic> json) {
    this.userId = json['userId'];
    this.month = json['month'] as String;
    this.total = json['total'].toDouble();
    this.totalPaid = json['totalPaid'].toDouble();
    this.totalOutstanding = json['totalOutstanding'].toDouble();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['userId'] = this.userId;
    data['month'] = this.month;
    data['total'] = this.total;
    data['totalPaid'] = this.totalPaid;
    data['totalOutstanding'] = this.totalOutstanding;

    return data;
  }
}
