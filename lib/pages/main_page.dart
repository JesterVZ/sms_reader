import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sms_reader/pages/settings_page.dart';
import 'package:sms_reader/pages/sms_page.dart';

import '../elements/bottom_nav/bottom_navigation_custom.dart';
import '../elements/tab/tab_item.dart';
import '../elements/tab/tab_nav.dart';

class MainPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MainPage();
}

class _MainPage extends State<MainPage> {
  var _currentTab = TabItem.main;
  final _navKeys = {
    TabItem.main: GlobalKey<NavigatorState>(),
    TabItem.settings: GlobalKey<NavigatorState>(),
  };
  List<Widget> navigatorList = [];
  @override
  void initState() {
    navigatorList.add(TabNavigator(
      navigatorKey: _navKeys[TabItem.main],
      rootPage: SmsPage(),
    ));
    navigatorList.add(TabNavigator(
      navigatorKey: _navKeys[TabItem.settings],
      rootPage: SettingsPage(),
    ));
    super.initState();
  }

  void _selectTab(TabItem tabItem) {
    if (tabItem == _currentTab) {
      _navKeys[tabItem]!.currentState!.popUntil((route) => route.isFirst);
    } else {
      setState(() {
        _currentTab = tabItem;
      });
    }
  }

  Widget _buildOffstageNavigator(TabItem tabItem, Widget navigator) {
    return Offstage(
      offstage: _currentTab != tabItem,
      child: navigator,
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final isFirstRouteInCurrentTab =
            !await _navKeys[_currentTab]!.currentState!.maybePop();

        if (isFirstRouteInCurrentTab) {
          //Не страница 'main'
          if (_currentTab != TabItem.main) {
            _selectTab(TabItem.main);
            return false;
          }
        }
        return isFirstRouteInCurrentTab;
      },
      child: Scaffold(
        body: IndexedStack(
          index: _currentTab.index,
          children: [
            _buildOffstageNavigator(TabItem.main, navigatorList[0]),
            _buildOffstageNavigator(TabItem.settings, navigatorList[1])
          ],
        ),
        bottomNavigationBar: BottomNavigation(
          currentTab: _currentTab,
          onSelectTab: _selectTab,
        ),
      ),
    );
  }
}
