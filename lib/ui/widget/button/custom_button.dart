import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:summarizeddebts/ui/resources/app_decorations.dart';
import 'package:summarizeddebts/ui/resources/app_dimen.dart';

class CustomButton extends StatelessWidget {
  final Text text;
  final Color buttonColor;
  final Function onPress;
  final double width;
  final bool isCircular;
  final double radius;

  const CustomButton({
    Key key,
    @required this.text,
    @required this.buttonColor,
    this.onPress,
    this.width = 0,
    this.isCircular = false,
    this.radius = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return this.isCircular
        ? circularButton()
        : ButtonTheme(
            buttonColor: this.buttonColor,
            minWidth: ScreenUtil().setWidth(this.width),
            height: ScreenUtil().setHeight(AppDimen.buttonDefaultHeight),
            child: RaisedButton(
              shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(
                  ScreenUtil().setWidth(AppDimen.borderButton),
                ),
              ),
              child: Center(child: this.text),
              color: this.buttonColor,
              elevation: 4.0,
              splashColor: Colors.blue,
              onPressed: this.onPress,
            ),
          );
  }

  Widget circularButton() {
    return GestureDetector(
      onTap: this.onPress,
      child: Container(
        width: ScreenUtil().setWidth(this.width),
        height: ScreenUtil().setHeight(this.width),
        decoration:
            AppDecorations.circularBoxDecoration(this.buttonColor, this.radius),
        child: Center(
          child: this.text,
        ),
      ),
    );
  }
}
