import 'dart:convert';
import 'package:http/http.dart';
import '../base_controller.dart';
import '../../helpers/global.dart';
import 'package:flutter/material.dart';
import '../../helpers/variable_keys.dart';
import 'package:way_to_work/helpers/global.dart';
import 'package:way_to_work/helpers/helper.dart';
import 'package:way_to_work/repository/auth_repo.dart';
import 'package:way_to_work/elements/loading_overlay.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:way_to_work/locale/translation_strings.dart';
import 'package:way_to_work/packages/internet_connection.dart';

class LoginScreenController extends BaseController {
  Size size;
  String email = '';
  String password = '';
  bool isLoading = false;
  String emailError = '';
  String passwordError = '';
  GlobalKey<FormState> formKey;
  GlobalKey<ScaffoldState> scaffoldKey;

  LoginScreenController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
    this.formKey = new GlobalKey<FormState>();
  }

  void invalidEmail(context) {
    setState(() => emailError = '${Translations.of(context).enterValidEmail}');
  }

  void validEmail() {
    setState(() => emailError = '');
  }

  void invalidPassword(context) {
    setState(
        () => passwordError = '${Translations.of(context).enterValidPassword}');
  }

  void validPassword() {
    setState(() => passwordError = '');
  }

  bool validateInput(context) {
    if (email.isNotEmpty &&
        Helper.isEmail(email.trim()) &&
        password.isNotEmpty) {
      return true;
    } else {
      if (email.isEmpty || !Helper.isEmail(email.trim())) {
        invalidEmail(context);
      }
      if (password.isEmpty) {
        invalidPassword(context);
      }
      return false;
    }
  }

  bool forgotPasswordValidate(context) {
    if (email.isNotEmpty && Helper.isEmail(email)) {
      return true;
    } else {
      if (email.isEmpty || !Helper.isEmail(email)) {
        toast('${Translations.of(context).enterValidEmail}');
      }
      return false;
    }
  }

  loginButtonPressed(context) {
    final overlay = LoadingOverlay.of(context);
    overlay.show();
    proceed(context).then((isSucceed) {
      overlay.hide();
      if (isSucceed ?? false) {
        Navigator.pushNamed(context, RouteKeys.MY_DASHBOARD);
      }
    });
  }

  Future proceed(context) async {
    try {
      Response response =
          await AuthRepo.loginUser(email: email.trim(), password: password);
      if (response.statusCode == 200) {
        var decoded = jsonDecode(response.body);
        if (decoded['data'].isEmpty) {
          toast(decoded['message']);
        }
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString(
          PrefsKey.USER_ID,
          decoded['data']['auth_session']['user_id'],
        );
        prefs.setString(
          PrefsKey.ACCESS_TOKEN,
          decoded['data']['auth_session']['session'],
        );
        prefs.setString(
          PrefsKey.TAX_PERCENTAGE,
          decoded['data']['personal_tax_number'],
        );
        return true;
      } else if (response.statusCode == 400) {
        var decoded = jsonDecode(response.body);
        if (decoded is List) {
          toast(decoded.first);
        } else {
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
        }
      } else if (response.statusCode == 503) {
        NetworkClass.internetNotConnection(response);
      }
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  forgotPasswordButtonPressed(context) {
    final overlay = LoadingOverlay.of(context);
    overlay.show();
    forgotPasswordProceed(context).then((isSucceed) {
      overlay.hide();
      if (isSucceed ?? false) {}
    });
  }

  Future forgotPasswordProceed(context) async {
    try {
      Response response = await AuthRepo.forgotPassword(email.trim());
      if (response.statusCode == 200) {
        var decoded = jsonDecode(response.body);
        if (decoded is List) {
          toast(
              "${decoded.first}\n${Translations.of(context).checkYourEmailNow}");
        }
      } else if (response.statusCode == 400) {
        var decoded = jsonDecode(response.body);
        if (decoded is List) {
          toast(decoded.first);
        } else {
          if (decoded.containsKey('email')) {
            setState(() {
              emailError = decoded['email'];
            });
          }
        }
      } else if (response.statusCode == 503) {
        NetworkClass.internetNotConnection(response);
      } else {
        var decoded = jsonDecode(response.body);
        toast("${decoded['error']}");
      }
    } catch (e) {
      print(e);
    }
  }
}
