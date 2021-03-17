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
import 'package:summarizeddebts/modules/reports/controller/report_by_local_to_pay_controller.dart';
import 'package:summarizeddebts/ui/resources/app_color.dart';
import 'package:summarizeddebts/ui/resources/app_dimen.dart';
import 'package:summarizeddebts/ui/resources/app_styles.dart';
import 'package:summarizeddebts/ui/utility/screen_utility.dart';
import 'package:summarizeddebts/ui/validation/common_form_validation.dart';
import 'package:summarizeddebts/ui/widget/appbar/custom_appbar.dart';
import 'package:summarizeddebts/ui/widget/button/custom_button.dart';
import 'package:summarizeddebts/ui/widget/charts/dashboard_bar_chart.dart';
import 'package:summarizeddebts/ui/widget/dialog/alert_dialogs.dart';
import 'package:summarizeddebts/ui/widget/divider/divider_widget.dart';
import 'package:summarizeddebts/ui/widget/dropdownbutton/local_to_pay_widget.dart';
import 'package:summarizeddebts/ui/widget/textformfield/custom_text_form_field.dart';

class ReportByLocalToPayScreen extends StatefulWidget {
  ReportByLocalToPayScreen({Key key}) : super(key: key);

  @override
  _ReportByLocalToPayScreenState createState() {
    return _ReportByLocalToPayScreenState();
  }
}

class _ReportByLocalToPayScreenState
    extends ModularState<ReportByLocalToPayScreen, ReportByLocalToPayController>
    with CommonFormValidation {
  MaskedTextController _dateController;
  final _formKey = GlobalKey<FormState>();
  Observable<String> _localToPaySelected = Observable("");
  var showChart = Observable(false);

  @override
  void initState() {
    super.initState();

    this._dateController = ScreenUtility.monthYearTextController();

    //Load only when build is complete
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initPage();
    });
  }

  @override
  Widget build(BuildContext context) {
    this.commonValidationContext = context;

    return Scaffold(
      appBar: CustomAppBar(
        title: S.of(context).report_by_local_to_pay,
        showBackArrow: true,
        appBarType: AppBarType.simple,
        actions: [
          Observer(
            builder: (context) => this.showChart.value
                ? IconButton(
                    iconSize: 32,
                    icon: const Icon(
                      Icons.view_list,
                      color: AppColor.menuChartColor,
                    ),
                    tooltip: S.of(context).show_list,
                    onPressed: this.onChartPressed,
                  )
                : IconButton(
                    iconSize: 32,
                    icon: const Icon(
                      Icons.insert_chart,
                      color: AppColor.menuChartColor,
                    ),
                    tooltip: S.of(context).show_chart,
                    onPressed: this.onChartPressed,
                  ),
          )
        ],
      ),
      body: SingleChildScrollView(child: _body()),
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
          _summarized(),
          Observer(
            builder: (context) {
              return this.showChart.value ? _chart() : _expenses();
            },
          ),
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
            LocalToPayWidget(
              localToPayList: controller.localToPayList,
              localToPaySelected: _localToPaySelected,
            ),
            SizedBox(
              height: ScreenUtil().setHeight(15),
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
                          controller.monthFilter = value;
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

  Widget _summarized() {
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
                    fontSize: AppDimen.defaultTitleSize),
              ),
              Observer(
                builder: (context) => Text(
                  this.controller.debtDetailModel.totalMonth.toCurrency(),
                  style: AppStyles.defaultTextStyle(
                      color: AppColor.totalValueColor,
                      fontSize: AppDimen.defaultTitleSize),
                ),
              ),
            ],
          ),
          SizedBox(
            height: ScreenUtil().setHeight(AppDimen.defaultMargin),
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

  Widget _chart() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Flexible(
          fit: FlexFit.loose,
          child: Container(
            margin: EdgeInsets.only(
              left: ScreenUtil().setWidth(AppDimen.defaultMargin),
              right: ScreenUtil().setWidth(AppDimen.defaultMargin),
              bottom: ScreenUtil().setWidth(AppDimen.defaultMargin),
            ),
            height: ScreenUtil().setHeight(400.0),
            child: ListView(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              children: <Widget>[
                Container(
                  width: ScreenUtil().setWidth(
                      this.controller.localToPayList != null &&
                              this.controller.localToPayList.length > 4
                          ? 2000.0
                          : 500.0),
                  child: Observer(
                    name: "dataChart",
                    builder: (context) {
                      return DashboardBarChart(
                        animate: true,
                        debts: controller.debtDetailModel.chartData,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  _initPage() async {
    this._dateController.updateText(this.controller.monthFilter);
    this._loadLocalToPay();
    this._loadData();
  }

  _loadLocalToPay() async {
    await this.controller.consultLocalToPay();

    if (this.controller.isAlert) {
      AlertDialogs.showInfoDialog(
          context, S.of(context).app_name, controller.errorMessage);
    } else if (controller.isError) {
      AlertDialogs.showErrorDialog(
          context, S.of(context).app_name, controller.errorMessage);
    }
  }

  _loadData() async {
    AlertDialogs.showLoading(context, S.of(context).please_wait);

    this.controller.localToPayFilter = this._localToPaySelected.value;

    await controller.consultByLocalToPay();

    AlertDialogs.closeDialog(context);

    if (this.controller.isAlert) {
      AlertDialogs.showInfoDialog(
          context, S.of(context).app_name, controller.errorMessage);
    } else if (controller.isError) {
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

  onChartPressed() {
    if (this.controller.debtDetailModel.chartData != null &&
        this.controller.debtDetailModel.chartData.isNotEmpty) {
      runInAction(() => this.showChart.value = !this.showChart.value);
    }
  }
}
