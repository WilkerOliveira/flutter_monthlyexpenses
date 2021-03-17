import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:summarizeddebts/ads/ad_manager.dart';
import 'package:summarizeddebts/extensions/string_extensions.dart';
import 'package:summarizeddebts/generated/i18n.dart';
import 'package:summarizeddebts/modules/debt/controller/list_debt_controller.dart';
import 'package:summarizeddebts/modules/debt/debt_module.dart';
import 'package:summarizeddebts/modules/debt/screen/widget/expenses_list_widget.dart';
import 'package:summarizeddebts/ui/widget/appbar/custom_appbar.dart';
import 'package:summarizeddebts/ui/widget/dialog/alert_dialogs.dart';

class ListDebtScreen extends StatefulWidget {
  ListDebtScreen({Key key}) : super(key: key);

  @override
  _ListDebtScreenState createState() {
    return _ListDebtScreenState();
  }
}

class _ListDebtScreenState
    extends ModularState<ListDebtScreen, ListDebtController> {

  BannerAd _bannerAd;

  @override
  void initState() {
    super.initState();

    _bannerAd = BannerAd(
      adUnitId: AdManager.bannerAdUnitId,
      size: AdSize.banner,
    );

    _loadBannerAd();

    //Load only when build is complete
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadData();
    });
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        appBarType: AppBarType.simple,
        title: S.of(context).debt_list,
        showBackArrow: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.money_off),
            tooltip: S.of(context).pay_all.toUpperCase(),
            onPressed: this.payAll,
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            tooltip: S.of(context).delete.toUpperCase(),
            onPressed: this.delete,
          ),
        ],
      ),
      body: _body(),
    );
  }

  Widget _body() {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Observer(
        builder: (BuildContext context) {
          return ExpensesListWidget(
            items: controller.items,
            onDetailPressed: this.onSeeMorePress,
            onEditPressed: this.onEditPress,
            onItemChecked: (index) {},
          );
        },
      ),
    );
  }

  loadData() async {
    AlertDialogs.showLoading(context, S.of(context).please_wait);

    await controller.loadAll();

    AlertDialogs.closeDialog(context);

    if (controller.isError) {
      AlertDialogs.showErrorDialog(
          context, S.of(context).app_name, controller.errorMessage);
    }
  }

  payAll() async {
    AlertDialogs.showYesOrNoQuestion(
        context: context,
        title: S.of(context).confirm,
        message: S.of(context).confirm_pay_debts,
        textButtonOne: S.of(context).yes.toUpperCase(),
        textButtonTwo: S.of(context).no.toUpperCase(),
        yesCallBackFunction: () async {
          AlertDialogs.showLoading(context, S.of(context).please_wait);

          await this.controller.payAll();

          AlertDialogs.closeDialog(context);

          if (this.controller.isAlert) {
            AlertDialogs.showAlertToast(context, this.controller.errorMessage);
          } else if (!this.controller.isError) {
            AlertDialogs.showSuccessDialog(context, S.of(context).success_title,
                S.of(context).paid_successfully, () {
              this.loadData();
            });
          } else {
            AlertDialogs.showErrorDialog(
                context, S.of(context).app_name, this.controller.errorMessage);
          }
        });
  }

  delete() async {
    AlertDialogs.showYesOrNoQuestion(
        context: context,
        title: S.of(context).confirm,
        message: S.of(context).confirm_delete_debts,
        textButtonOne: S.of(context).yes.toUpperCase(),
        textButtonTwo: S.of(context).no.toUpperCase(),
        yesCallBackFunction: () async {
          AlertDialogs.showLoading(context, S.of(context).please_wait);

          await this.controller.delete();

          AlertDialogs.closeDialog(context);

          if (this.controller.isAlert) {
            AlertDialogs.showAlertToast(context, this.controller.errorMessage);
          } else if (!this.controller.isError) {
            AlertDialogs.showSuccessDialog(context, S.of(context).success_title,
                S.of(context).delete_successfully, () {
              this.loadData();
            });
          } else {
            AlertDialogs.showErrorDialog(
                context, S.of(context).app_name, this.controller.errorMessage);
          }
        });
  }

  onSeeMorePress(index) async {
    await Navigator.pushNamed(context, DebtModule.detailDebt,
        arguments:
            this.controller.items[index].month.parseMonthYearToDateTime());
    this.loadData();
  }

  onEditPress(index) async {
    await Navigator.pushNamed(context, DebtModule.editDebt,
        arguments:
            this.controller.items[index].month.parseMonthYearToDateTime());
    this.loadData();
  }

  void _loadBannerAd() {
    _bannerAd
      ..load()
      ..show(anchorType: AnchorType.bottom);
  }
}
