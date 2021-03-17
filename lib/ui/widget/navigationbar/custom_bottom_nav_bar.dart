import 'package:bubble_bottom_bar/bubble_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:summarizeddebts/generated/i18n.dart';
import 'package:summarizeddebts/ui/resources/app_dimen.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentScreen;
  final Function onTabTap;

  CustomBottomNavBar({Key key, this.currentScreen, this.onTabTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BubbleBottomBar(
      opacity: .2,
      currentIndex: currentScreen,
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      elevation: 8,
      fabLocation: BubbleBottomBarFabLocation.end,
      hasNotch: true,
      hasInk: true,
      onTap: onTabTap,
      inkColor: Colors.black12,
      items: <BubbleBottomBarItem>[
        BubbleBottomBarItem(
            backgroundColor: Colors.red,
            icon: Icon(
              Icons.dashboard,
              color: Colors.black,
              size: AppDimen.bottomBarIconSize,
            ),
            activeIcon: Icon(
              Icons.dashboard,
              color: Colors.red,
              size: AppDimen.bottomBarActiveIconSize,
            ),
            title: Text(
              S.of(context).tab_home,
              style: TextStyle(fontSize: AppDimen.bottomBarTextSize),
            )),
        BubbleBottomBarItem(
            backgroundColor: Colors.deepPurple,
            icon: Icon(
              Icons.attach_money,
              color: Colors.black,
              size: AppDimen.bottomBarIconSize,
            ),
            activeIcon: Icon(
              Icons.attach_money,
              color: Colors.deepPurple,
              size: AppDimen.bottomBarActiveIconSize,
            ),
            title: Text(
              S.of(context).tab_registers,
              style: TextStyle(fontSize: AppDimen.bottomBarTextSize),
            )),
        BubbleBottomBarItem(
            backgroundColor: Colors.indigo,
            icon: Icon(
              Icons.search,
              color: Colors.black,
              size: AppDimen.bottomBarIconSize,
            ),
            activeIcon: Icon(
              Icons.search,
              color: Colors.indigo,
              size: AppDimen.bottomBarActiveIconSize,
            ),
            title: Text(
              S.of(context).tab_consults,
              style: TextStyle(fontSize: AppDimen.bottomBarTextSize),
            )),
        BubbleBottomBarItem(
            backgroundColor: Colors.green,
            icon: Icon(
              Icons.menu,
              color: Colors.black,
              size: AppDimen.bottomBarIconSize,
            ),
            activeIcon: Icon(
              Icons.menu,
              color: Colors.green,
              size: AppDimen.bottomBarActiveIconSize,
            ),
            title: Text(
              S.of(context).tab_config,
              style: TextStyle(fontSize: AppDimen.bottomBarTextSize),
            ))
      ],
    );
  }
}
