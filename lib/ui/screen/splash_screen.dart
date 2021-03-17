import 'dart:async';

import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:summarizeddebts/ads/ad_manager.dart';
import 'package:summarizeddebts/controller/splashscreen/splashcreen_controller.dart';
import 'package:summarizeddebts/generated/i18n.dart';
import 'package:summarizeddebts/modules/login/login_module.dart';
import 'package:summarizeddebts/ui/resources/app_color.dart';
import 'package:summarizeddebts/ui/resources/app_decorations.dart';
import 'package:summarizeddebts/ui/resources/app_dimen.dart';
import 'package:summarizeddebts/ui/resources/app_images.dart';
import 'package:summarizeddebts/ui/utility/routers.dart';
import 'package:summarizeddebts/ui/utility/screen_utility.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState
    extends ModularState<SplashScreen, SplashScreenController> {
  Future<Timer> loadData() async {
    return new Timer(Duration(seconds: 3), () async {
      if (await this.controller.isLoggedInUser()) {
        Navigator.pushReplacementNamed(context, Routers.home);
      } else {
        Navigator.pushReplacementNamed(
            context, LoginModule.initial + LoginModule.login);
      }
    });
  }


  @override
  void initState() {
    super.initState();

    this._initAdMob();
  }

  Future<void> _initAdMob() {
    return FirebaseAdMob.instance.initialize(appId: AdManager.appId);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    //Load only when build is complete
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadData();
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtility.initScreenUtil(context: context);
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        height: size.height,
        width: size.width,
        decoration: BoxDecoration(
          gradient: AppDecorations.gradientDecoration(),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(
                ScreenUtil().setWidth(AppDimen.imageSplashScreenPadding),
              ),
              child: SvgPicture.asset(
                AppImages.logo,
                width: ScreenUtil().setWidth(AppDimen.imageSplashScreenWidth),
                height:
                    ScreenUtil().setHeight(AppDimen.imageSplashScreenHeight),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(
                ScreenUtil().setWidth(AppDimen.labelSplashScreenPadding),
              ),
              child: Text(
                S.of(context).app_name,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: ScreenUtil().setSp(AppDimen.labelSplashScreenSize),
                ),
              ),
            ),
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColor.green),
            ),
          ],
        ),
      ),
    );
  }
}
