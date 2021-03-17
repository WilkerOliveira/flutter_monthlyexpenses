import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:summarizeddebts/ui/resources/app_color.dart';
import 'package:summarizeddebts/ui/resources/app_dimen.dart';
import 'package:summarizeddebts/ui/resources/app_styles.dart';

class LinearItemMenuWidget extends StatelessWidget {
  final String title;
  final Color iconColor;
  final IconData icon;
  final Function onPress;

  LinearItemMenuWidget({
    Key key,
    this.title,
    this.iconColor,
    this.icon,
    this.onPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: this.onPress,
      child: Container(
        height: ScreenUtil().setWidth(AppDimen.linearItemMenuHeight),
        child: Card(
          color: AppColor.boxColor,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  SizedBox(
                    width: AppDimen.defaultMargin,
                  ),
                  Icon(
                    this.icon,
                    color: this.iconColor,
                    size: ScreenUtil().setWidth(AppDimen.configIconSize),
                  ),
                  SizedBox(
                    width: AppDimen.defaultMargin,
                  ),
                  Text(
                    this.title,
                    style: AppStyles.defaultTextStyle(
                      fontSize: ScreenUtil().setSp(AppDimen.configMenuTextSize),
                    ),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Icon(
                    Icons.navigate_next,
                    color: Colors.white,
                    size: ScreenUtil().setWidth(AppDimen.configIconSize),
                  ),
                  SizedBox(
                    width: AppDimen.defaultMargin,
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
