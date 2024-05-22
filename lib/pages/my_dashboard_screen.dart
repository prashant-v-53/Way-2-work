import 'dart:io';
import 'package:way_to_work/main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:way_to_work/helpers/global.dart';
import 'package:way_to_work/helpers/app_colors.dart';
import 'package:way_to_work/helpers/app_config.dart';
import 'package:way_to_work/helpers/variable_keys.dart';
import 'package:way_to_work/elements/dashboard_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:way_to_work/locale/translation_strings.dart';
import 'package:way_to_work/controllers/my_dashboard_controller.dart';

class MyDashBoardScreen extends StatefulWidget {
  @override
  _MyDashBoardState createState() => _MyDashBoardState();
}

class _MyDashBoardState extends StateMVC<MyDashBoardScreen> {
  MyDashBoardController _con;
  AppModel data;
  DateTime currentBackPressTime;
  _MyDashBoardState() : super(MyDashBoardController()) {
    _con = controller;
  }

  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      toast('${Translations.of(context).pressAgainToExitApp}');
      return Future.value(false);
    }
    return exit(0);
  }

  @override
  Widget build(BuildContext context) {
    _con.size = MediaQuery.of(context).size;
    data = Provider.of<AppModel>(context);
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        // floatingActionButton: FloatingActionButton(
        //   backgroundColor: AppColors.primaryColor,
        //   onPressed: () => _con.showLogOutDialog(context),
        //   child: Icon(
        //     Icons.logout,
        //   ),
        // ),
        backgroundColor: AppColors.scaffoldColor,
        body: Stack(
          children: [
            Container(
              height: _con.size.height,
              width: _con.size.width,
              alignment: Alignment.bottomLeft,
              child: Image(
                height: _con.size.height * 0.25,
                width: _con.size.height * 0.28,
                fit: BoxFit.fill,
                image: AssetImage("assets/images/web.png"),
              ),
            ),
            Positioned(
              left: _con.size.height * 0.06,
              bottom: _con.size.height * 0.13,
              child: GestureDetector(
                onTap: () => _launchURL(),
                child: Container(
                  height: _con.size.height * 0.06,
                  width: _con.size.height * 0.06,
                  color: Colors.transparent,
                ),
              ),
            ),
            Positioned(
              right: 15,
              bottom: _con.size.height * 0.12,
              child: FloatingActionButton(
                backgroundColor: AppColors.primaryColor,
                onPressed: () => _con.showLogOutDialog(context),
                child: Icon(
                  Icons.logout,
                ),
              ),
            ),
            SingleChildScrollView(
              physics: ClampingScrollPhysics(),
              child: Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        height: _con.size.height * 0.24,
                        child: Row(
                          children: [
                            Spacer(),
                            Image(
                              width: _con.size.height * 0.25,
                              fit: BoxFit.fill,
                              image: AssetImage(
                                  "assets/images/${data.appLocal.languageCode}.png"),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        right: _con.size.height * 0.05,
                        bottom: _con.size.height * 0.06,
                        child: GestureDetector(
                          onTap: () => showLangDialog(context, data),
                          child: Container(
                            height: _con.size.height * 0.05,
                            width: _con.size.height * 0.05,
                            color: Colors.transparent,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: _con.size.height * 0.065,
                        left: _con.size.width * 0.06,
                        child: Image(
                          height: _con.size.height * 0.06,
                          image: AssetImage("assets/images/logo.png"),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      DashboardButton(
                        image: "assets/images/dashboard.png",
                        ontap: () =>
                            Navigator.pushNamed(context, RouteKeys.DASHBOARD),
                        name: "${Translations.of(context).dashboard}",
                      ),
                      DashboardButton(
                        image: "assets/images/payment.png",
                        ontap: () => Navigator.pushNamed(
                            context, RouteKeys.MANAGE_PAYMENT_SCREEN),
                        name: "${Translations.of(context).invoices}",
                      ),
                      DashboardButton(
                        image: "assets/images/account.png",
                        ontap: () => Navigator.pushNamed(
                            context, RouteKeys.MANAGE_ACCOUNT_SCREEN),
                        name: "${Translations.of(context).account}",
                      ),
                      DashboardButton(
                        image: "assets/images/downloads.png",
                        ontap: () => Navigator.pushNamed(
                            context, RouteKeys.MY_DOCUMENT_SCREEN),
                        name: "${Translations.of(context).myDocument}",
                      ),
                      // DashboardButton(
                      //   image: "assets/images/resume.png",
                      //   ontap: () {},
                      //   name: "My Resume",
                      // ),
                      // DashboardButton(
                      //   image: "assets/images/pin.png",
                      //   ontap: () {},
                      //   name: "My Applications",
                      // ),
                      DashboardButton(
                        image: "assets/images/workedHours.png",
                        ontap: () => Navigator.pushNamed(
                            context, RouteKeys.WORKED_HOURS_SCREEN),
                        name: "${Translations.of(context).workbook}",
                      ),
                      // DashboardButton(
                      //   image: "assets/images/crossLine.png",
                      //   ontap: () {},
                      //   name: "Job Matching",
                      // ),
                      // DashboardButton(
                      //   image: "assets/images/bag.png",
                      //   ontap: () {},
                      //   name: "Manage Skills",
                      // ),
                      // DashboardButton(
                      //   image: "assets/images/lock.png",
                      //   ontap: () {},
                      //   name: "Change Password",
                      // ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _launchURL() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userId = prefs.getString(PrefsKey.USER_ID);
    String url = '${App.apiBaseUrl}web_login/$userId';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}

