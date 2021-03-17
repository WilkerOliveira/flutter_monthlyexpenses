import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:mobx/mobx.dart';
import 'package:summarizeddebts/generated/i18n.dart';
import 'package:summarizeddebts/modules/config/screen/config_screen.dart';
import 'package:summarizeddebts/modules/dashboard/screen/dashboard_screen.dart';
import 'package:summarizeddebts/modules/debt/debt_module.dart';
import 'package:summarizeddebts/modules/debt/screen/list_debt_screen.dart';
import 'package:summarizeddebts/modules/reports/screen/report_screen.dart';
import 'package:summarizeddebts/ui/resources/app_dimen.dart';
import 'package:summarizeddebts/ui/utility/screen_utility.dart';
import 'package:summarizeddebts/ui/widget/dialog/alert_dialogs.dart';
import 'package:summarizeddebts/ui/widget/navigationbar/custom_bottom_nav_bar.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime currentBackPressTime;

  var screens = [
    DashboardScreen(),
    ListDebtScreen(),
    ReportScreen(),
    ConfigScreen()
  ].asObservable();
  Observable<int> currentScreen = Observable(0);
  int _pState = 0;

  @override
  Widget build(BuildContext context) {
    ScreenUtility.initScreenUtil(context: context);

    return WillPopScope(
      onWillPop: this._onWillPop,
      child: Scaffold(
        body: Observer(
          builder: (BuildContext context) {
            return screens[currentScreen.value];
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(
                context, DebtModule.initial + DebtModule.newDebt);
          },
          child: Icon(Icons.add),
          backgroundColor: Colors.red,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        bottomNavigationBar: Padding(
          padding: EdgeInsets.only(
            bottom: ScreenUtil().setWidth(AppDimen.adMargin),
          ),
          child: Observer(
            builder: (context) {
              return CustomBottomNavBar(
                  currentScreen: currentScreen.value,
                  onTabTap: (index) {
                    _pState = currentScreen.value;
                    runInAction(() => currentScreen.value = index);
                  });
            },
          ),
        ),
      ),
    );
  }

  // ignore: missing_return
  Future<bool> _onWillPop() {
    if (currentScreen.value == 0) {
      DateTime now = DateTime.now();
      if (currentBackPressTime == null ||
          now.difference(currentBackPressTime) > Duration(seconds: 2)) {
        currentBackPressTime = now;
        AlertDialogs.showAlertToastWithMessage(
            S.of(context).press_again_to_exit);
        return Future.value(false);
      }
      return Future.value(true);
    }

    runInAction(() => currentScreen.value = _pState);
    if (_pState > 0 && _pState == currentScreen.value) {
      _pState -= 1;
    }
  }
}
