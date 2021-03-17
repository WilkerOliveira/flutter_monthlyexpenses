class MonthlyIncomeModel {

  String id;
  String month;
  double amount;

  MonthlyIncomeModel();

  MonthlyIncomeModel.fromJson(Map<String, dynamic> json) {
    this.id = json['id'];
    this.month = json['month'] as String;
    this.amount = json['amount'].toDouble();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['month'] = this.month;
    data['amount'] = this.amount;

    return data;
  }

}