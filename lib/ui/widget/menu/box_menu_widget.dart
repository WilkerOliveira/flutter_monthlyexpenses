import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:summarizeddebts/ui/resources/app_color.dart';
import 'package:summarizeddebts/ui/resources/app_dimen.dart';
import 'package:summarizeddebts/ui/resources/app_styles.dart';

class BoxMenuWidget extends StatelessWidget {
  final String image;
  final String text;
  final double boxWidth;
  final double boxHeight;
  final double boxImageSize;
  final Function onPress;

  BoxMenuWidget(
      {Key key,
      @required this.image,
      @required this.text,
      @required this.boxWidth,
      @required this.boxHeight,
      this.onPress,
      this.boxImageSize = AppDimen.boxImageSize})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: this.onPress,
      child: Container(
        width: this.boxWidth,
        height: this.boxHeight,
        decoration: new BoxDecoration(
          color: AppColor.boxColor,
          borderRadius: BorderRadius.circular(
            ScreenUtil().setWidth(AppDimen.menuBoxRadius),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: ScreenUtil().setWidth(AppDimen.defaultMargin),
            ),
            SvgPicture.asset(
              this.image,
              width: ScreenUtil().setWidth(this.boxImageSize),
              height: ScreenUtil().setWidth(this.boxImageSize),
            ),
            SizedBox(
              height: ScreenUtil().setWidth(AppDimen.defaultMargin),
            ),
            Text(
              this.text,
              textAlign: TextAlign.center,
              style: AppStyles.defaultTextStyle(),
            ),
            SizedBox(
              height: ScreenUtil().setWidth(AppDimen.defaultMargin),
            ),
          ],
        ),
      ),
    );
  }
}
