import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:mobx/mobx.dart';
import 'package:summarizeddebts/extensions/string_extensions.dart';
import 'package:summarizeddebts/generated/i18n.dart';
import 'package:summarizeddebts/model/expense_model.dart';
import 'package:summarizeddebts/modules/debt/controller/debt_controller.dart';
import 'package:summarizeddebts/modules/debt/debt_module.dart';
import 'package:summarizeddebts/ui/resources/app_color.dart';
import 'package:summarizeddebts/ui/resources/app_dimen.dart';
import 'package:summarizeddebts/ui/resources/app_styles.dart';
import 'package:summarizeddebts/ui/utility/screen_utility.dart';
import 'package:summarizeddebts/ui/validation/common_form_validation.dart';
import 'package:summarizeddebts/ui/widget/appbar/custom_appbar.dart';
import 'package:summarizeddebts/ui/widget/button/custom_button.dart';
import 'package:summarizeddebts/ui/widget/dialog/alert_dialogs.dart';
import 'package:summarizeddebts/ui/widget/dropdownbutton/local_to_pay_widget.dart';
import 'package:summarizeddebts/ui/widget/textformfield/custom_text_form_field.dart';

class RegisterDebtScreen extends StatefulWidget {
  final String registerId;

  const RegisterDebtScreen({Key key, this.registerId}) : super(key: key);

  @override
  _RegisterDebtScreenState createState() {
    return _RegisterDebtScreenState();
  }
}

