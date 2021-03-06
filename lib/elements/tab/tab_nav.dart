import 'package:flutter/material.dart';

class TabNavigatorRoutes {
  static const String root = '/';
}

class TabNavigator extends StatelessWidget {
  TabNavigator({required this.navigatorKey, required this.rootPage});
  final GlobalKey<NavigatorState>? navigatorKey;
  final Widget rootPage;

  Map<String, WidgetBuilder> _routeBuilders(BuildContext context) {
    return {
      TabNavigatorRoutes.root: (context) => rootPage,
    };
  }

  @override
  Widget build(BuildContext context) {
    final routeBuilders = _routeBuilders(context);
    return Navigator(
      key: navigatorKey,
      initialRoute: TabNavigatorRoutes.root,
      onGenerateRoute: (routeSettings) {
        return MaterialPageRoute(
            builder: (context) => routeBuilders[routeSettings.name!]!(context));
      },
    );
  }
}
