import 'package:intl/intl.dart';

extension DoubleParsing on double {
  String toCurrency() {
//    bool isNegative = false;
//    double value = this;
//    if(this < 0){
//      isNegative = true;
//      value *= -1;
//    }

    return NumberFormat.simpleCurrency().format(this);

//    if(isNegative){
//      return "-" + currency;
//    }
//
//    return currency;
  }

  double roundTwoPlaces() {
    String current = this.toStringAsFixed(2);

    return double.parse(current);
  }
}
