import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:summarizeddebts/common/utility.dart';
import 'package:summarizeddebts/extensions/double_extensions.dart';
import 'package:summarizeddebts/generated/i18n.dart';
import 'package:summarizeddebts/model/debt_detail_model.dart';
import 'package:summarizeddebts/modules/dashboard/screen/widget/dashboard_summary_item_widget_v2.dart';
import 'package:summarizeddebts/ui/resources/app_color.dart';
import 'package:summarizeddebts/ui/resources/app_dimen.dart';
import 'package:summarizeddebts/ui/resources/app_styles.dart';
import 'package:summarizeddebts/ui/widget/button/custom_button.dart';

class DashboardSummaryWidgetV2 extends StatelessWidget {
  final DebtDetailModel dashboardModel;
  final Function onSeeMoreTap;
  final Function onPreviousTap;
  final Function onNextTap;

  DashboardSummaryWidgetV2(
      {this.dashboardModel,
      this.onSeeMoreTap,
      this.onPreviousTap,
      this.onNextTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        left: ScreenUtil().setWidth(AppDimen.simpleMargin),
        right: ScreenUtil().setWidth(AppDimen.simpleMargin),
      ),
      child: Column(
        children: <Widget>[

          Text(
            Utility.parseToMonthDescription(dashboardModel.month, context),
            style: AppStyles.defaultTextStyle(
              fontSize: AppDimen.defaultTitleSize,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                S.of(context).monthly_income,
                style: AppStyles.defaultTextStyle(
                  fontSize: AppDimen.defaultLabelSubTitleSize,
                ),
              ),
              Text(
                dashboardModel.monthlyIncome.toCurrency(),
                style: AppStyles.defaultTextStyle(
                  fontSize: AppDimen.defaultLabelSubTitleSize,
                  color: AppColor.monthlyIncomeValueColor,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                S.of(context).expenses,
                style: AppStyles.defaultTextStyle(
                  fontSize: AppDimen.defaultLabelSubTitleSize,
                ),
              ),
              Text(
                dashboardModel.totalMonth.toCurrency(),
                style: AppStyles.defaultTextStyle(
                  fontSize: AppDimen.defaultLabelSubTitleSize,
                  color: AppColor.totalValueColor,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            decoration: new BoxDecoration(
              color: AppColor.boxColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: this.dashboardModel.debts == null ||
                    this.dashboardModel.debts.items == null ||
                    this.dashboardModel.debts.items.isEmpty
                ? Container(
                    height: ScreenUtil().setHeight(AppDimen.defaultBoxHeight),
                    child: Center(
                      child: Text(
                        this.dashboardModel.debts == null ||
                                this.dashboardModel.debts.items == null
                            ? ""
                            : S.of(context).do_not_have_expenses,
                        style: AppStyles.defaultTextStyle(
                            fontSize: AppDimen.defaultTitleSize),
                      ),
                    ),
                  )
                : DashboardSummaryItemWidgetV2(
                    debtModel: this.dashboardModel.debts,
                  ),
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                child: Row(
                  children: <Widget>[
                    CustomButton(
                      buttonColor: AppColor.darkGreenButton,
                      text: Text(
                        S.of(context).previous.toUpperCase(),
                        style: AppStyles.buttonTextStyle(
                          color: Colors.white,
                          fontSize: AppDimen.buttonTextSize,
                        ),
                      ),
                      onPress: this.onPreviousTap,
                    ),
                    SizedBox(width: ScreenUtil().setWidth(10)),
                    CustomButton(
                      buttonColor: AppColor.darkGreenButton,
                      text: Text(
                        S.of(context).next.toUpperCase(),
                        style: AppStyles.buttonTextStyle(
                          color: Colors.white,
                          fontSize: AppDimen.buttonTextSize,
                        ),
                      ),
                      onPress: this.onNextTap,
                    )
                  ],
                ),
              ),
              dashboardModel.totalMonth > 0
                  ? Align(
                      alignment: Alignment.centerRight,
                      child: CustomButton(
                        buttonColor: AppColor.greenButton,
                        text: Text(
                          S.of(context).see_more.toUpperCase(),
                          style: AppStyles.buttonTextStyle(
                            color: Colors.white,
                            fontSize: AppDimen.buttonTextSize,
                          ),
                        ),
                        onPress: this.onSeeMoreTap,
                      ),
                    )
                  : SizedBox(),
            ],
          ),
        ],
      ),
    );
  }
}
