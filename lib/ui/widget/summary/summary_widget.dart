import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:summarizeddebts/common/utility.dart';
import 'package:summarizeddebts/controller/summary/summary_controller.dart';
import 'package:summarizeddebts/extensions/double_extensions.dart';
import 'package:summarizeddebts/generated/i18n.dart';
import 'package:summarizeddebts/ui/resources/app_color.dart';
import 'package:summarizeddebts/ui/resources/app_dimen.dart';
import 'package:summarizeddebts/ui/resources/app_styles.dart';

// ignore: must_be_immutable
class SummaryWidget extends StatelessWidget {
  final String currentMonth;
  final bool showMonth;

  var controller = Modular.get<SummaryController>();

  SummaryWidget({
    Key key,
    @required this.currentMonth,
    this.showMonth = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    loadData();

    return Observer(
      builder: (BuildContext context) {
        return Column(
          children: <Widget>[
            this.showMonth
                ? Text(
                    Utility.parseToMonthDescription(
                        this.controller.monthlyExpensesModel.month, context),
                    style: AppStyles.defaultTextStyle(
                        fontSize: AppDimen.detailTitleSize),
                  )
                : Container(),
            SizedBox(height: ScreenUtil().setHeight(15)),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                new Text(
                  S.of(context).monthly_income,
                  style: AppStyles.defaultTextStyle(
                      fontSize: AppDimen.defaultTitleSize),
                ),
                new Text(
                  this.controller.monthlyExpensesModel.monthlyIncome.toCurrency(),
                  style: AppStyles.defaultTextStyle(
                      color: AppColor.monthlyIncomeValueColor,
                      fontSize: AppDimen.defaultTitleSize),
                ),
              ],
            ),
            SizedBox(height: ScreenUtil().setHeight(15)),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                new Text(
                  S.of(context).total_amount,
                  style: AppStyles.defaultTextStyle(
                      fontSize: AppDimen.defaultTitleSize),
                ),
                new Text(
                  this.controller.monthlyExpensesModel.total.toCurrency(),
                  style: AppStyles.defaultTextStyle(
                      color: AppColor.totalValueColor,
                      fontSize: AppDimen.defaultTitleSize),
                ),
              ],
            ),
            SizedBox(height: ScreenUtil().setHeight(15)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                new Text(
                  S.of(context).outstanding_debts,
                  style: AppStyles.defaultTextStyle(
                      fontSize: AppDimen.valueLabelSize),
                ),
                new Text(
                  this
                      .controller
                      .monthlyExpensesModel
                      .totalOutstanding
                      .toCurrency(),
                  style: AppStyles.defaultTextStyle(
                      fontSize: AppDimen.valueLabelSize,
                      color: AppColor.debtColor),
                ),
              ],
            ),
            SizedBox(height: ScreenUtil().setHeight(15)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                new Text(
                  S.of(context).debts_paid,
                  style: AppStyles.defaultTextStyle(
                      fontSize: AppDimen.valueLabelSize),
                ),
                new Text(
                  this.controller.monthlyExpensesModel.totalPaid.toCurrency(),
                  style: AppStyles.defaultTextStyle(
                      fontSize: AppDimen.valueLabelSize,
                      color: AppColor.creditColor),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  loadData() async {
    await controller.loadSummary(currentMonth);
  }
}
