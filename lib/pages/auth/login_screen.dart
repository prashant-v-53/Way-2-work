import 'dart:io';
import 'package:way_to_work/main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:way_to_work/helpers/global.dart';
import 'package:way_to_work/helpers/app_colors.dart';
import 'package:way_to_work/helpers/variable_keys.dart';
import 'package:way_to_work/locale/translation_strings.dart';
import 'package:way_to_work/controllers/auth/login_screen_controller.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends StateMVC<LoginScreen> {
  AppModel data;
  LoginScreenController _con;
  DateTime currentBackPressTime;
  _LoginScreenState() : super(LoginScreenController()) {
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
    data = Provider.of<AppModel>(context);
    _con.size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        backgroundColor: AppColors.appRedColor,
        body: SingleChildScrollView(
          physics: ClampingScrollPhysics(),
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                    alignment: Alignment.topLeft,
                    height: _con.size.height,
                    width: _con.size.width,
                    child: Image(
                      image: AssetImage(
                        "assets/images/login.png",
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.bottomRight,
                    height: _con.size.height,
                    width: _con.size.width,
                    child: Image(
                      image: AssetImage("assets/images/login2.png"),
                      fit: BoxFit.cover,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                      left: 20.0,
                      top: _con.size.height * 0.45,
                      right: 20.0,
                    ),
                    child: Column(
                      children: [
                        TextFormField(
                          onChanged: (value) => _con.email = value.trim(),
                          cursorColor: Colors.white,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: _con.size.height * 0.02,
                          ),
                          decoration: InputDecoration(
                            errorStyle: TextStyle(color: Colors.white),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white24),
                            ),
                            errorBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white24),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            focusedErrorBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            labelText: "${Translations.of(context).email} *",
                            labelStyle: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: _con.size.height * 0.02,
                            ),
                          ),
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          margin: EdgeInsets.only(top: 5),
                          child: Text(
                            '${_con.emailError}',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: _con.size.height * 0.015,
                            ),
                          ),
                        ),
                        SizedBox(height: _con.size.height * 0.005),
                        TextFormField(
                          onChanged: (value) => _con.password = value,
                          cursorColor: Colors.white,
                          obscureText: true,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: _con.size.height * 0.02,
                            fontWeight: FontWeight.bold,
                          ),
                          decoration: InputDecoration(
                            errorStyle: TextStyle(color: Colors.white),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white24),
                            ),
                            errorBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white24),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            focusedErrorBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            labelText: "${Translations.of(context).password} *",
                            labelStyle: TextStyle(
                              color: Colors.white,
                              fontSize: _con.size.height * 0.02,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(height: _con.size.height * 0.005),
                        Container(
                          alignment: Alignment.centerLeft,
                          margin: EdgeInsets.only(top: 5),
                          child: Text(
                            '${_con.passwordError}',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: _con.size.height * 0.015,
                            ),
                          ),
                        ),
                        SizedBox(height: _con.size.width * 0.06),
                        GestureDetector(
                          onTap: _con.isLoading
                              ? null
                              : () {
                                  _con.emailError = '';
                                  _con.passwordError = '';
                                  if (_con.validateInput(context)) {
                                    _con.loginButtonPressed(context);
                                  }
                                },
                          child: Container(
                            margin: EdgeInsets.only(
                              left: _con.size.width * 0.58,
                            ),
                            height: _con.size.height * 0.15,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.transparent,
                              // color: Colors.blue.withOpacity(0.5),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: 20, vertical: _con.size.height * 0.07),
                    alignment: Alignment.bottomCenter,
                    height: _con.size.height,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () =>
                              Navigator.pushNamed(context, RouteKeys.SIGN_UP),
                          child: Text(
                            "${Translations.of(context).signup}",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: _con.isLoading
                              ? null
                              : () {
                                  _con.emailError = '';
                                  if (_con.forgotPasswordValidate(context)) {
                                    _con.forgotPasswordButtonPressed(context);
                                  }
                                },
                          child: Text(
                            "${Translations.of(context).forgotPassword} ?",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: _con.size.height * 0.17,
                    left: 10,
                    child: FloatingActionButton(
                      backgroundColor: Colors.white,
                      child: Center(
                        child: Text(
                          "${Translations.of(context).languageName.substring(0, 3).toUpperCase()}",
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ),
                      onPressed: () => showLangDialog(context, data),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
