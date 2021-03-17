import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:summarizeddebts/generated/i18n.dart';
import 'package:summarizeddebts/ui/resources/app_decorations.dart';
import 'package:summarizeddebts/ui/resources/app_dimen.dart';
import 'package:summarizeddebts/ui/resources/app_images.dart';
import 'package:summarizeddebts/ui/resources/app_styles.dart';

class LogoHeaderWidget extends StatelessWidget {
  final String version;

  const LogoHeaderWidget({Key key, this.version}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppDecorations.headerDecoration(),
      width: MediaQuery.of(context).size.width,
      height: ScreenUtil().setHeight(AppDimen.loginHeaderHeight),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(
              top: ScreenUtil().setWidth(AppDimen.logoLoginMarginTop),
            ),
            child: SvgPicture.asset(
              AppImages.logo,
              width: ScreenUtil().setWidth(AppDimen.logoLoginWidth),
              height: ScreenUtil().setHeight(AppDimen.logoLoginHeight),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              top: ScreenUtil().setWidth(AppDimen.labelLogoLoginMarginTop),
            ),
            child: RichText(
              text: new TextSpan(
                children: [
                  new TextSpan(
                    text: S.of(context).app_name,
                    style: AppStyles.defaultTextStyle(
                      color: Colors.white,
                      fontSize:
                          ScreenUtil().setSp(AppDimen.labelSplashScreenSize),
                    ),
                  ),
                  new TextSpan(
                    text: " ",
                    style: AppStyles.defaultTextStyle(
                      color: Colors.white,
                      fontSize:
                          ScreenUtil().setSp(AppDimen.labelSplashScreenSize),
                    ),
                  ),
                  new TextSpan(
                    text: this.version,
                    style: AppStyles.defaultTextStyle(
                      color: Colors.white,
                      fontSize: ScreenUtil().setSp(AppDimen.simpleTextSize),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