class _RegisterDebtScreenState
    extends ModularState<RegisterDebtScreen, DebtController>
    with CommonFormValidation {
  final _formKey = GlobalKey<FormState>();

  MaskedTextController _dateController;
  MoneyMaskedTextController _amountController;
  TextEditingController _descriptionController;

  MaskedTextController _totalRecurrentController;

  FocusNode _dueDateFocus;
  FocusNode _amountFocus;
  FocusNode _descriptionFocus;

  FocusNode _recurringFocus;
  FocusNode _localToPayFocus;

  Observable<String> _localToPaySelected = Observable("");
  ObservableList<DropdownMenuItem<String>> _localToPayItems =
      ObservableList.of([]);

  Observable<bool> _recurringDebt = Observable(false);
  Observable<bool> _directDebt = Observable(false);
  Locale _myLocale;

  @override
  void initState() {
    super.initState();

    this._dateController = ScreenUtility.dateMaskedTextController();
    this._descriptionController = TextEditingController();
    this._totalRecurrentController = ScreenUtility.maskedTextController("00");

    _dueDateFocus = FocusNode();
    _amountFocus = FocusNode();
    _descriptionFocus = FocusNode();
    _recurringFocus = FocusNode();
    _localToPayFocus = FocusNode();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (this._myLocale == null)
      this._myLocale = Localizations.localeOf(context);

    this._amountController =
        ScreenUtility.moneyMaskedTextController(this._myLocale);

    //Load only when build is complete
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadData();
    });
  }

  @override
  void dispose() {
    super.dispose();

    _dueDateFocus.dispose();
    _amountFocus.dispose();
    _descriptionFocus.dispose();
    _recurringFocus.dispose();
    _localToPayFocus.dispose();
  }

  @override
  Widget build(BuildContext context) {
    this.commonValidationContext = context;

    return Scaffold(
      appBar: CustomAppBar(
        appBarType: AppBarType.simple,
        showBackArrow: true,
        showDrawer: false,
        title: S.of(context).new_expense,
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            tooltip: S.of(context).save,
            onPressed: save,
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            tooltip: S.of(context).delete,
            onPressed: this.delete,
          ),
          IconButton(
            icon: const Icon(Icons.insert_drive_file),
            tooltip: S.of(context).clear,
            onPressed: this.clearForm,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: _body(),
      ),
    );
  }

  Widget _body() {
    return Container(
      margin: EdgeInsets.only(
        bottom: ScreenUtil().setWidth(AppDimen.adMargin),
        top: ScreenUtil().setWidth(AppDimen.defaultMargin),
        left: ScreenUtil().setWidth(AppDimen.defaultMargin),
        right: ScreenUtil().setWidth(AppDimen.defaultMargin),
      ),
      child: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.only(
              top: ScreenUtil().setWidth(AppDimen.defaultMargin)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(
                          bottom: ScreenUtil().setWidth(10),
                        ),
                        child: Text(
                          S.of(context).due_date,
                          style: TextStyle(
                            fontSize: ScreenUtil().setSp(16),
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: ScreenUtil().setWidth(150),
                        child: CustomTextFormField(
                          controller: this._dateController,
                          type: TextFormType.date,
                          onSaved: (String value) {
                            controller.currentExpense.dueDate = value;
                          },
                          textInputAction: TextInputAction.none,
                          focusNode: _dueDateFocus,
                          validator: dateValidation,
                          onFieldSubmitted: (term) {
                            ScreenUtility.fieldFocusChange(
                                context, _dueDateFocus, _amountFocus);
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: ScreenUtil().setHeight(5.0)),
                  Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(
                          bottom: ScreenUtil().setWidth(10),
                        ),
                        child: Text(
                          S.of(context).amount,
                          style: TextStyle(
                            fontSize: ScreenUtil().setSp(16),
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: ScreenUtil().setWidth(200),
                        child: CustomTextFormField(
                          controller: this._amountController,
                          type: TextFormType.money,
                          onSaved: (String value) {
                            controller.currentExpense.amount = _amountController
                                .value.text
                                .formattedToDouble(context);
                          },
                          textInputAction: TextInputAction.none,
                          focusNode: _amountFocus,
                          validator: requiredAndGreaterThanZero,
                          onFieldSubmitted: (term) {
                            ScreenUtility.fieldFocusChange(
                                context, _amountFocus, _descriptionFocus);
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: ScreenUtil().setHeight(15.0)),
              Padding(
                padding: EdgeInsets.only(
                  bottom: ScreenUtil().setWidth(10),
                ),
                child: Text(
                  S.of(context).description,
                  style: TextStyle(
                    fontSize: ScreenUtil().setSp(16),
                    color: Colors.white,
                  ),
                ),
              ),
              CustomTextFormField(
                controller: this._descriptionController,
                maxLength: 50,
                type: TextFormType.simple,
                onSaved: (String value) {
                  controller.currentExpense.description = value.trim();
                },
                textInputAction: TextInputAction.none,
                focusNode: _descriptionFocus,
                validator: requiredField,
                onFieldSubmitted: (term) {
                  ScreenUtility.fieldFocusChange(
                      context, _descriptionFocus, _localToPayFocus);
                },
              ),
              SizedBox(height: ScreenUtil().setHeight(15.0)),
              Padding(
                padding: EdgeInsets.only(
                  bottom: ScreenUtil().setWidth(10),
                ),
                child: Text(
                  S.of(context).local_to_pay,
                  style: TextStyle(
                    fontSize: ScreenUtil().setSp(16),
                    color: Colors.white,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: Observer(
                      builder: (context) {
                        return LocalToPayWidget(
                          focusNode: _localToPayFocus,
                          localToPayList: controller.localToPayList,
                          localToPaySelected: _localToPaySelected,
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    width: ScreenUtil().setWidth(15),
                  ),
                  CustomButton(
                    onPress: onNewLocalToPayPress,
                    isCircular: true,
                    text: Text(
                      S.of(context).plus,
                      style: AppStyles.defaultTextStyle(
                          color: AppColor.greenButton,
                          fontSize: ScreenUtil().setSp(24)),
                    ),
                    buttonColor: AppColor.topHead,
                    radius: AppDimen.defaultRadiusButton,
                    width: 46.0,
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Text(
                    S.of(context).direct_debt,
                    style: AppStyles.defaultTextStyle(),
                  ),
                  Observer(
                    builder: (context) => Checkbox(
                      activeColor: AppColor.green,
                      value: this._directDebt.value,
                      onChanged: (bool value) {
                        runInAction(() {
                          this._directDebt.value = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
              Observer(
                builder: (context) => !this.controller.isRecurringExpense
                    ? Row(
                        children: <Widget>[
                          Text(
                            S.of(context).recurring_expenses,
                            style: AppStyles.defaultTextStyle(),
                          ),
                          Theme(
                            data: Theme.of(context).copyWith(
                              unselectedWidgetColor: Colors.white,
                            ),
                            child: Checkbox(
                              checkColor: Colors.white,
                              activeColor: AppColor.green,
                              value: this._recurringDebt.value,
                              onChanged: (bool value) {
                                runInAction(() {
                                  this._recurringDebt.value = value;
                                  this._totalRecurrentController.updateText("");
                                });
                              },
                            ),
                          ),
                        ],
                      )
                    : Container(),
              ),
              Observer(
                builder: (context) => this._recurringDebt.value
                    ? Column(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(
                              bottom: ScreenUtil().setWidth(10),
                            ),
                            child: Text(
                              S.of(context).repeat_for,
                              style: TextStyle(
                                fontSize: ScreenUtil().setSp(16),
                                color: Colors.white,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: ScreenUtil().setWidth(120),
                            child: CustomTextFormField(
                              controller: _totalRecurrentController,
                              maxLength: 2,
                              isEnabled: this._recurringDebt.value,
                              type: TextFormType.number,
                              onSaved: (String value) {
                                controller.currentExpense.totalRecurrent =
                                    int.tryParse(value) ?? 0;
                              },
                              textInputAction: TextInputAction.none,
                              focusNode: _recurringFocus,
                              onFieldSubmitted: (term) {},
                            ),
                          ),
                        ],
                      )
                    : Container(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  loadData() async {
    AlertDialogs.showLoading(context, S.of(context).please_wait);

    await controller.consultLocalToPay();

    if (widget.registerId != null && widget.registerId.isNotEmpty) {
      await controller.getById(widget.registerId);
    }

    AlertDialogs.closeDialog(context);

    if (this.controller.isAlert) {
      AlertDialogs.showInfoDialog(
          context, S.of(context).app_name, controller.errorMessage);
    } else if (this.controller.isError) {
      AlertDialogs.showErrorDialog(
          context, S.of(context).app_name, controller.errorMessage);
    } else {
      if (controller.currentExpense != null &&
          controller.currentExpense.id != null &&
          controller.currentExpense.id.isNotEmpty) {
        loadExpense();
      }
    }
  }

  loadExpense() {
    this._dateController.updateText(this.controller.currentExpense.dueDate);
    this._amountController.updateValue(this.controller.currentExpense.amount);

    this._descriptionController.text =
        this.controller.currentExpense.description;
    runInAction(() => _localToPaySelected.value =
        this.controller.currentExpense.localToPayId);
    runInAction(() =>
        this._directDebt.value = this.controller.currentExpense.directDebt);
    runInAction(() =>
        this._recurringDebt.value = this.controller.currentExpense.recurrent);
    if (this.controller.currentExpense.recurrent)
      this
          ._totalRecurrentController
          .updateText(this.controller.currentExpense.totalRecurrent.toString());
  }

  List<DropdownMenuItem<String>> mountDropdownMenuItems(localToPayList) {
    _localToPayItems = ObservableList.of([]);
    _localToPayItems.add(
      DropdownMenuItem<String>(
        child: Text(S.of(context).select_local_to_pay),
        value: "",
      ),
    );

    if (controller.localToPayList != null) {
      controller.localToPayList.forEach((item) {
        _localToPayItems.add(
          DropdownMenuItem<String>(
            child: Text(
              item.description,
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            value: item.id,
          ),
        );
      });
    }

    return _localToPayItems.toList();
  }

  onNewLocalToPayPress() async {
    await Navigator.pushNamed(
        context, DebtModule.initial + DebtModule.localToPay);
    this.loadData();
  }

  save() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      bool recurringRemoved = controller.currentExpense.recurrent != null &&
          controller.currentExpense.recurrent != null &&
          controller.currentExpense.recurrent &&
          !this._recurringDebt.value;

      bool currentRecurring = controller.currentExpense.recurrent != null &&
          controller.currentExpense.recurrent;

      controller.currentExpense.localToPayId = this._localToPaySelected.value;
      controller.currentExpense.localToPayName =
          controller.getLocalToPayName(this._localToPaySelected.value);
      controller.currentExpense.directDebt = this._directDebt.value;
      controller.currentExpense.recurrent = this._recurringDebt.value;
      controller.currentExpense.removeRecurring = false;

      if (recurringRemoved) {
        AlertDialogs.showYesOrNoQuestion(
            context: context,
            title: S.of(context).confirm,
            message: S.of(context).confirm_remove_recurring_expenses,
            textButtonOne: S.of(context).yes.toUpperCase(),
            textButtonTwo: S.of(context).no.toUpperCase(),
            yesCallBackFunction: () async {
              this.controller.currentExpense.applyChanges = false;
              this.controller.currentExpense.removeRecurring = true;
              this._confirmSave();
            });
      } else if (currentRecurring &&
          this.controller.currentExpense.recurrent &&
          this.controller.currentExpense.id != null &&
          this.controller.currentExpense.id.isNotEmpty) {
        AlertDialogs.showYesOrNoQuestion(
            context: context,
            title: S.of(context).confirm,
            message: S.of(context).confirm_apply_changes_recurring_expenses,
            textButtonOne: S.of(context).yes.toUpperCase(),
            textButtonTwo: S.of(context).only_this.toUpperCase(),
            yesCallBackFunction: () async {
              this.controller.currentExpense.applyChanges = true;
              this._confirmSave();
            },
            noCallBackFunction: () {
              this.controller.currentExpense.applyChanges = false;
              this._confirmSave();
            });
      } else {
        this.controller.currentExpense.applyChanges = true;
        this._confirmSave();
      }
    }
  }

  _confirmSave() async {
    AlertDialogs.showLoading(context, S.of(context).please_wait);

    await controller.save();

    AlertDialogs.closeDialog(context);

    if (this.controller.isAlert) {
      AlertDialogs.showInfoDialog(
          context, S.of(context).app_name, controller.errorMessage);
    } else if (this.controller.isError) {
      AlertDialogs.showErrorDialog(
          context, S.of(context).app_name, controller.errorMessage);
    } else {
      AlertDialogs.showSuccessDialog(context, S.of(context).success_title,
          S.of(context).saved_successfully, () {});
      this.clearForm();
    }
  }

  clearForm() {
    this.controller.currentExpense = ExpenseModel();
    this._dateController.updateText("");
    this._amountController.updateValue(0.0);
    this._descriptionController.clear();
    runInAction(() => _localToPaySelected.value = "");
    runInAction(() => this._directDebt.value = false);
    runInAction(() => this._recurringDebt.value = false);
    this._totalRecurrentController.updateText("");
  }

  delete() {
    if (this.controller.currentExpense != null &&
        this.controller.currentExpense.id != null &&
        this.controller.currentExpense.id.isNotEmpty) {
      bool isRecurring = controller.currentExpense.recurrent != null &&
          controller.currentExpense.recurrent;

      AlertDialogs.showYesOrNoQuestion(
          context: context,
          title: S.of(context).confirm,
          message: isRecurring
              ? S.of(context).confirm_remove_recurring_expenses
              : S.of(context).confirm_delete_debt,
          textButtonOne: S.of(context).yes.toUpperCase(),
          textButtonTwo: S.of(context).no.toUpperCase(),
          yesCallBackFunction: () async {
            AlertDialogs.showLoading(context, S.of(context).please_wait);

            await this.controller.delete();

            AlertDialogs.closeDialog(context);

            if (this.controller.isAlert) {
              AlertDialogs.showAlertToast(
                  context, this.controller.errorMessage);
            } else if (!this.controller.isError) {
              AlertDialogs.showSuccessDialog(
                  context,
                  S.of(context).success_title,
                  S.of(context).delete_successfully, () {
                this.clearForm();
              });
            } else {
              AlertDialogs.showErrorDialog(context, S.of(context).app_name,
                  this.controller.errorMessage);
            }
          });
    }
  }
}
