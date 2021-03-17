import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:summarizeddebts/extensions/double_extensions.dart';
import 'package:summarizeddebts/generated/i18n.dart';
import 'package:summarizeddebts/modules/debt/screen/widget/edit_expense_widget_v2.dart';
import 'package:summarizeddebts/modules/reports/controller/report_by_month_controller.dart';
import 'package:summarizeddebts/ui/resources/app_color.dart';
import 'package:summarizeddebts/ui/resources/app_dimen.dart';
import 'package:summarizeddebts/ui/resources/app_styles.dart';
import 'package:summarizeddebts/ui/utility/screen_utility.dart';
import 'package:summarizeddebts/ui/validation/common_form_validation.dart';
import 'package:summarizeddebts/ui/widget/appbar/custom_appbar.dart';
import 'package:summarizeddebts/ui/widget/button/custom_button.dart';
import 'package:summarizeddebts/ui/widget/dialog/alert_dialogs.dart';
import 'package:summarizeddebts/ui/widget/divider/divider_widget.dart';
import 'package:summarizeddebts/ui/widget/summary/summary_widget.dart';
import 'package:summarizeddebts/ui/widget/textformfield/custom_text_form_field.dart';

class ReportByMonthScreen extends StatefulWidget {
  ReportByMonthScreen({Key key}) : super(key: key);

  @override
  _ReportByMonthScreenState createState() {
    return _ReportByMonthScreenState();
  }
}

class _ReportByMonthScreenState
    extends ModularState<ReportByMonthScreen, ReportByMonthController>
    with CommonFormValidation {
  MaskedTextController _dateController;
  final _formKey = GlobalKey<FormState>();

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
        title: S.of(context).report_by_month,
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
          DividerWidget(),
          Container(
            margin: EdgeInsets.only(
              left: ScreenUtil().setWidth(AppDimen.defaultMargin),
              right: ScreenUtil().setWidth(AppDimen.defaultMargin),
            ),
            child: Observer(
              builder: (BuildContext context) {
                return SummaryWidget(
                  showMonth: false,
                  currentMonth: this.controller.filter,
                );
              },
            ),
          ),
          SizedBox(
            height: ScreenUtil().setHeight(AppDimen.defaultMargin),
          ),
          DividerWidget(),
          SizedBox(
            height: ScreenUtil().setHeight(AppDimen.defaultMargin),
          ),
          _percentage(),
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
      margin: EdgeInsets.all(
        ScreenUtil().setWidth(AppDimen.defaultMargin),
      ),
      child: Form(
        key: _formKey,
        child: Row(
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
      ),
    );
  }

  Widget _percentage() {
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
              Observer(
                builder: (context) => Text(
                  this.controller.debtDetailModel.isIncrease
                      ? S.of(context).increase_over_last_month
                      : S.of(context).decrease_over_last_month,
                  style: AppStyles.defaultTextStyle(
                      fontSize: AppDimen.defaultLabelSubTitleSize),
                ),
              ),
              Observer(
                builder: (context) => Text(
                  this
                      .controller
                      .debtDetailModel
                      .totalDiffLastMonth
                      .toCurrency(),
                  style: AppStyles.defaultTextStyle(
                      color: AppColor.totalValueColor,
                      fontSize: AppDimen.defaultLabelSubTitleSize),
                ),
              ),
            ],
          ),
          SizedBox(
            height: ScreenUtil().setHeight(AppDimen.defaultMargin),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Observer(
                builder: (context) => Text(
                  this.controller.debtDetailModel.isIncrease
                      ? S.of(context).increase_percentage
                      : S.of(context).decrease_percentage,
                  style: AppStyles.defaultTextStyle(
                      fontSize: AppDimen.defaultLabelSubTitleSize),
                ),
              ),
              Observer(
                builder: (context) => Text(
                  "${controller.debtDetailModel.percentageDiffLastMonth}%",
                  style: AppStyles.defaultTextStyle(
                      color: AppColor.totalValueColor,
                      fontSize: AppDimen.defaultLabelSubTitleSize),
                ),
              ),
            ],
          )
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
    await controller.consultByMonth();

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
