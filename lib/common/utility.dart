import 'package:intl/intl.dart';
import 'package:summarizeddebts/generated/i18n.dart';

class Utility {
  static String parseToMonthDescription(String monthYear, context) {
    if (monthYear == null || monthYear.isEmpty) return monthYear;

    int month = monthYear.contains("/")
        ? int.parse(monthYear.split("/")[0])
        : int.parse(monthYear);
    String year = "00";
    if (monthYear.contains("/")) year = monthYear.split("/")[1];
    String description;
    switch (month) {
      case 1:
        description = S.of(context).january;
        break;
      case 2:
        description = S.of(context).february;
        break;
      case 3:
        description = S.of(context).march;
        break;
      case 4:
        description = S.of(context).april;
        break;
      case 5:
        description = S.of(context).may;
        break;
      case 6:
        description = S.of(context).june;
        break;
      case 7:
        description = S.of(context).july;
        break;
      case 8:
        description = S.of(context).august;
        break;
      case 9:
        description = S.of(context).september;
        break;
      case 10:
        description = S.of(context).october;
        break;
      case 11:
        description = S.of(context).november;
        break;
      case 12:
        description = S.of(context).december;
        break;
      default:
        description = "";
    }

    return "$description/$year";
  }

  /// Get the current month in this format MM/YYYY
  static String currentMonthFormatted() {
    return formatMonthYear(new DateTime.now());
  }

  /// Format a date in this format MM/YYYY
  static String formatMonthYear(DateTime dateToFormat) {
    var formatter = new DateFormat('MM/yyyy');
    return formatter.format(dateToFormat);
  }

  static parseToNumber(String value) {
    if (value != null && value.isNotEmpty) {
      return num.parse(value.replaceAll(new RegExp("[^0-9]"), ""));
    }

    return 0;
  }
}
