import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:summarizeddebts/extensions/double_extensions.dart';
import 'package:summarizeddebts/model/summarized_expenses_model.dart';
import 'package:summarizeddebts/ui/resources/app_color.dart';
import 'package:summarizeddebts/ui/resources/app_dimen.dart';
import 'package:summarizeddebts/ui/resources/app_styles.dart';
import 'package:summarizeddebts/ui/utility/screen_utility.dart';
import 'package:summarizeddebts/ui/widget/divider/divider_widget.dart';

class DashboardSummaryItemWidgetV2 extends StatelessWidget {
  final SummarizedExpensesModel debtModel;

  DashboardSummaryItemWidgetV2({this.debtModel});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(
            left: ScreenUtil().setWidth(AppDimen.defaultMargin),
            right: ScreenUtil().setWidth(AppDimen.defaultMargin),
            bottom: ScreenUtil().setWidth(AppDimen.defaultMargin),
          ),
          child: ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            // Let the ListView know how many items it needs to build.
            itemCount: this.debtModel.items.length,
            itemBuilder: (BuildContext context, int index) {
              return Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Flexible(
                        child: Text(
                          ScreenUtility.formatDueDateDescription(
                              this.debtModel.items[index].dueDate,
                              this.debtModel.items[index].description),
                          style: AppStyles.defaultTextStyle(
                            fontSize: AppDimen.simpleTextSize,
                          ),
                        ),
                      ),
                      Text(
                        this.debtModel.items[index].amount.toCurrency(),
                        style: AppStyles.defaultTextStyle(
                          color: this.debtModel.items[index].paid
                              ? AppColor.creditColor
                              : AppColor.debtColor,
                          fontSize: AppDimen.simpleTextSize,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      Text(
                        this.debtModel.items[index].localToPayName == null
                            ? ""
                            : this.debtModel.items[index].localToPayName,
                        style: AppStyles.defaultTextStyle(
                          fontSize: AppDimen.simpleSubTileTextSize,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  DividerWidget(),
                  SizedBox(
                    height: 5,
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
