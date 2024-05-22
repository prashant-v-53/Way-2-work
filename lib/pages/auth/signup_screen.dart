import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:way_to_work/controllers/auth/signup_screen_controller.dart';
import 'package:way_to_work/helpers/app_colors.dart';
import 'package:way_to_work/locale/translation_strings.dart';

import '../../elements/commanbtn.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends StateMVC<SignUpScreen> {
  SignUpScreenController _con;

  _SignUpScreenState() : super(SignUpScreenController()) {
    _con = controller;
  }

  @override
  Widget build(BuildContext context) {
    _con.size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColors.appRedColor,
      body: SingleChildScrollView(
        physics: ClampingScrollPhysics(),
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  height: _con.size.height,
                  width: _con.size.width,
                  alignment: Alignment.topLeft,
                  child: Image(
                    image: AssetImage("assets/images/login.png"),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                    left: 25.0,
                    top: _con.size.height * 0.4,
                    right: 25.0,
                  ),
                  child: Form(
                    key: _con.formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          onChanged: (value) => _con.firstName = value,
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
                            labelText:
                                "${Translations.of(context).firstName} *",
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
                            '${_con.firstNameError}',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: _con.size.height * 0.015,
                            ),
                          ),
                        ),
                        SizedBox(height: _con.size.height * 0.01),
                        TextFormField(
                          onChanged: (value) => _con.lastName = value,
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
                            labelText: "${Translations.of(context).lastName} *",
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
                            '${_con.lastNameError}',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: _con.size.height * 0.015,
                            ),
                          ),
                        ),
                        SizedBox(height: _con.size.height * 0.01),
                        TextFormField(
                          onChanged: (value) => _con.ssn = value,
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
                            labelText: "${Translations.of(context).ssn} *",
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
                            '${_con.ssnError}',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: _con.size.height * 0.015,
                            ),
                          ),
                        ),
                        SizedBox(height: _con.size.height * 0.01),
                        // TextFormField(
                        //   onChanged: (value) => _con.taxNo = value,
                        //   cursorColor: Colors.white,
                        //   style: TextStyle(
                        //     color: Colors.white,
                        //     fontWeight: FontWeight.bold,
                        //     fontSize: _con.size.height * 0.02,
                        //   ),
                        //   decoration: InputDecoration(
                        //     errorStyle: TextStyle(color: Colors.white),
                        //     enabledBorder: UnderlineInputBorder(
                        //       borderSide: BorderSide(color: Colors.white24),
                        //     ),
                        //     errorBorder: UnderlineInputBorder(
                        //       borderSide: BorderSide(color: Colors.white24),
                        //     ),
                        //     focusedBorder: UnderlineInputBorder(
                        //       borderSide: BorderSide(color: Colors.white),
                        //     ),
                        //     focusedErrorBorder: UnderlineInputBorder(
                        //       borderSide: BorderSide(color: Colors.white),
                        //     ),
                        //     labelText: "${Translations.of(context).taxNumber}",
                        //     labelStyle: TextStyle(
                        //       color: Colors.white,
                        //       fontWeight: FontWeight.bold,
                        //       fontSize: _con.size.height * 0.02,
                        //     ),
                        //   ),
                        // ),
                        // Container(
                        //   alignment: Alignment.centerLeft,
                        //   margin: EdgeInsets.only(top: 5),
                        //   child: Text(
                        //     '${_con.taxNoError}',
                        //     style: TextStyle(
                        //       color: Colors.white,
                        //       fontWeight: FontWeight.bold,
                        //       fontSize: _con.size.height * 0.015,
                        //     ),
                        //   ),
                        // ),
                        SizedBox(height: _con.size.height * 0.01),
                        TextFormField(
                          onChanged: (value) => _con.email = value,
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
                        SizedBox(height: _con.size.height * 0.01),
                        TextFormField(
                          onChanged: (value) => _con.password = value,
                          obscureText: true,
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
                            labelText: "${Translations.of(context).password} *",
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
                            '${_con.passwordError}',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: _con.size.height * 0.015,
                            ),
                          ),
                        ),
                        SizedBox(height: _con.size.height * 0.01),
                        TextFormField(
                          onChanged: (value) => _con.confirmPassword = value,
                          obscureText: true,
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
                            labelText: "${Translations.of(context).confirmPassword} *",
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
                            '${_con.confirmPasswordError}',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: _con.size.height * 0.015,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: _con.size.height * 0.03,
                        ),
                        Commanbtn(
                          color: Colors.black,
                          name: "${Translations.of(context).next}",
                          ontap: _con.isLoading
                              ? null
                              : () {
                                  _con.emailError = '';
                                  _con.passwordError = '';
                                  _con.firstNameError = "";
                                  _con.lastNameError = "";
                                  _con.confirmPasswordError = "";
                                  _con.ssnError = "";
                                  if (_con.validateInput(context)) {
                                    _con.registerButtonPressed(context);
                                  }
                                },
                        ),
                        SizedBox(
                          height: _con.size.height * 0.03,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
