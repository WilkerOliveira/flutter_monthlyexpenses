import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:mobx/mobx.dart';
import 'package:summarizeddebts/extensions/double_extensions.dart';
import 'package:summarizeddebts/extensions/string_extensions.dart';
import 'package:summarizeddebts/generated/i18n.dart';
import 'package:summarizeddebts/modules/debt/debt_module.dart';
import 'package:summarizeddebts/modules/debt/screen/widget/expenses_list_widget.dart';
import 'package:summarizeddebts/modules/reports/controller/report_by_year_controller.dart';
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
import 'package:summarizeddebts/ui/widget/textformfield/custom_text_form_field.dart';

class ReportByYearScreen extends StatefulWidget {
  ReportByYearScreen({Key key}) : super(key: key);

  @override
  _ReportByYearScreenState createState() {
    return _ReportByYearScreenState();
  }
}

class _ReportByYearScreenState
    extends ModularState<ReportByYearScreen, ReportByYearController>
    with CommonFormValidation {
  MaskedTextController _yearController;
  final _formKey = GlobalKey<FormState>();
  var showChart = Observable(false);

  @override
  void initState() {
    super.initState();

    this._yearController = ScreenUtility.yearMaskedTextController();

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
        title: S.of(context).report_by_year,
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
          _filter(),
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
      margin: EdgeInsets.all(ScreenUtil().setWidth(AppDimen.defaultMargin)),
      child: Form(
        key: _formKey,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              children: <Widget>[
                Text(
                  S.of(context).year,
                  style: AppStyles.defaultTextStyle(),
                ),
                SizedBox(
                  height: ScreenUtil().setHeight(15),
                ),
                SizedBox(
                  width: ScreenUtil().setWidth(100),
                  child: CustomTextFormField(
                    onFieldSubmitted: (value) {},
                    controller: this._yearController,
                    type: TextFormType.number,
                    onSaved: (String value) {
                      controller.filter = value;
                    },
                    textInputAction: TextInputAction.none,
                    validator: yearValidation,
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
                  this.controller.reportModel.total.toCurrency(),
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
      builder: (context) => ExpensesListWidget(
        scrollEnabled: false,
        showEditButton: false,
        items: controller.reportModel.items,
        onDetailPressed: this.onSeeMorePress,
        onEditPressed: (index) {},
        onItemChecked: (index) {},
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
                  width: ScreenUtil().setWidth(2000.0),
                  child: Observer(
                    name: "dataChart",
                    builder: (context) {
                      return DashboardBarChart(
                        animate: true,
                        debts: controller.reportModel.chartData,
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

  _loadData() async {
    AlertDialogs.showLoading(context, S.of(context).please_wait);

    this._yearController.updateText(this.controller.filter);
    await controller.consultByYear();

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

  onSeeMorePress(index) async {
    await Navigator.pushNamed(context, DebtModule.detailDebt,
        arguments: controller.reportModel.items[index].month
            .parseMonthYearToDateTime());
    this._loadData();
  }

  onChartPressed() {
    if (this.controller.reportModel.chartData != null &&
        this.controller.reportModel.chartData.isNotEmpty) {
      runInAction(() => this.showChart.value = !this.showChart.value);
    }
  }
}
