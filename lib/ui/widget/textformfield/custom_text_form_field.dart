import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:summarizeddebts/ui/resources/app_color.dart';
import 'package:summarizeddebts/ui/resources/app_decorations.dart';
import 'package:summarizeddebts/ui/resources/app_dimen.dart';
import 'package:summarizeddebts/ui/resources/app_styles.dart';

enum TextFormType { simple, date, money, number }

// ignore: must_be_immutable
class CustomTextFormField extends StatelessWidget {
  final TextFormType type;

  final obscureText;
  final maxLength;
  final onSaved;
  final textInputAction;
  final focusNode;
  final validator;
  final onFieldSubmitted;
  final keyboardType;
  final textAlign;
  final formKey;
  final isEnabled;
  final customKey;
  final onChange;
  TextEditingController controller;

  CustomTextFormField({
    Key key,
    @required this.type,
    this.maxLength,
    this.onSaved,
    this.textInputAction,
    this.focusNode,
    this.validator,
    this.onFieldSubmitted,
    this.formKey,
    this.keyboardType = TextInputType.text,
    this.textAlign = TextAlign.left,
    this.obscureText = false,
    this.controller,
    this.isEnabled = true,
    this.customKey,
    this.onChange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (this.type) {
      case TextFormType.simple:
        return simpleFormField();
      case TextFormType.date:
        return dateFormField();
      case TextFormType.money:
        return moneyFormField();
      case TextFormType.number:
        return numberFormField();
      default:
        return simpleFormField();
    }
  }

  Widget simpleFormField() {
    return TextFormField(
      key: customKey,
      keyboardType: this.keyboardType,
      controller: this.controller,
      obscureText: obscureText,
      style: AppStyles.formTextStyle(
          AppColor.darkBlue, ScreenUtil().setSp(AppDimen.formTextSize)),
      validator: validator,
      decoration:
          AppDecorations.formInputDecoration("", AppColor.loginErrorColor),
      maxLength: maxLength,
      onSaved: onSaved,
      textAlign: textAlign,
      textInputAction: textInputAction,
      focusNode: focusNode,
      onFieldSubmitted: onFieldSubmitted,
    );
  }

  Widget dateFormField() {
    return TextFormField(
      key: key,
      keyboardType: TextInputType.phone,
      controller: this.controller,
      obscureText: false,
      style: AppStyles.formTextStyle(
          AppColor.darkBlue, ScreenUtil().setSp(AppDimen.formTextSize)),
      validator: validator,
      decoration:
          AppDecorations.formInputDecoration("", AppColor.loginErrorColor)
              .copyWith(counter: Container()),
      maxLength: 10,
      onSaved: onSaved,
      textAlign: TextAlign.center,
      textInputAction: textInputAction,
      focusNode: focusNode,
      onFieldSubmitted: onFieldSubmitted,
    );
  }

  Widget moneyFormField() {
    return TextFormField(
      key: key,
      keyboardType: TextInputType.phone,
      controller: this.controller,
      onChanged: this.onChange,
      obscureText: false,
      style: AppStyles.formTextStyle(
          AppColor.darkBlue, ScreenUtil().setSp(AppDimen.formTextSize)),
      validator: validator,
      decoration:
          AppDecorations.formInputDecoration("", AppColor.loginErrorColor)
              .copyWith(counter: Container()),
      maxLength: 15,
      onSaved: onSaved,
      textAlign: TextAlign.center,
      textInputAction: textInputAction,
      focusNode: focusNode,
      onFieldSubmitted: onFieldSubmitted,
    );
  }

  Widget numberFormField() {
    return TextFormField(
      enabled: this.isEnabled,
      key: key,
      keyboardType: TextInputType.phone,
      controller: this.controller,
      obscureText: false,
      style: AppStyles.formTextStyle(
          AppColor.darkBlue, ScreenUtil().setSp(AppDimen.formTextSize)),
      validator: validator,
      decoration:
          AppDecorations.formInputDecoration("", AppColor.loginErrorColor)
              .copyWith(counter: Container()),
      maxLength: this.maxLength,
      onSaved: onSaved,
      textAlign: TextAlign.center,
      textInputAction: textInputAction,
      focusNode: focusNode,
      onFieldSubmitted: onFieldSubmitted,
    );
  }
}
