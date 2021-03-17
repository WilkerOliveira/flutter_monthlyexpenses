import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobx/mobx.dart';
import 'package:summarizeddebts/common/utility.dart';
import 'package:summarizeddebts/generated/i18n.dart';
import 'package:summarizeddebts/modules/debt/controller/debt_detail_controller.dart';
import 'package:summarizeddebts/modules/debt/screen/widget/edit_expense_widget_v2.dart';
import 'package:summarizeddebts/ui/resources/app_color.dart';
import 'package:summarizeddebts/ui/resources/app_dimen.dart';
import 'package:summarizeddebts/ui/resources/app_styles.dart';
import 'package:summarizeddebts/ui/widget/appbar/custom_appbar.dart';
import 'package:summarizeddebts/ui/widget/button/custom_button.dart';
import 'package:summarizeddebts/ui/widget/dialog/alert_dialogs.dart';
import 'package:summarizeddebts/ui/widget/divider/divider_widget.dart';
import 'package:summarizeddebts/ui/widget/summary/summary_widget.dart';

class DebtDetailScreen extends StatefulWidget {
  final DateTime currentMonth;

  DebtDetailScreen({Key key, this.currentMonth}) : super(key: key);

  @override
  _DebtDetailScreenState createState() => _DebtDetailScreenState();
}

