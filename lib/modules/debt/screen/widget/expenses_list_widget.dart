import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobx/mobx.dart';
import 'package:summarizeddebts/common/utility.dart';
import 'package:summarizeddebts/extensions/double_extensions.dart';
import 'package:summarizeddebts/generated/i18n.dart';
import 'package:summarizeddebts/model/expense_model.dart';
import 'package:summarizeddebts/ui/resources/app_color.dart';
import 'package:summarizeddebts/ui/resources/app_dimen.dart';
import 'package:summarizeddebts/ui/resources/app_styles.dart';
import 'package:summarizeddebts/ui/widget/button/custom_button.dart';

class ExpensesListWidget extends StatelessWidget {
  final ObservableList<ExpenseModel> items;
  final Function onEditPressed;
  final Function onDetailPressed;
  final Function onItemChecked;
  final bool showEditButton;
  final bool scrollEnabled;

  ExpensesListWidget(
      {Key key,
      @required this.items,
      @required this.onEditPressed,
      @required this.onDetailPressed,
      @required this.onItemChecked,
      this.showEditButton = true,
      this.scrollEnabled = true})
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
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Expanded(
                            child: Observer(
                              builder: (context) {
                                return this.showEditButton
                                    ? this.getCheckboxListTile(index, context)
                                    : this.getListTile(index, context);
                              },
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: ScreenUtil().setWidth(AppDimen.defaultMargin),
                            right:
                                ScreenUtil().setWidth(AppDimen.defaultMargin),
                            bottom:
                                ScreenUtil().setWidth(AppDimen.defaultMargin)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                Icon(
                                  this.items[index].paid
                                      ? Icons.money_off
                                      : Icons.attach_money,
                                  size: 22.0,
                                  color: this.items[index].amount <= 0
                                      ? AppColor.totalValueColor
                                      : this.items[index].paid
                                          ? AppColor.green
                                          : AppColor.alertButtonColor,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  this.items[index].amount <= 0
                                      ? S.of(context).no_expenses.toUpperCase()
                                      : this.items[index].paid
                                          ? S
                                              .of(context)
                                              .expenses_paid
                                              .toUpperCase()
                                          : S
                                              .of(context)
                                              .pending_expenses
                                              .toUpperCase(),
                                  style: AppStyles.defaultTextStyle(
                                      color: this.items[index].amount <= 0
                                          ? AppColor.totalValueColor
                                          : this.items[index].paid
                                              ? AppColor.green
                                              : AppColor.debtColor),
                                )
                              ],
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                this.showEditButton
                                    ? CustomButton(
                                        text: Text(
                                          S.of(context).edit,
                                          style: AppStyles.defaultTextStyle(),
                                        ),
                                        buttonColor: AppColor.greenButton,
                                        onPress: () {
                                          this.onEditPressed(index);
                                        },
                                      )
                                    : SizedBox(
                                        width: 0,
                                      ),
                                SizedBox(
                                  width: 20,
                                ),
                                CustomButton(
                                  text: Text(
                                    S.of(context).see_more,
                                    style: AppStyles.defaultTextStyle(
                                        color: Colors.black),
                                  ),
                                  buttonColor: AppColor.alertButtonColor,
                                  onPress: () {
                                    this.onDetailPressed(index);
                                  },
                                ),
                              ],
                            )
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

  Widget getCheckboxListTile(index, context) {
    return CheckboxListTile(
      activeColor: AppColor.green,
      title: Text(
        Utility.parseToMonthDescription(this.items[index].month, context),
        style: AppStyles.defaultTextStyle(
          fontSize: AppDimen.simpleTextSize,
        ),
      ),
      secondary: Text(
        this.items[index].amount.toCurrency(),
        style: AppStyles.defaultTextStyle(
          fontSize: AppDimen.simpleTextSize,
        ),
      ),
      value: this.items[index].isSelected.value,
      controlAffinity: ListTileControlAffinity.leading,
      onChanged: (bool value) {
        runInAction(() => this.items[index].isSelected.value = value);
        this.onItemChecked(index);
      },
    );
  }

  Widget getListTile(index, context) {
    return ListTile(
      title: Text(
        Utility.parseToMonthDescription(this.items[index].month, context),
        style: AppStyles.defaultTextStyle(
          fontSize: AppDimen.simpleTextSize,
        ),
      ),
      trailing: Text(
        this.items[index].amount.toCurrency(),
        style: AppStyles.defaultTextStyle(
          fontSize: AppDimen.simpleTextSize,
        ),
      ),
    );
  }
}
