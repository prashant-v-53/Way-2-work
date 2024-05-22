import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:way_to_work/controllers/base_controller.dart';
import 'package:way_to_work/elements/platform_alert_dialog.dart';
import 'package:way_to_work/helpers/variable_keys.dart';
import 'package:way_to_work/locale/translation_strings.dart';

class MyDashBoardController extends BaseController {
  Size size;
  
  void showLogOutDialog(BuildContext context) async {
    final didLogout = await PlatformAlertDialog(
      title: '${Translations.of(context).alert}',
      content: '${Translations.of(context).areYouSureWantToLogout}',
      confirmText: '${Translations.of(context).ok}',
      cancelText: '${Translations.of(context).no}',
    ).show(context, barrierDismissible: true);
    if (didLogout != null && didLogout) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.remove(PrefsKey.ACCESS_TOKEN);
      Navigator.pushNamedAndRemoveUntil(context, RouteKeys.LOGIN, (route) => false);
    }
  }
}
