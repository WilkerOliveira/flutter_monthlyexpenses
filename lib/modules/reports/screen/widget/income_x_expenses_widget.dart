import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobx/mobx.dart';
import 'package:summarizeddebts/common/utility.dart';
import 'package:summarizeddebts/extensions/double_extensions.dart';
import 'package:summarizeddebts/generated/i18n.dart';
import 'package:summarizeddebts/modules/reports/model/report_expense_model.dart';
import 'package:summarizeddebts/ui/resources/app_color.dart';
import 'package:summarizeddebts/ui/resources/app_dimen.dart';
import 'package:summarizeddebts/ui/resources/app_styles.dart';

class IncomeXExpensesWidget extends StatelessWidget {
  final ObservableList<ReportExpenseModel> items;
  final bool scrollEnabled;

  IncomeXExpensesWidget(
      {Key key, @required this.items, this.scrollEnabled = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        bottom: ScreenUtil().setWidth(0),
      ),
      child: this.items == null || this.items.isEmpty
          ? Center(
              child: Text(
                this.items == null ? "" : S.of(context).do_not_have_expenses,
                style: AppStyles.defaultTextStyle(
                    fontSize: AppDimen.defaultTitleSize),
              ),
            )
          : ListView.builder(
              physics: this.scrollEnabled
                  ? null
                  : const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: items.length,
              itemBuilder: (context, int index) {
                return Card(
                  color: AppColor.boxColor,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(left: AppDimen.defaultMargin),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(
                              height: AppDimen.simpleMargin,
                            ),
                            Text(
                              Utility.parseToMonthDescription(
                                  this.items[index].month, context),
                              style: AppStyles.defaultTextStyle(
                                fontSize: AppDimen.simpleTextSize,
                              ),
                            ),
                            SizedBox(
                              height: 22,
                            ),
                            Icon(
                              this.items[index].isPositive
                                  ? Icons.thumb_up
                                  : Icons.thumb_down,
                              size: 32.0,
                              color: this.items[index].isPositive
                                  ? AppColor.creditColor
                                  : AppColor.debtColor,
                            ),
                            SizedBox(
                              height: AppDimen.simpleMargin,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: AppDimen.defaultMargin),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            SizedBox(
                              height: AppDimen.simpleMargin,
                            ),
                            RichText(
                              text: TextSpan(
                                text: S.of(context).monthly_income_report,
                                style: AppStyles.defaultTextStyle(
                                  fontSize: AppDimen.simpleTextSize,
                                ),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: this.items[index].income.toCurrency(),
                                    style: AppStyles.defaultTextStyle(
                                      color: AppColor.monthlyIncomeValueColor,
                                      fontSize: AppDimen.simpleTextSize,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: AppDimen.defaultMargin,
                            ),
                            RichText(
                              text: TextSpan(
                                text: S.of(context).total_expesnses,
                                style: AppStyles.defaultTextStyle(
                                  fontSize: AppDimen.simpleTextSize,
                                ),
                                children: <TextSpan>[
                                  TextSpan(
                                    text:
                                        this.items[index].expenses.toCurrency(),
                                    style: AppStyles.defaultTextStyle(
                                      color: AppColor.debtColor,
                                      fontSize: AppDimen.simpleTextSize,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: AppDimen.defaultMargin,
                            ),
                            RichText(
                              text: TextSpan(
                                text: S.of(context).balance,
                                style: AppStyles.defaultTextStyle(
                                  fontSize: AppDimen.valueLabelSize,
                                ),
                                children: <TextSpan>[
                                  TextSpan(
                                    text:
                                        this.items[index].balance.toCurrency(),
                                    style: AppStyles.defaultTextStyle(
                                      color: this.items[index].isPositive
                                          ? AppColor.creditColor
                                          : AppColor.debtColor,
                                      fontSize: AppDimen.valueLabelSize,
                                    ).copyWith(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: AppDimen.simpleMargin,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
