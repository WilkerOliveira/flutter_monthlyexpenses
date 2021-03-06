import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:summarizeddebts/exceptions/exception_messages.dart';
import 'package:summarizeddebts/generated/i18n.dart';
import 'package:summarizeddebts/ui/resources/app_color.dart';
import 'package:summarizeddebts/ui/resources/app_styles.dart';
import 'package:summarizeddebts/ui/widget/dialog/custom_dialog.dart';
import 'package:summarizeddebts/ui/widget/dialog/reset_password_dialog.dart';

class AlertDialogs {
  static String _getMessage(
      BuildContext context, ExceptionMessages exceptionMessage) {
    switch (exceptionMessage) {
      case ExceptionMessages.userNotRegistered:
        return S.of(context).user_not_registered;
      case ExceptionMessages.cancelledByUser:
        return S.of(context).login_cancelled_by_user;
      case ExceptionMessages.error:
        return S.of(context).default_error;
      case ExceptionMessages.userEmailAlreadyExists:
        return S.of(context).user_email_already_exist;
      case ExceptionMessages.passwordNotMatch:
        return S.of(context).password_not_match;
      case ExceptionMessages.noInternetConnection:
        return S.of(context).no_internet_connection;
      case ExceptionMessages.invalidEmailOrPassword:
        return S.of(context).invalid_email_or_password;
      case ExceptionMessages.userRegisteredWithDiffCredential:
        return S.of(context).userRegisteredWithDiffCredential;
      case ExceptionMessages.emailNotFound:
        return S.of(context).emailNotFound;
      case ExceptionMessages.emailNotVerified:
        return S.of(context).email_confirmation_sent;
      case ExceptionMessages.invalidPassword:
        return S.of(context).invalid_password;
      case ExceptionMessages.localToPayExist:
        return S.of(context).local_to_pay_exist;
      case ExceptionMessages.localToPayInUse:
        return S.of(context).local_to_pay_in_use;
      case ExceptionMessages.localToPayNotFound:
        return S.of(context).local_to_pay_not_found;
      case ExceptionMessages.localToPayNotSelected:
        return S.of(context).local_to_pay_not_selected;
      case ExceptionMessages.nothingToPay:
        return S.of(context).nothing_to_pay;
      case ExceptionMessages.nothingToReopen:
        return S.of(context).nothing_to_reopen;
      case ExceptionMessages.nothingToDelete:
        return S.of(context).nothing_to_delete;
      case ExceptionMessages.noOpenExpensesToPay:
        return S.of(context).no_open_expense_to_pay;
      case ExceptionMessages.monthlyIncomeExist:
        return S.of(context).monthly_income_exist;
      default:
        return S.of(context).default_error;
    }
  }

  static void showErrorDialog(
      BuildContext context, String title, ExceptionMessages exceptionMessages) {
    String errorMessage = exceptionMessages == null
        ? S.of(context).default_error
        : _getMessage(context, exceptionMessages);

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => CustomDialog(
        title: title,
        description: errorMessage,
        buttonText: S.of(context).close_button.toUpperCase(),
        color: Colors.red,
        dialogType: DialogType.error,
      ),
    );
  }

  static void showErrorMessageDialog(
      BuildContext context, String title, String message) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => CustomDialog(
        title: title,
        description: message,
        buttonText: S.of(context).close_button.toUpperCase(),
        color: Colors.red,
        dialogType: DialogType.error,
      ),
    );
  }

  static void showInfoDialog(
      BuildContext context, String title, ExceptionMessages exceptionMessages) {
    String message = exceptionMessages == null
        ? S.of(context).default_error
        : _getMessage(context, exceptionMessages);

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => CustomDialog(
        title: title,
        description: message,
        buttonText: S.of(context).close_button.toUpperCase(),
        color: Colors.amber,
        dialogType: DialogType.info,
      ),
    );
  }

  static void showSuccessDialog(
      BuildContext context, String title, String message, callbackFunction) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => CustomDialog(
        title: title,
        description: message,
        buttonText: S.of(context).close_button.toUpperCase(),
        color: Colors.green,
        dialogType: DialogType.success,
      ),
    ).then((val) {
      if (callbackFunction != null) callbackFunction();
    });
  }

  static void showResetPassword(BuildContext context, callbackFunction) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => ResetPasswordDialog(
        onResetPassword: callbackFunction,
      ),
    );
  }

  static void showYesOrNoQuestion(
      {BuildContext context,
      String title,
      String message,
      String textButtonOne,
      String textButtonTwo,
      @required yesCallBackFunction,
      noCallBackFunction}) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => CustomDialog(
        title: title,
        description: message,
        buttonText: textButtonTwo,
        color: Colors.amber,
        dialogType: DialogType.question,
        buttonQuestionText: textButtonOne,
        onYesButtonPressed: yesCallBackFunction,
        onNoButtonPressed: noCallBackFunction,
      ),
    );
  }

  static void showLoading(BuildContext context, String title) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        backgroundColor: AppColor.topHead,
        content: Container(
          child: Row(
            children: <Widget>[
              SizedBox(
                height: 30,
                width: 30,
                child: CircularProgressIndicator(),
              ),
              SizedBox(
                width: 50,
              ),
              Text(
                title,
                style: AppStyles.defaultTextStyle(),
              )
            ],
          ),
        ),
      ),
    );
  }

  static void closeDialog(context) {
    Navigator.of(context).pop();
  }

  static void showAlertToast(context, exceptionMessages) {
    String errorMessage = exceptionMessages == null
        ? S.of(context).default_error
        : _getMessage(context, exceptionMessages);

    Fluttertoast.showToast(
      msg: errorMessage,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: AppColor.alertButtonColor,
      textColor: Colors.black,
      fontSize: ScreenUtil().setSp(16.0),
    );
  }

  static void showAlertToastWithMessage(message) {

    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: AppColor.alertButtonColor,
      textColor: Colors.black,
      fontSize: ScreenUtil().setSp(16.0),
    );
  }
}
