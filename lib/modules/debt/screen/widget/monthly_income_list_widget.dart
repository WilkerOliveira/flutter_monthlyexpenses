import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobx/mobx.dart';
import 'package:summarizeddebts/extensions/double_extensions.dart';
import 'package:summarizeddebts/generated/i18n.dart';
import 'package:summarizeddebts/model/monthly_income_model.dart';
import 'package:summarizeddebts/ui/resources/app_color.dart';
import 'package:summarizeddebts/ui/resources/app_dimen.dart';
import 'package:summarizeddebts/ui/resources/app_styles.dart';

class MonthlyIncomeListWidget extends StatelessWidget {
  final ObservableList<MonthlyIncomeModel> items;
  final Function onEditPressed;
  final Function onDeletePressed;

  MonthlyIncomeListWidget(
      {Key key,
      @required this.items,
      @required this.onEditPressed,
      @required this.onDeletePressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Flexible(
      fit: FlexFit.loose,
      child: Container(
        margin: EdgeInsets.only(
            bottom: ScreenUtil().setWidth(AppDimen.defaultMargin)),
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: items.length,
          itemBuilder: (context, int index) {
            return Card(
              color: AppColor.boxColor,
              child: ListTile(
                title: Text(
                  this.items[index].month,
                  style: AppStyles.defaultTextStyle(),
                ),
                subtitle: Padding(
                  padding: EdgeInsets.only(top: AppDimen.simpleMargin),
                  child: Text(
                    this.items[index].amount.toCurrency(),
                    style: AppStyles.defaultTextStyle(fontSize: 16)
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    IconButton(
                      color: Colors.white,
                      icon: const Icon(Icons.edit),
                      tooltip: S.of(context).edit,
                      onPressed: () {
                        this.onEditPressed(index);
                      },
                    ),
                    IconButton(
                      color: AppColor.deleteButtonColor,
                      icon: const Icon(Icons.delete),
                      tooltip: S.of(context).delete,
                      onPressed: () {
                        this.onDeletePressed(index);
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
