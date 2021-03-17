import 'package:flutter/material.dart';
import 'package:summarizeddebts/ui/resources/app_color.dart';

class DividerWidget extends StatelessWidget {
  DividerWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Container(
      height: 1,
      decoration: new BoxDecoration(color: AppColor.gridLineColor),
    );
  }
}
