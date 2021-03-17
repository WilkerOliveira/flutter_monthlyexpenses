import 'package:flutter/material.dart';
import 'package:summarizeddebts/common/utility.dart';
import 'package:summarizeddebts/generated/i18n.dart';

class CommonFormValidation {
  BuildContext commonValidationContext;

  String requiredField(String value) {
    if (value == null || value.isEmpty) {
      return S.of(commonValidationContext).required_field;
    }

    return null;
  }

  String emailValidation(String email) {
    if (email == null || email.isEmpty) {
      return S.of(commonValidationContext).required_field;
    }

    if (!RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email)) {
      return S.of(commonValidationContext).invalid_email;
    }

    return null;
  }

  String monthYearValidation(String value){

    if (value == null || value.isEmpty) {
      return S.of(commonValidationContext).required_field;
    }

    if (!RegExp(r"^(((0)[0-9])|((1)[0-2]))(\/)20[0-9]{2}$").hasMatch(value)) {
      return S.of(commonValidationContext).invalid_month_year_format;
    }

    return null;
  }

  String dateValidation(String value){

    if (value == null || value.isEmpty) {
      return S.of(commonValidationContext).required_field;
    }

    if (!RegExp(r"^([0-2][0-9]|(3)[0-1])(\/)(((0)[0-9])|((1)[0-2]))(\/)20[0-9]{2}$").hasMatch(value)) {
      return S.of(commonValidationContext).invalid_month_year_format;
    }

    return null;
  }

  String requiredAndGreaterThanZero(String value) {
    if (value == null || value.isEmpty) {
      return S.of(commonValidationContext).required_field;
    }

    if(Utility.parseToNumber(value) <= 0){
      return S.of(commonValidationContext).required_field;
    }

    return null;
  }

  String yearValidation(String value){

    if (value == null || value.isEmpty) {
      return S.of(commonValidationContext).required_field;
    }

    if (!RegExp(r"^20[0-9]{2}$").hasMatch(value)) {
      return S.of(commonValidationContext).invalid_year_format;
    }

    return null;
  }
}
