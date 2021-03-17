import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:summarizeddebts/ads/ad_manager.dart';
import 'package:summarizeddebts/controller/base/base_controller.dart';
import 'package:summarizeddebts/generated/i18n.dart';
import 'package:summarizeddebts/modules/dashboard/controller/dashboard_controller.dart';
import 'package:summarizeddebts/modules/dashboard/screen/widget/dashboard_summary_widget_v2.dart';
import 'package:summarizeddebts/modules/debt/debt_module.dart';
import 'package:summarizeddebts/ui/resources/app_dimen.dart';
import 'package:summarizeddebts/ui/resources/app_styles.dart';
import 'package:summarizeddebts/ui/widget/charts/dashboard_bar_chart.dart';
import 'package:summarizeddebts/ui/widget/dialog/alert_dialogs.dart';
import 'package:summarizeddebts/ui/widget/header/logo_header_widget.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() {
    return _DashboardScreenState();
  }
}

class _DashboardScreenState
    extends ModularState<DashboardScreen, DashboardController> {

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
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(
              left: ScreenUtil().setWidth(AppDimen.simpleMargin),
              right: ScreenUtil().setWidth(AppDimen.simpleMargin)),
          child: Column(
            children: <Widget>[
              LogoHeaderWidget(),
              SizedBox(
                height: ScreenUtil().setHeight(AppDimen.defaultMargin),
              ),
              Observer(
                name: "dashboardModel",
                builder: (BuildContext context) {
                  return DashboardSummaryWidgetV2(
                    dashboardModel: controller.dashboardModel,
                    onSeeMoreTap: onSeeMoreTap,
                    onPreviousTap: onPreviousTap,
                    onNextTap: onNextTap,
                  );
                },
              ),
              SizedBox(
                height: 10,
              ),
              history(),
            ],
          ),
        ),
      ),
    );
  }

  Widget history() {
    return Container(
      padding: EdgeInsets.only(
        left: ScreenUtil().setWidth(AppDimen.defaultMargin),
        right: ScreenUtil().setWidth(AppDimen.defaultMargin),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              S.of(context).debt_history,
              style: AppStyles.defaultTextStyle(
                fontSize: AppDimen.defaultTitleSize,
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            height: ScreenUtil().setHeight(400.0),
            child: ListView(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              children: <Widget>[
                Container(
                  width: ScreenUtil().setWidth(500.0),
                  child: Observer(
                    name: "dataChart",
                    builder: (context) {
                      return controller.secondViewState == ViewState.Idle
                          ? DashboardBarChart(
                              animate: true,
                              debts: controller.dataChart,
                            )
                          : SpinKitThreeBounce(
                              color: Colors.white,
                              size: ScreenUtil().setWidth(AppDimen.loadingSize),
                            );
                    },
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: AppDimen.extraMargin,
          ),
        ],
      ),
    );
  }

  loadData() async {
    AlertDialogs.showLoading(context, S.of(context).please_wait);

    await controller.consultDashboard();
    AlertDialogs.closeDialog(context);

    if (controller.isError) {
      AlertDialogs.showErrorDialog(
          context, S.of(context).app_name, controller.errorMessage);
    }
  }

  onSeeMoreTap() async {
    await Navigator.pushNamed(context, DebtModule.detailDebt,
        arguments: this.controller.currentMonth);

    loadData();
  }

  onPreviousTap() {
    this.controller.getPreviousMonth();
    this.loadData();
  }

  onNextTap() {
    this.controller.getNextMonth();
    this.loadData();
  }


  void _loadBannerAd() {
    _bannerAd
      ..load()
      ..show(anchorType: AnchorType.bottom);
  }
}
