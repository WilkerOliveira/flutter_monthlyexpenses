import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:mobx/mobx.dart';
import 'package:summarizeddebts/extensions/double_extensions.dart';
import 'package:summarizeddebts/generated/i18n.dart';
import 'package:summarizeddebts/model/summarized_expenses_model.dart';
import 'package:summarizeddebts/ui/resources/app_color.dart';
import 'package:summarizeddebts/ui/resources/app_dimen.dart';
import 'package:summarizeddebts/ui/resources/app_styles.dart';
import 'package:summarizeddebts/ui/utility/screen_utility.dart';

// ignore: must_be_immutable
class EditExpenseItemWidgetV2 extends StatelessWidget {
  final SummarizedExpensesModel debtModel;
  final Function onItemChecked;
  final Function onEditPress;
  final bool isEditing;
  final bool isReport;

  EditExpenseItemWidgetV2(
      {@required this.debtModel,
      this.onItemChecked,
      this.isEditing = false,
      this.onEditPress,
      this.isReport = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(
              bottom: ScreenUtil().setWidth(AppDimen.defaultMargin)),
          child:
              this.debtModel.items == null || this.debtModel.items.length == 0
                  ? Center(
                      child: Text(
                      this.debtModel.items == null
                          ? ""
                          : S.of(context).do_not_have_expenses,
                      style: AppStyles.defaultTextStyle(
                          fontSize: AppDimen.defaultTitleSize),
                    ))
                  : ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      // Let the ListView know how many items it needs to build.
                      itemCount: this.debtModel.items.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Column(
                          children: <Widget>[
                            Card(
                              color: AppColor.boxColor,
                              child: this.isReport
                                  ? reportTile(index, context)
                                  : this.isEditing
                                      ? editTile(index, context)
                                      : Observer(
                                          builder: (context) {
                                            return detailTile(index, context);
                                          },
                                        ),
                            ),
                          ],
                        );
                      },
                    ),
        ),
      ],
    );
  }

  Widget editTile(index, context) {
    return GestureDetector(
      onTap: () {
        this.onEditPress(index);
      },
      child: ListTile(
        leading: Icon(
          Icons.edit,
          color: AppColor.greenButton,
        ),
        title: getTitle(index),
        subtitle: getSubTitle(index, context),
      ),
    );
  }

  Widget detailTile(index, context) {
    return CheckboxListTile(
      activeColor: AppColor.green,
      title: Row(
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
      subtitle: Column(
        children: <Widget>[
          SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Flexible(
                child: Text(
                  this.debtModel.items[index].localToPayName,
                  style: AppStyles.defaultTextStyle(
                    fontSize: AppDimen.simpleSubTileTextSize,
                  ),
                ),
              ),
              Text(
                this.debtModel.items[index].directDebt
                    ? S.of(context).direct_debt
                    : "",
                style: AppStyles.defaultTextStyle(
                    fontSize: AppDimen.simpleSubTileTextSize,
                    color: AppColor.directDebtColor),
              ),
            ],
          ),
        ],
      ),
      value: this.debtModel.items[index].isSelected.value,
      controlAffinity: ListTileControlAffinity.leading,
      onChanged: (bool value) {
        runInAction(() => this.debtModel.items[index].isSelected.value = value);
        this.onItemChecked(index);
      },
    );
  }

  Widget reportTile(index, context) {
    return ListTile(
      title: getTitle(index),
      subtitle: getSubTitle(index, context),
    );
  }

  Widget getTitle(index) {
    return Row(
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
    );
  }

  Widget getSubTitle(index, context) {
    return Column(
      children: <Widget>[
        SizedBox(
          height: 5,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Flexible(
              child: Text(
                this.debtModel.items[index].localToPayName,
                style: AppStyles.defaultTextStyle(
                  fontSize: AppDimen.simpleSubTileTextSize,
                ),
              ),
            ),
            Text(
              this.debtModel.items[index].directDebt
                  ? S.of(context).direct_debt
                  : "",
              style: AppStyles.defaultTextStyle(
                  fontSize: AppDimen.simpleSubTileTextSize,
                  color: AppColor.directDebtColor),
            ),
          ],
        ),
      ],
    );
  }
}