class _DebtDetailScreenState
    extends ModularState<DebtDetailScreen, DebtDetailController> {
  var currentMonth = Observable(DateTime.now());
  var checkAll = Observable(false);

  @override
  void initState() {
    super.initState();

    runInAction(() => this.currentMonth.value = widget.currentMonth);

    //Load only when build is complete
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        appBarType: AppBarType.simple,
        title: S.of(context).expenses,
        showBackArrow: true,
        actions: [
          Observer(
            builder: (context) => IconButton(
              icon: Icon(this.checkAll.value
                  ? Icons.check_box_outline_blank
                  : Icons.check_box),
              tooltip: S.of(context).all.toUpperCase(),
              onPressed: () {
                runInAction(() => this.checkAll.value = !this.checkAll.value);
                this.controller.selectUnSelectAll(this.checkAll.value);
              },
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: _body(),
      ),
    );
  }

  Widget _body() {
    return Container(
      padding: EdgeInsets.only(bottom: 50),
      child: Column(
        children: <Widget>[
          summary(),
          SizedBox(height: ScreenUtil().setHeight(15)),
          DividerWidget(),
          SizedBox(height: ScreenUtil().setHeight(15)),
          actions(),
          SizedBox(height: ScreenUtil().setHeight(15)),
          itemsList(),
        ],
      ),
    );
  }

  Widget summary() {
    return Container(
      margin: EdgeInsets.only(
        top: ScreenUtil().setWidth(AppDimen.defaultMargin),
        left: ScreenUtil().setWidth(AppDimen.defaultMargin),
        right: ScreenUtil().setWidth(AppDimen.defaultMargin),
      ),
      child: Observer(
        builder: (context) => SummaryWidget(
          currentMonth: Utility.formatMonthYear(this.currentMonth.value),
        ),
      ),
    );
  }

  Widget actions() {
    return Container(
      margin: EdgeInsets.only(
        left: ScreenUtil().setWidth(AppDimen.defaultMargin),
        right: ScreenUtil().setWidth(AppDimen.defaultMargin),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          CustomButton(
            text: Text(
              S.of(context).pay.toUpperCase(),
              style: AppStyles.defaultTextStyle(),
            ),
            width: 100,
            buttonColor: AppColor.green,
            onPress: this.onPayPress,
          ),
          SizedBox(width: ScreenUtil().setHeight(5)),
          CustomButton(
            width: 100,
            text: Text(
              S.of(context).reopen.toUpperCase(),
              style: AppStyles.defaultTextStyle(color: Colors.black),
            ),
            buttonColor: AppColor.alertButtonColor,
            onPress: this.onReopenPress,
          ),
          SizedBox(width: ScreenUtil().setHeight(5)),
          CustomButton(
            width: 100,
            text: Text(
              S.of(context).delete.toUpperCase(),
              style: AppStyles.defaultTextStyle(),
            ),
            buttonColor: AppColor.deleteButtonColor,
            onPress: this.onDeletePress,
          ),
        ],
      ),
    );
  }

  Widget itemsList() {
    return Observer(
      builder: (BuildContext context) {
        return Column(
          children: <Widget>[
            SizedBox(
              height: 10,
            ),
            EditExpenseItemWidgetV2(
              debtModel: this.controller.debtDetailModel.debts,
              onItemChecked: (index) {},
            ),
          ],
        );
      },
    );
  }

  onPayPress() {
    AlertDialogs.showYesOrNoQuestion(
        context: context,
        title: S.of(context).confirm,
        message: S.of(context).confirm_pay_debts,
        textButtonOne: S.of(context).yes.toUpperCase(),
        textButtonTwo: S.of(context).no.toUpperCase(),
        yesCallBackFunction: () async {
          AlertDialogs.showLoading(context, S.of(context).please_wait);

          await this.controller.payDebts();

          AlertDialogs.closeDialog(context);

          if (this.controller.isAlert) {
            AlertDialogs.showAlertToast(context, this.controller.errorMessage);
          } else if (!this.controller.isError) {
            AlertDialogs.showSuccessDialog(context, S.of(context).success_title,
                S.of(context).paid_successfully, () {
              this.updateCurrentDate();
              this.loadData();
            });
          } else {
            AlertDialogs.showErrorDialog(
                context, S.of(context).app_name, this.controller.errorMessage);
          }
        });
  }

  onReopenPress() {
    AlertDialogs.showYesOrNoQuestion(
        context: context,
        title: S.of(context).confirm,
        message: S.of(context).confirm_reopen_debts,
        textButtonOne: S.of(context).yes.toUpperCase(),
        textButtonTwo: S.of(context).no.toUpperCase(),
        yesCallBackFunction: () async {
          AlertDialogs.showLoading(context, S.of(context).please_wait);

          await this.controller.reopenDebts();

          AlertDialogs.closeDialog(context);

          if (this.controller.isAlert) {
            AlertDialogs.showAlertToast(context, this.controller.errorMessage);
          } else if (!this.controller.isError) {
            AlertDialogs.showSuccessDialog(context, S.of(context).success_title,
                S.of(context).reopen_successfully, () {
              this.updateCurrentDate();
              this.loadData();
            });
          } else {
            AlertDialogs.showErrorDialog(
                context, S.of(context).app_name, this.controller.errorMessage);
          }
        });
  }

  onDeletePress() {
    AlertDialogs.showYesOrNoQuestion(
        context: context,
        title: S.of(context).confirm,
        message: S.of(context).confirm_delete_debts,
        textButtonOne: S.of(context).yes.toUpperCase(),
        textButtonTwo: S.of(context).no.toUpperCase(),
        yesCallBackFunction: () async {
          AlertDialogs.showLoading(context, S.of(context).please_wait);

          await this.controller.deleteDebts();

          AlertDialogs.closeDialog(context);

          if (this.controller.isAlert) {
            AlertDialogs.showAlertToast(context, this.controller.errorMessage);
          } else if (!this.controller.isError) {
            AlertDialogs.showSuccessDialog(context, S.of(context).success_title,
                S.of(context).delete_successfully, () {
              this.updateCurrentDate();
              this.loadData();
            });
          } else {
            AlertDialogs.showErrorDialog(
                context, S.of(context).app_name, this.controller.errorMessage);
          }
        });
  }

  updateCurrentDate() {
    Future.delayed(Duration(seconds: 5), (){
      runInAction(() => this.currentMonth.value = DateTime(
          widget.currentMonth.year,
          widget.currentMonth.month,
          this.currentMonth.value.day == 1 ? 2 : 1));
    });
  }

  loadData() async {
    AlertDialogs.showLoading(context, S.of(context).please_wait);

    runInAction(() => this.checkAll.value = false);

    await controller.loadDebt(widget.currentMonth);

    AlertDialogs.closeDialog(context);

    if (controller.isError) {
      AlertDialogs.showErrorDialog(
          context, S.of(context).app_name, controller.errorMessage);
    }
  }
}
