import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:summarizeddebts/extensions/string_extensions.dart';
import 'package:summarizeddebts/generated/i18n.dart';
import 'package:summarizeddebts/model/monthly_income_model.dart';
import 'package:summarizeddebts/modules/debt/controller/monthly_income_controller.dart';
import 'package:summarizeddebts/modules/debt/screen/widget/monthly_income_list_widget.dart';
import 'package:summarizeddebts/ui/resources/app_dimen.dart';
import 'package:summarizeddebts/ui/utility/screen_utility.dart';
import 'package:summarizeddebts/ui/validation/common_form_validation.dart';
import 'package:summarizeddebts/ui/widget/appbar/custom_appbar.dart';
import 'package:summarizeddebts/ui/widget/dialog/alert_dialogs.dart';
import 'package:summarizeddebts/ui/widget/textformfield/custom_text_form_field.dart';

// ignore: must_be_immutable
class MonthlyIncomeScreen extends StatefulWidget {
  MonthlyIncomeScreen({Key key}) : super(key: key);

  @override
  _MonthlyIncomeScreenState createState() {
    return _MonthlyIncomeScreenState();
  }
}

class _MonthlyIncomeScreenState
    extends ModularState<MonthlyIncomeScreen, MonthlyIncomeController>
    with CommonFormValidation {
  final _formKey = GlobalKey<FormState>();

  MonthlyIncomeModel _monthlyIncomeModel = MonthlyIncomeModel();

  MaskedTextController _dateController;
  MoneyMaskedTextController _amountController;

  FocusNode _dueDateFocus;
  FocusNode _amountFocus;
  Locale _myLocale;

  @override
  void initState() {
    super.initState();
    this._dateController = ScreenUtility.monthYearTextController();

    _dueDateFocus = FocusNode();
    _amountFocus = FocusNode();

    //Load only when build is complete
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadData();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (this._myLocale == null)
      this._myLocale = Localizations.localeOf(context);

    if (this._amountController == null)
      this._amountController =
          ScreenUtility.moneyMaskedTextController(this._myLocale);
  }

  @override
  void dispose() {
    super.dispose();

    _dueDateFocus.dispose();
    _amountFocus.dispose();
  }

  @override
  Widget build(BuildContext context) {
    this.commonValidationContext = context;

    return Scaffold(
      appBar: CustomAppBar(
        appBarType: AppBarType.simple,
        title: S.of(context).monthly_income,
        showBackArrow: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            tooltip: S.of(context).save,
            onPressed: this.save,
          ),
        ],
      ),
      body: _body(),
    );
  }

  Widget _body() {
    return Container(
      height: MediaQuery.of(context).size.height,
      margin: EdgeInsets.only(
        bottom: ScreenUtil().setWidth(AppDimen.adMargin),
        top: ScreenUtil().setWidth(AppDimen.defaultMargin),
        left: ScreenUtil().setWidth(AppDimen.defaultMargin),
        right: ScreenUtil().setWidth(AppDimen.defaultMargin),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(
                          bottom: ScreenUtil().setWidth(10),
                        ),
                        child: Text(
                          S.of(context).month_year,
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
                            this._monthlyIncomeModel.month = value;
                          },
                          textInputAction: TextInputAction.next,
                          focusNode: _dueDateFocus,
                          validator: monthYearValidation,
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
                            this._monthlyIncomeModel.amount = this
                                ._amountController
                                .value
                                .text
                                .formattedToDouble(context);
                          },
                          textInputAction: TextInputAction.none,
                          focusNode: _amountFocus,
                          validator: requiredAndGreaterThanZero,
                          onFieldSubmitted: (term) {},
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: ScreenUtil().setHeight(AppDimen.sizedBoxSpace),
          ),
          Observer(
            builder: (context) {
              return MonthlyIncomeListWidget(
                items: controller.items,
                onDeletePressed: this.onDelete,
                onEditPressed: this.onEdit,
              );
            },
          ),
        ],
      ),
    );
  }

  save() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      AlertDialogs.showLoading(context, S.of(context).please_wait);

      await controller.save(this._monthlyIncomeModel);

      AlertDialogs.closeDialog(context);

      if (this.controller.isError) {
        AlertDialogs.showErrorDialog(
            context, S.of(context).app_name, controller.errorMessage);
      } else {
        this._monthlyIncomeModel = MonthlyIncomeModel();
        this._dateController.updateText("");
        this._amountController.updateValue(0.0);

        AlertDialogs.showSuccessDialog(context, S.of(context).success_title,
            S.of(context).saved_successfully, () {});
      }
    }
  }

  Future<void> loadData() async {
    AlertDialogs.showLoading(context, S.of(context).please_wait);

    await controller.consult();

    AlertDialogs.closeDialog(context);

    if (controller.isError) {
      AlertDialogs.showErrorDialog(
          context, S.of(context).app_name, controller.errorMessage);
    }
  }

  onEdit(index) {
    this._monthlyIncomeModel = controller.items[index];

    this._dateController.updateText(this._monthlyIncomeModel.month);
    this._amountController.updateValue(this._monthlyIncomeModel.amount);
  }

  onDelete(index) {
    AlertDialogs.showYesOrNoQuestion(
        context: context,
        title: S.of(context).confirm,
        message: S.of(context).confirm_delete_item,
        textButtonOne: S.of(context).yes.toUpperCase(),
        textButtonTwo: S.of(context).no.toUpperCase(),
        yesCallBackFunction: () async {
          await this.controller.delete(index);

          if (!this.controller.isError) {
            AlertDialogs.showSuccessDialog(context, S.of(context).success_title,
                S.of(context).register_delete_successfully, () {});
          } else {
            if (this.controller.errorMessage == null) {
              AlertDialogs.showErrorMessageDialog(
                  context,
                  S.of(context).app_name,
                  S.of(context).could_not_delete_register);
            } else {
              AlertDialogs.showErrorDialog(context, S.of(context).app_name,
                  this.controller.errorMessage);
            }
          }
        });
  }
}
