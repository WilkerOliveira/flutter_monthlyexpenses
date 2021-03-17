import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobx/mobx.dart';
import 'package:summarizeddebts/common/utility.dart';
import 'package:summarizeddebts/generated/i18n.dart';
import 'package:summarizeddebts/modules/debt/controller/debt_detail_controller.dart';
import 'package:summarizeddebts/modules/debt/debt_module.dart';
import 'package:summarizeddebts/modules/debt/screen/widget/edit_expense_widget_v2.dart';
import 'package:summarizeddebts/ui/resources/app_dimen.dart';
import 'package:summarizeddebts/ui/widget/appbar/custom_appbar.dart';
import 'package:summarizeddebts/ui/widget/dialog/alert_dialogs.dart';
import 'package:summarizeddebts/ui/widget/divider/divider_widget.dart';
import 'package:summarizeddebts/ui/widget/summary/summary_widget.dart';

class EditDebtScreen extends StatefulWidget {
  final DateTime currentMonth;

  EditDebtScreen({Key key, this.currentMonth}) : super(key: key);

  @override
  _EditDebtScreenState createState() => _EditDebtScreenState();
}

class _EditDebtScreenState
    extends ModularState<EditDebtScreen, DebtDetailController> {

  var currentMonth = Observable(DateTime.now());

  @override
  void initState() {
    super.initState();

    runInAction(() => this.currentMonth.value = widget.currentMonth);

    //Load only when build is complete
    WidgetsBinding.instance.addPostFrameCallback((_) {
      this.loadData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        appBarType: AppBarType.simple,
        title: S.of(context).expenses,
        showBackArrow: true,
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
            itemsList(),
          ],
      ),
    );
  }

  Widget summary() {
    return Container(
      padding: EdgeInsets.only(
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

  Widget itemsList() {
    return Observer(
      builder: (BuildContext context) {
        return EditExpenseItemWidgetV2(
          isEditing: true,
          debtModel: this.controller.debtDetailModel.debts,
          onEditPress: this.onEditPress,
        );
      },
    );
  }

  updateCurrentDate() {
    runInAction(() => this.currentMonth.value = DateTime(
        widget.currentMonth.year,
        widget.currentMonth.month,
        this.currentMonth.value.day == 1 ? 2 : 1));
  }

  loadData() async {
    AlertDialogs.showLoading(context, S.of(context).please_wait);

    await controller.loadDebt(widget.currentMonth);

    AlertDialogs.closeDialog(context);

    if (controller.isError) {
      AlertDialogs.showErrorDialog(
          context, S.of(context).app_name, controller.errorMessage);
    }
  }

  onEditPress(int index) async {
    String id = this.controller.debtDetailModel.debts.items[index].id;

    await Navigator.pushNamed(context, DebtModule.initial + DebtModule.newDebt,
        arguments: id);
    this.updateCurrentDate();
    this.loadData();
  }
}
