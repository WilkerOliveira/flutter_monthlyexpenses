import 'dart:ui';

import 'package:flutter/widgets.dart';

extension StringParsing on String {
  double formattedToDouble(context) {
    Locale myLocale = Localizations.localeOf(context);

    if (myLocale.countryCode == "BR") {
      //0.000.000,00
      return double.parse(this.replaceAll(".", "").replaceAll(",", "."));
    } else {
      return double.parse(this.replaceAll(",", ""));
    }
  }

  DateTime parseMonthYearToDateTime() {
    return DateTime(
        int.parse(this.split("/")[1]), int.parse(this.split("/")[0]), 1);
  }

  String getMonthYear() {
    if (this.length == 10) return this.split("/")[1] + "/" + this.split("/")[2];
    return this;
  }
}
