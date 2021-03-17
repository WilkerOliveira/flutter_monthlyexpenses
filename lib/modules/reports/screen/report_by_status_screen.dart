import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:mobx/mobx.dart';
import 'package:summarizeddebts/extensions/double_extensions.dart';
import 'package:summarizeddebts/generated/i18n.dart';
import 'package:summarizeddebts/modules/debt/screen/widget/edit_expense_widget_v2.dart';
import 'package:summarizeddebts/modules/reports/controller/report_by_status_controller.dart';
import 'package:summarizeddebts/ui/resources/app_color.dart';
import 'package:summarizeddebts/ui/resources/app_dimen.dart';
import 'package:summarizeddebts/ui/resources/app_styles.dart';
import 'package:summarizeddebts/ui/utility/screen_utility.dart';
import 'package:summarizeddebts/ui/validation/common_form_validation.dart';
import 'package:summarizeddebts/ui/widget/appbar/custom_appbar.dart';
import 'package:summarizeddebts/ui/widget/button/custom_button.dart';
import 'package:summarizeddebts/ui/widget/dialog/alert_dialogs.dart';
import 'package:summarizeddebts/ui/widget/divider/divider_widget.dart';
import 'package:summarizeddebts/ui/widget/textformfield/custom_text_form_field.dart';

class ReportByStatusScreen extends StatefulWidget {
  ReportByStatusScreen({Key key}) : super(key: key);

  @override
  _ReportByStatusScreenState createState() {
    return _ReportByStatusScreenState();
  }
}

class _ReportByStatusScreenState
    extends ModularState<ReportByStatusScreen, ReportByStatusController>
    with CommonFormValidation {
  MaskedTextController _dateController;
  final _formKey = GlobalKey<FormState>();
  var _statusGroup = Observable(StatusReport.paid);

  @override
  void initState() {
    super.initState();

    this._dateController = ScreenUtility.monthYearTextController();

    //Load only when build is complete
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    this.commonValidationContext = context;

    return Scaffold(
      appBar: CustomAppBar(
        title: S.of(context).report_by_status,
        showBackArrow: true,
        appBarType: AppBarType.simple,
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
      ),
      child: Column(
        children: <Widget>[
          SizedBox(
            height: ScreenUtil().setHeight(5),
          ),
          _filter(),
          SizedBox(
            height: ScreenUtil().setHeight(AppDimen.defaultMargin),
          ),
          DividerWidget(),
          SizedBox(
            height: ScreenUtil().setHeight(AppDimen.defaultMargin),
          ),
          _summary(),
          SizedBox(
            height: ScreenUtil().setHeight(AppDimen.defaultMargin),
          ),
          _expenses(),
        ],
      ),
    );
  }

  Widget _filter() {
    return Container(
      margin: EdgeInsets.only(
        left: ScreenUtil().setWidth(AppDimen.defaultMargin),
        right: ScreenUtil().setWidth(AppDimen.defaultMargin),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: ListTile(
                    title: Text(
                      S.of(context).paid,
                      style: AppStyles.defaultTextStyle(fontSize: 18),
                    ),
                    leading: Observer(
                      builder: (context) => Radio(
                        value: StatusReport.paid,
                        groupValue: _statusGroup.value,
                        onChanged: (StatusReport value) {
                          runInAction(() => _statusGroup.value = value);
                          this.controller.setStatus(value);
                        },
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ListTile(
                    title: Text(
                      S.of(context).pending_expenses,
                      style: AppStyles.defaultTextStyle(fontSize: 18),
                    ),
                    leading: Observer(
                      builder: (context) => Radio(
                        value: StatusReport.notPaid,
                        groupValue: _statusGroup.value,
                        onChanged: (StatusReport value) {
                          runInAction(() => _statusGroup.value = value);
                          this.controller.setStatus(value);
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Text(
                      S.of(context).month_year,
                      style: AppStyles.defaultTextStyle(),
                    ),
                    SizedBox(
                      height: ScreenUtil().setHeight(15),
                    ),
                    SizedBox(
                      width: ScreenUtil().setWidth(150),
                      child: CustomTextFormField(
                        onFieldSubmitted: (value) {},
                        controller: this._dateController,
                        type: TextFormType.date,
                        onSaved: (String value) {
                          controller.filter = value;
                        },
                        textInputAction: TextInputAction.none,
                        validator: monthYearValidation,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: ScreenUtil().setWidth(22),
                  ),
                  child: CustomButton(
                    width: AppDimen.searchButtonWidth,
                    buttonColor: AppColor.greenButton,
                    text: Text(
                      S.of(context).search,
                      style: AppStyles.buttonTextStyle(
                        color: Colors.white,
                        fontSize: AppDimen.buttonTextSize,
                      ),
                    ),
                    onPress: () {
                      _onSearchPress();
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _summary() {
    return Container(
      margin: EdgeInsets.only(
        left: ScreenUtil().setWidth(AppDimen.defaultMargin),
        right: ScreenUtil().setWidth(AppDimen.defaultMargin),
      ),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                S.of(context).total_amount,
                style: AppStyles.defaultTextStyle(
                    fontSize: AppDimen.detailTitleSize),
              ),
              Observer(
                builder: (context) => Text(
                  this.controller.debtDetailModel.totalMonth.toCurrency(),
                  style: AppStyles.defaultTextStyle(
                      color: AppColor.totalValueColor,
                      fontSize: AppDimen.detailTitleSize),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _expenses() {
    return Observer(
      builder: (context) => Container(
        child: EditExpenseItemWidgetV2(
          isReport: true,
          debtModel: this.controller.debtDetailModel.debts,
          onItemChecked: (index) {},
        ),
      ),
    );
  }

  _loadData() async {
    AlertDialogs.showLoading(context, S.of(context).please_wait);

    this._dateController.updateText(this.controller.filter);
    await controller.consultByStatus();

    AlertDialogs.closeDialog(context);

    if (controller.isError) {
      AlertDialogs.showErrorDialog(
          context, S.of(context).app_name, controller.errorMessage);
    }
  }

  _onSearchPress() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      FocusScope.of(context).unfocus();

      this._loadData();
    }
  }
}
