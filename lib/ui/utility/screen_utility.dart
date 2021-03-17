import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:package_info/package_info.dart';
import 'package:summarizeddebts/generated/i18n.dart';
import 'package:summarizeddebts/ui/resources/app_color.dart';
import 'package:summarizeddebts/ui/resources/app_decorations.dart';
import 'package:summarizeddebts/ui/resources/app_dimen.dart';
import 'package:summarizeddebts/ui/resources/app_styles.dart';

class ScreenUtility {
  static void initScreenUtil({@required BuildContext context}) {
    ScreenUtil.init(
      context,
      width: AppDimen.baseScreenWidth,
      height: AppDimen.baseScreenHeight,
    );
  }

  static fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  @deprecated
  static TextFormField getBaseTextFormField(
      {@required context,
      obscureText = false,
      @required maxLength,
      onSaved,
      textInputAction,
      focusNode,
      validator,
      onFieldSubmitted,
      keyboardType = TextInputType.text,
      controller,
      textAlign = TextAlign.left,
      key}) {
    return TextFormField(
      key: key,
      controller: controller,
      obscureText: obscureText,
      style: AppStyles.formTextStyle(
          AppColor.darkBlue, ScreenUtil().setSp(AppDimen.formTextSize)),
      validator: validator,
      decoration: AppDecorations.formInputDecoration(
          S.of(context).name, AppColor.loginErrorColor),
      maxLength: maxLength,
      onSaved: onSaved,
      textAlign: TextAlign.center,
      textInputAction: textInputAction,
      focusNode: focusNode,
      onFieldSubmitted: onFieldSubmitted,
    );
  }

  static MaskedTextController dateMaskedTextController() {
    return maskedTextController('00/00/0000');
  }

  static MaskedTextController monthYearTextController() {
    return maskedTextController('00/0000');
  }

  static MaskedTextController yearMaskedTextController() {
    return maskedTextController('0000');
  }

  static MaskedTextController maskedTextController(String mask) {
    return MaskedTextController(mask: mask);
  }

  static MoneyMaskedTextController moneyMaskedTextController(Locale myLocale) {
    if (myLocale.countryCode == "BR") {
      return new MoneyMaskedTextController(
          decimalSeparator: ',', thousandSeparator: '.');
    } else {
      return new MoneyMaskedTextController(
          decimalSeparator: '.', thousandSeparator: ',');
    }
  }

  static String formatDueDateDescription(String dueDate, String description) {
    String day = dueDate.split("/")[0];

    return "$day - $description";
  }

  static Future<String> getVersion() async {

    var platform = (await PackageInfo.fromPlatform());

    return "v.${platform.version}";

  }
}
