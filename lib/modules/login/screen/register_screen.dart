import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:summarizeddebts/generated/i18n.dart';
import 'package:summarizeddebts/model/user_model.dart';
import 'package:summarizeddebts/modules/login/controller/register_controller.dart';
import 'package:summarizeddebts/ui/resources/app_color.dart';
import 'package:summarizeddebts/ui/resources/app_dimen.dart';
import 'package:summarizeddebts/ui/utility/screen_utility.dart';
import 'package:summarizeddebts/ui/validation/common_form_validation.dart';
import 'package:summarizeddebts/ui/validation/register_form_validation.dart';
import 'package:summarizeddebts/ui/widget/appbar/custom_appbar.dart';
import 'package:summarizeddebts/ui/widget/dialog/alert_dialogs.dart';
import 'package:summarizeddebts/ui/widget/textformfield/custom_text_form_field.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState
    extends ModularState<RegisterScreen, RegisterController>
    with CommonFormValidation, RegisterFormValidation {
  final _formKey = GlobalKey<FormState>();
  var passKey = GlobalKey<FormFieldState>();
  var emailKey = GlobalKey<FormFieldState>();

  UserModel newUser = UserModel();

  FocusNode _nameFocus;
  FocusNode _emailFocus;
  FocusNode _emailConfirmFocus;
  FocusNode _password;
  FocusNode _confPassword;

  @override
  void initState() {
    super.initState();

    _nameFocus = FocusNode();
    _emailFocus = FocusNode();
    _emailConfirmFocus = FocusNode();
    _password = FocusNode();
    _confPassword = FocusNode();
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    _nameFocus.dispose();
    _emailFocus.dispose();
    _emailConfirmFocus.dispose();
    _password.dispose();
    _confPassword.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    this.commonValidationContext = context;
    this.registerValidationContext = context;

    return Scaffold(
      appBar: CustomAppBar(
          appBarType: AppBarType.simple,
          title: S.of(context).new_register,
          actions: [
            IconButton(
              icon: const Icon(Icons.save),
              tooltip: S.of(context).save,
              onPressed: this._doRegister,
            )
          ]),
      body: SingleChildScrollView(child: _body()),
    );
  }

  Widget _body() {
    return Container(
      margin: EdgeInsets.only(
        left: ScreenUtil().setWidth(AppDimen.defaultMargin),
        right: ScreenUtil().setWidth(AppDimen.defaultMargin),
      ),
      color: AppColor.darkBlue,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          registerForm(),
          SizedBox(
            height: ScreenUtil().setHeight(
              AppDimen.sizedBoxSpace,
            ),
          ),
        ],
      ),
    );
  }

  void _doRegister() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      AlertDialogs.showLoading(context, S.of(context).please_wait);

      await controller.registerNewUser(newUser);

      AlertDialogs.closeDialog(context);

      if (controller.isError) {
        AlertDialogs.showErrorDialog(
            context, S.of(context).error_title, controller.errorMessage);
      } else if (controller.errorMessage != null &&
          controller.errorMessage.toString().isNotEmpty) {
        AlertDialogs.showInfoDialog(
            context, S.of(context).info_title, controller.errorMessage);
      } else {
        AlertDialogs.showSuccessDialog(
            context,
            S.of(context).success_title,
            S.of(context).email_confirmation_sent,
            () => Navigator.pop(context));
      }
    }
  }

  Widget registerForm() {
    final nameField = CustomTextFormField(
      type: TextFormType.simple,
      focusNode: _nameFocus,
      maxLength: 50,
      validator: requiredField,
      onFieldSubmitted: (term) {
        ScreenUtility.fieldFocusChange(context, _nameFocus, _emailFocus);
      },
      onSaved: (String value) {
        newUser.firstName = value.trim();
      },
      textInputAction: TextInputAction.next,
    );

    final emailField = CustomTextFormField(
      type: TextFormType.simple,
      customKey: emailKey,
      focusNode: _emailFocus,
      keyboardType: TextInputType.emailAddress,
      maxLength: AppDimen.emailSize,
      validator: emailValidation,
      onFieldSubmitted: (term) {
        ScreenUtility.fieldFocusChange(
            context, _emailFocus, _emailConfirmFocus);
      },
      onSaved: (String value) {
        newUser.email = value.trim();
      },
      textInputAction: TextInputAction.next,
    );

    final confirmEmailField = CustomTextFormField(
      type: TextFormType.simple,
      focusNode: _emailConfirmFocus,
      keyboardType: TextInputType.emailAddress,
      maxLength: AppDimen.emailSize,
      validator: (confirmation) {
        String email = emailKey.currentState.value;
        return confirmation.trim() == email.trim()
            ? null
            : S.of(context).email_not_match;
      },
      onFieldSubmitted: (term) {
        ScreenUtility.fieldFocusChange(context, _emailFocus, _password);
      },
      onSaved: (String value) {
        newUser.email = value.trim();
      },
      textInputAction: TextInputAction.next,
    );

    final passwordField = CustomTextFormField(
      obscureText: true,
      customKey: passKey,
      type: TextFormType.simple,
      focusNode: _password,
      keyboardType: TextInputType.text,
      maxLength: AppDimen.passwordSize,
      validator: passwordValidation,
      onFieldSubmitted: (term) {
        ScreenUtility.fieldFocusChange(context, _password, _confPassword);
      },
      onSaved: (String value) {
        newUser.password = value.trim();
      },
      textInputAction: TextInputAction.next,
    );

    final confirmPassword = CustomTextFormField(
      obscureText: true,
      type: TextFormType.simple,
      focusNode: _confPassword,
      keyboardType: TextInputType.text,
      maxLength: AppDimen.passwordSize,
      validator: (confirmation) {
        String password = passKey.currentState.value;
        return confirmation.trim() == password.trim()
            ? null
            : S.of(context).password_not_match;
      },
      onFieldSubmitted: (term) {
        _doRegister();
      },
      onSaved: (String value) {
        newUser.confirmPassword = value.trim();
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
                  left: ScreenUtil().setWidth(5)),
              child: Text(
                S.of(context).name,
                style: TextStyle(
                  fontSize: ScreenUtil().setSp(16),
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(
              child: nameField,
            ),
            SizedBox(height: ScreenUtil().setHeight(10.0)),
            Padding(
              padding: EdgeInsets.only(
                bottom: ScreenUtil().setWidth(10),
                left: ScreenUtil().setWidth(5),
              ),
              child: Text(
                S.of(context).email,
                style: TextStyle(
                  fontSize: ScreenUtil().setSp(16),
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(
              child: emailField,
            ),
            SizedBox(height: ScreenUtil().setHeight(10.0)),
            Padding(
              padding: EdgeInsets.only(
                bottom: ScreenUtil().setWidth(10),
                left: ScreenUtil().setWidth(5),
              ),
              child: Text(
                S.of(context).confirm_email,
                style: TextStyle(
                  fontSize: ScreenUtil().setSp(16),
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(
              child: confirmEmailField,
            ),
            SizedBox(height: ScreenUtil().setHeight(10.0)),
            Padding(
              padding: EdgeInsets.only(
                bottom: ScreenUtil().setWidth(10),
                left: ScreenUtil().setWidth(5),
              ),
              child: Text(
                S.of(context).password,
                style: TextStyle(
                  fontSize: ScreenUtil().setSp(16),
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(
              child: passwordField,
            ),
            SizedBox(height: ScreenUtil().setHeight(10.0)),
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
}
