import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:summarizeddebts/ads/ad_manager.dart';
import 'package:summarizeddebts/generated/i18n.dart';
import 'package:summarizeddebts/modules/config/config_module.dart';
import 'package:summarizeddebts/modules/config/controller/config_controller.dart';
import 'package:summarizeddebts/modules/debt/debt_module.dart';
import 'package:summarizeddebts/modules/login/login_module.dart';
import 'package:summarizeddebts/ui/resources/app_color.dart';
import 'package:summarizeddebts/ui/utility/screen_utility.dart';
import 'package:summarizeddebts/ui/widget/header/logo_header_widget.dart';
import 'package:summarizeddebts/ui/widget/menu/linear_item_menu_widget.dart';

class ConfigScreen extends StatefulWidget {
  ConfigScreen({Key key}) : super(key: key);

  @override
  _ConfigScreenState createState() => _ConfigScreenState();
}

class _ConfigScreenState extends ModularState<ConfigScreen, ConfigController> {
  var version = Observable("");
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
      _getVersion();
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
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              //Header
              Observer(
                builder: (context) =>
                    LogoHeaderWidget(
                      version: this.version.value,
                    ),
              ),
              _body(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _body(context) {
    return Container(
      margin: EdgeInsets.only(top: 5),
      child: Column(
        children: <Widget>[
          LinearItemMenuWidget(
            title: S.of(context).change_password,
            icon: Icons.lock_outline,
            iconColor: AppColor.changePwdIconColor,
            onPress: () {
              Navigator.pushNamed(
                  context, ConfigModule.initial + ConfigModule.changePassword);
            },
          ),
          LinearItemMenuWidget(
            title: S.of(context).local_to_pay,
            icon: Icons.business,
            iconColor: AppColor.localToPayIconColor,
            onPress: () {
              Navigator.pushNamed(
                  context, DebtModule.initial + DebtModule.localToPay);
            },
          ),

          LinearItemMenuWidget(
            title: S.of(context).monthly_income,
            icon: Icons.attach_money,
            iconColor: AppColor.monthlyIncomeIconColor,
            onPress: () {
              Navigator.pushNamed(
                  context, DebtModule.initial + DebtModule.monthlyIncome);
            },
          ),

          LinearItemMenuWidget(
            title: S.of(context).logout,
            icon: Icons.exit_to_app,
            iconColor: AppColor.exitIconColor,
            onPress: () async {
              await controller.signOut();
              Navigator.of(context).pushNamedAndRemoveUntil(
                   LoginModule.initial + LoginModule.login, (Route<dynamic> route) => false);
            },
          ),
        ],
      ),
    );
  }

  _getVersion() {
    ScreenUtility.getVersion()
        .then((value) => runInAction(() => this.version.value = value));
  }

  void _loadBannerAd() {
    _bannerAd
      ..load()
      ..show(anchorType: AnchorType.bottom);
  }
}
