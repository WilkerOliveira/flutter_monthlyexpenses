import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:summarizeddebts/ads/ad_manager.dart';
import 'package:summarizeddebts/generated/i18n.dart';
import 'package:summarizeddebts/modules/reports/report_module.dart';
import 'package:summarizeddebts/ui/resources/app_dimen.dart';
import 'package:summarizeddebts/ui/resources/app_images.dart';
import 'package:summarizeddebts/ui/widget/appbar/custom_appbar.dart';
import 'package:summarizeddebts/ui/widget/menu/box_menu_widget.dart';

class ReportScreen extends StatefulWidget {
  ReportScreen({Key key}) : super(key: key);

  @override
  _ReportScreenState createState() {
    return _ReportScreenState();
  }
}

class _ReportScreenState extends State<ReportScreen> {
  BannerAd _bannerAd;

  @override
  void initState() {
    super.initState();

    _bannerAd = BannerAd(
      adUnitId: AdManager.bannerAdUnitId,
      size: AdSize.banner,
    );

    _loadBannerAd();

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
        title: S.of(context).tab_consults,
        appBarType: AppBarType.simple,
        showBackArrow: false,
        showDrawer: false,
      ),
      body: SingleChildScrollView(
        child: _body(),
      ),
    );
  }

  Widget _body() {
    return Container(
      margin: EdgeInsets.only(
          left: ScreenUtil().setWidth(AppDimen.simpleMargin),
          right: ScreenUtil().setWidth(AppDimen.simpleMargin),
          top: ScreenUtil().setWidth(AppDimen.defaultMargin)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              BoxMenuWidget(
                boxWidth: AppDimen.defaultBoxWidth,
                image: AppImages.iconConsultByMonth,
                boxHeight: AppDimen.defaultBoxHeight,
                text: S.of(context).consult_by_month,
                onPress: () {
                  Navigator.pushNamed(
                      context, ReportModule.initial + ReportModule.byMonth);
                },
              ),
              SizedBox(
                width: ScreenUtil().setWidth(AppDimen.defaultMargin),
              ),
              BoxMenuWidget(
                boxWidth: AppDimen.defaultBoxWidth,
                image: AppImages.iconConsultByYear,
                boxHeight: AppDimen.defaultBoxHeight,
                text: S.of(context).consult_by_year,
                onPress: () {
                  Navigator.pushNamed(
                      context, ReportModule.initial + ReportModule.byYear);
                },
              ),
            ],
          ),
          SizedBox(
            height: ScreenUtil().setWidth(AppDimen.defaultMargin),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              BoxMenuWidget(
                boxWidth: AppDimen.defaultBoxWidth,
                image: AppImages.iconConsultByPaid,
                boxHeight: AppDimen.defaultBoxHeight,
                text: S.of(context).consult_by_status,
                onPress: () {
                  Navigator.pushNamed(
                      context, ReportModule.initial + ReportModule.byStatus);
                },
              ),
              SizedBox(
                width: ScreenUtil().setWidth(AppDimen.defaultMargin),
              ),
              BoxMenuWidget(
                boxWidth: AppDimen.defaultBoxWidth,
                image: AppImages.iconConsultByLocalToPay,
                boxHeight: AppDimen.defaultBoxHeight,
                text: S.of(context).consult_by_payment,
                onPress: () {
                  Navigator.pushNamed(
                      context, ReportModule.initial + ReportModule.byPayment);
                },
              ),
            ],
          ),
          SizedBox(
            height: ScreenUtil().setWidth(AppDimen.defaultMargin),
          ),
          BoxMenuWidget(
            boxWidth: AppDimen.defaultBoxWidth,
            image: AppImages.iconIncomeXExpenses,
            boxImageSize: 65,
            boxHeight: AppDimen.defaultBoxHeight,
            text: S.of(context).consult_income_x_expenses,
            onPress: () {
              Navigator.pushNamed(context,
                  ReportModule.initial + ReportModule.byIncomeXExpenses);
            },
          ),
          SizedBox(
            height: ScreenUtil().setWidth(AppDimen.defaultMargin),
          ),
        ],
      ),
    );
  }

  void _loadBannerAd() {
    _bannerAd
      ..load()
      ..show(anchorType: AnchorType.bottom);
  }
}
