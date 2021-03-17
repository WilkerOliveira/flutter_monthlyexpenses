import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:summarizeddebts/generated/i18n.dart';
import 'package:summarizeddebts/modules/config/controller/update_password_controller.dart';
import 'package:summarizeddebts/ui/resources/app_dimen.dart';
import 'package:summarizeddebts/ui/utility/screen_utility.dart';
import 'package:summarizeddebts/ui/validation/register_form_validation.dart';
import 'package:summarizeddebts/ui/widget/appbar/custom_appbar.dart';
import 'package:summarizeddebts/ui/widget/dialog/alert_dialogs.dart';
import 'package:summarizeddebts/ui/widget/textformfield/custom_text_form_field.dart';

class UpdatePasswordScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _UpdatePasswordScreenState();
}

class _UpdatePasswordScreenState
    extends ModularState<UpdatePasswordScreen, UpdatePasswordController>
    with RegisterFormValidation {
  final _formKey = GlobalKey<FormState>();
  var passwordKey = GlobalKey<FormFieldState>();

  FocusNode _currentPasswordFocus;
  FocusNode _passwordFocus;
  FocusNode _confirmPasswordFocus;

  @override
  void initState() {
    super.initState();

    _currentPasswordFocus = FocusNode();
    _confirmPasswordFocus = FocusNode();
    _passwordFocus = FocusNode();

    //Load only when build is complete
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadData();
    });
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.

    _currentPasswordFocus.dispose();
    _confirmPasswordFocus.dispose();
    _passwordFocus.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    this.registerValidationContext = context;
    return Scaffold(
      appBar: CustomAppBar(
        appBarType: AppBarType.simple,
        title: S.of(context).change_password,
        showBackArrow: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            tooltip: S.of(context).save,
            onPressed: () {
              this.save();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: body(),
      ),
    );
  }

  Widget body() {
    return Container(
      margin: EdgeInsets.only(
        bottom: ScreenUtil().setWidth(AppDimen.adMargin),
      ),
      child: Column(
        children: <Widget>[
          profileManager(),
        ],
      ),
    );
  }

  Widget profileManager() {
    return Container(
      margin: EdgeInsets.only(
        bottom: ScreenUtil().setWidth(AppDimen.defaultMargin),
        left: ScreenUtil().setWidth(AppDimen.defaultMargin),
        right: ScreenUtil().setWidth(AppDimen.defaultMargin),
      ),
      child: registerForm(),
    );
  }

  Widget registerForm() {
    final currentPasswordField = new CustomTextFormField(
      key: Key("currentPasswordField"),
      obscureText: true,
      type: TextFormType.simple,
      maxLength: AppDimen.passwordSize,
      validator: passwordValidation,
      focusNode: _currentPasswordFocus,
      onFieldSubmitted: (term) {
        ScreenUtility.fieldFocusChange(
            context, _currentPasswordFocus, _passwordFocus);
      },
      onSaved: (String value) {
        controller.userModel.oldPassword = value.trim();
      },
      textInputAction: TextInputAction.next,
    );

    final passwordField = new CustomTextFormField(
      customKey: passwordKey,
      obscureText: true,
      type: TextFormType.simple,
      maxLength: AppDimen.passwordSize,
      validator: passwordValidation,
      focusNode: _passwordFocus,
      onFieldSubmitted: (term) {
        ScreenUtility.fieldFocusChange(
            context, _passwordFocus, _confirmPasswordFocus);
      },
      onSaved: (String value) {
        controller.userModel.password = value.trim();
      },
      textInputAction: TextInputAction.next,
    );

    final confirmPassword = new CustomTextFormField(
      key: Key("confirmPassword"),
      obscureText: true,
      type: TextFormType.simple,
      maxLength: AppDimen.passwordSize,
      validator: (confirmation) {
        String password = passwordKey.currentState.value;
        return confirmation.trim() == password.trim()
            ? null
            : S.of(context).password_not_match;
      },
      focusNode: _confirmPasswordFocus,
      onFieldSubmitted: (term) {},
      onSaved: (String value) {
        controller.userModel.confirmPassword = value.trim();
      },
      textInputAction: TextInputAction.done,
    );

    return Form(
      key: _formKey,
      child: Padding(
        padding: EdgeInsets.only(top: ScreenUtil().setWidth(30)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(
                bottom: ScreenUtil().setWidth(10),
                left: ScreenUtil().setWidth(5),
              ),
              child: Text(
                S.of(context).current_password,
                style: TextStyle(
                  fontSize: ScreenUtil().setSp(16),
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(
              child: currentPasswordField,
            ),
            SizedBox(height: ScreenUtil().setHeight(5.0)),
            Padding(
              padding: EdgeInsets.only(
                bottom: ScreenUtil().setWidth(10),
                left: ScreenUtil().setWidth(5),
              ),
              child: Text(
                S.of(context).new_password,
                style: TextStyle(
                  fontSize: ScreenUtil().setSp(16),
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(
              child: passwordField,
            ),
            SizedBox(height: ScreenUtil().setHeight(5.0)),
            Padding(
              padding: EdgeInsets.only(
                bottom: ScreenUtil().setWidth(10),
                left: ScreenUtil().setWidth(5),
              ),
              child: Text(
                S.of(context).confirm_password,
                style: TextStyle(
                  fontSize: ScreenUtil().setSp(16),
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(
              child: confirmPassword,
            ),
            SizedBox(
              height: ScreenUtil().setHeight(30),
            ),
          ],
        ),
      ),
    );
  }

  loadData() async {
    AlertDialogs.showLoading(context, S.of(context).please_wait);
    await this.controller.checkCustomLogin();
    AlertDialogs.closeDialog(context);

    if (!this.controller.isCustomLogin) {
      AlertDialogs.showAlertToastWithMessage(
          S.of(context).not_update_password_custom_login);
    }
  }

  Future<void> save() async {
    if (!this.controller.isCustomLogin) {
      AlertDialogs.showAlertToastWithMessage(
          S.of(context).not_update_password_custom_login);
      return;
    }

    if (this._formKey.currentState.validate()) {
      this._formKey.currentState.save();

      AlertDialogs.showLoading(context, S.of(context).please_wait);

      SystemChannels.textInput.invokeMethod('TextInput.hide');

      await this.controller.updatePassword();

      AlertDialogs.closeDialog(context);

      if (this.controller.isAlert) {
        _currentPasswordFocus.requestFocus();
        AlertDialogs.showAlertToast(context, this.controller.errorMessage);
      } else if (this.controller.isError) {
        AlertDialogs.showErrorDialog(
            context, S.of(context).app_name, controller.errorMessage);
      } else {
        AlertDialogs.showSuccessDialog(context, S.of(context).success_title,
            S.of(context).password_successfully_changed, () {});
      }
    }
  }
}
