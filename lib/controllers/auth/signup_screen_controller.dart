import 'dart:convert';
import 'package:http/http.dart';
import '../base_controller.dart';
import '../../helpers/global.dart';
import '../../helpers/helper.dart';
import 'package:flutter/material.dart';
import '../../repository/auth_repo.dart';
import '../../helpers/variable_keys.dart';
import 'package:way_to_work/elements/loading_overlay.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:way_to_work/locale/translation_strings.dart';
import 'package:way_to_work/packages/internet_connection.dart';
import 'package:way_to_work/pages/auth/terms_and_conditions_screen.dart';

class SignUpScreenController extends BaseController {
  GlobalKey<ScaffoldState> scaffoldKey;
  GlobalKey<FormState> formKey;
  Size size;
  String email = '';
  String emailError = '';
  String password = '';
  String passwordError = '';
  String confirmPassword = '';
  String confirmPasswordError = '';
  String taxNo = '';
  String taxNoError = "";
  String ssn = '';
  String ssnError = '';
  String firstName = '';
  String lastName = "";
  String firstNameError = '';
  String lastNameError = '';
  bool isLoading = false;

  SignUpScreenController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
    this.formKey = new GlobalKey<FormState>();
  }

  void invalidEmail(context) {
    setState(() => emailError = '${Translations.of(context).enterValidEmail}');
  }

  void validEmail() {
    setState(() => emailError = '');
  }

  void validPassword() {
    setState(() => passwordError = '');
  }

  void invalidPassword(context) {
    setState(
        () => passwordError = '${Translations.of(context).enterValidPassword}');
  }

  void invalidConfirmPassword(context) {
    setState(() => confirmPasswordError =
        '${Translations.of(context).enterValidConfirmPassword}');
  }

  void validConfirmPassword() {
    setState(() => confirmPasswordError = '');
  }

  void invalidSSN(context) {
    setState(() => ssnError = '${Translations.of(context).enterValidSsnNo}');
  }

  void validSSN() {
    setState(() => ssnError = '');
  }

  void invalidFullName(context) {
    setState(() =>
        firstNameError = '${Translations.of(context).enterValidFirstName}');
  }

  void validFullName() {
    setState(() => firstNameError = '');
  }

  void invalidLastName(context) {
    setState(
        () => lastNameError = '${Translations.of(context).enterValidLastName}');
  }

  void validLastName() {
    setState(() => lastNameError = '');
  }

  bool validateInput(context) {
    if (email.isNotEmpty &&
        Helper.isEmail(email.trim()) &&
        firstName.isNotEmpty &&
        lastName.isNotEmpty &&
        ssn.isNotEmpty &&
        password.isNotEmpty &&
        confirmPassword.isNotEmpty) {
      if (password == confirmPassword) {
        return true;
      } else {
        invalidConfirmPassword(context);
        return false;
      }
    } else {
      if (email.isEmpty || !Helper.isEmail(email.trim())) {
        invalidEmail(context);
      }
      if (password.isEmpty) {
        invalidPassword(context);
      }
      if (firstName.isEmpty) {
        invalidFullName(context);
      }
      if (lastName.isEmpty) {
        invalidLastName(context);
      }
      if (ssn.isEmpty) {
        invalidSSN(context);
      }
      if (confirmPassword.isEmpty) {
        invalidConfirmPassword(context);
      }
      return false;
    }
  }

  Future registerButtonPressed(context) async {
    var res = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TermsAndConditionScreen(),
      ),
    );
    if (res == true) {
      final overlay = LoadingOverlay.of(context);
      overlay.show();
      proceed(context).then((isSucceed) {
        overlay.hide();
        if (isSucceed ?? false) {
          Navigator.pushNamed(context, RouteKeys.MY_DASHBOARD);
        }
      });
    }
  }

  Future proceed(context) async {
    try {
      Response response = await AuthRepo.registerUser(
          email: email.trim(),
          password: password,
          ssn: ssn,
          taxNumber: taxNo,
          firstName: "${firstName[0].toUpperCase() + firstName.substring(1)}",
          lastName: "${lastName[0].toUpperCase() + lastName.substring(1)}");
      if (response.statusCode == 200) {
        var decoded = jsonDecode(response.body);
        if (decoded['data'].isEmpty) {
          toast("${Translations.of(context).registerSuccessfull}");
          Navigator.pop(context);
        } else {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString(
            PrefsKey.USER_ID,
            decoded['data']['auth_session']['user_id'].toString(),
          );
          prefs.setString(
            PrefsKey.ACCESS_TOKEN,
            decoded['data']['auth_session']['session'],
          );
          prefs.setString(
            PrefsKey.TAX_PERCENTAGE,
            decoded['data']['my_tax'],
          );
          toast(decoded['message']);
          return true;
        }
      } else if (response.statusCode == 400) {
        var decoded = jsonDecode(response.body);
        if (decoded is List) {
          toast(decoded.first);
        } else {
          print(decoded);
          if (decoded.containsKey('email')) {
            setState(() {
              emailError = decoded['email'];
            });
          }
          if (decoded.containsKey('password')) {
            setState(() {
              passwordError = decoded['password'];
            });
          }
          if (decoded.containsKey('ssn')) {
            setState(() {
              ssnError = decoded['ssn'];
            });
          }
          if (decoded.containsKey('tax_number')) {
            setState(() {
              taxNoError = decoded['tax_number'];
            });
          }
          if (decoded.containsKey('first_name')) {
            setState(() {
              firstNameError = decoded['first_name'];
            });
          }
          if (decoded.containsKey('last_name')) {
            setState(() {
              lastNameError = decoded['last_name'];
            });
          }
        }
      } else if (response.statusCode == 503) {
        NetworkClass.internetNotConnection(response);
      }
    } catch (e) {
      print(e);
    }
  }
}
