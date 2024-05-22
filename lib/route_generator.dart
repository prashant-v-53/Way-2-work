import 'package:flutter/material.dart';
import 'package:way_to_work/pages/auth/signup_screen.dart';
import 'package:way_to_work/pages/manage_payment/add_new_employer_screen.dart';
import 'package:way_to_work/pages/my_document/my_document_screen.dart';
import 'package:way_to_work/pages/splash_screen.dart';

import 'helpers/variable_keys.dart';
import 'pages/auth/login_screen.dart';
import 'pages/dashboard/dashboard_screen.dart';
import 'pages/dashboard/manage_account_screen.dart';
import 'pages/manage_payment/manage_payment_screen.dart';
import 'pages/dashboard/worked_hours_screen.dart';
import 'pages/my_dashboard_screen.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Getting arguments passed in while calling Navigator.pushNamed
    // final args = settings.arguments;
    switch (settings.name) {
      case RouteKeys.SPLASH:
        return MaterialPageRoute(builder: (_) => SplashScreen());
      case RouteKeys.LOGIN:
        return MaterialPageRoute(builder: (_) => LoginScreen());
      case RouteKeys.SIGN_UP:
        return MaterialPageRoute(builder: (_) => SignUpScreen());
      case RouteKeys.DASHBOARD:
        return MaterialPageRoute(builder: (_) => DashBoardScreen());
      case RouteKeys.MY_DASHBOARD:
        return MaterialPageRoute(builder: (_) => MyDashBoardScreen());
      case RouteKeys.MANAGE_PAYMENT_SCREEN:
        return MaterialPageRoute(builder: (_) => ManagePaymentScreen());
      case RouteKeys.MANAGE_ACCOUNT_SCREEN:
        return MaterialPageRoute(builder: (_) => ManageAccountScreen());
      case RouteKeys.WORKED_HOURS_SCREEN:
        return MaterialPageRoute(builder: (_) => WorkedHoursScreen());
      case RouteKeys.ADD_NEW_EMPLOYER_SCREEN:
        return MaterialPageRoute(builder: (_) => AddNewEmployerScreen());
      case RouteKeys.MY_DOCUMENT_SCREEN:
        return MaterialPageRoute(builder: (_) => MyDocumentScreen());
      case RouteKeys.LOGIN_WITH_ARG:
      // return MaterialPageRoute(
      //     builder: (_) =>
      //         LoginWithInputScreen(routeArgument: args as RouteArgument));
      default:
        // If there is no such named route in the switch statement, e.g. /third
        return MaterialPageRoute(
            builder: (_) => Scaffold(
                body: SafeArea(child: Center(child: Text('Route Error')))));
    }
  }
}
