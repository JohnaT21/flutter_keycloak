
import 'package:flutter/material.dart';
import 'package:keycloakdemo/pages/Dashboard.dart';

import '../pages/login_screen.dart';

class AppRoute {
  static Route? onGenerateRoute(RouteSettings routeSettings) {
    dynamic args = routeSettings.arguments;

    switch (routeSettings.name) {
      case LoginScreen.LoginScreenPageRouting:
        return MaterialPageRoute(builder: (context) {
          return LoginScreen();
        });
      case DashboardPage.DashboardRoutingName:
        return MaterialPageRoute(builder: (context) {
          return DashboardPage();
        });
    }
    }
  }