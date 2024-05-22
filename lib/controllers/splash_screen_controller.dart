import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:way_to_work/helpers/variable_keys.dart';
import 'package:way_to_work/main.dart';

class SplashScreenController extends ControllerMVC {
  ValueNotifier<Map<String, double>> progress = new ValueNotifier(new Map());
  GlobalKey<ScaffoldState> scaffoldKey;
  AppModel data;
  String locale;

  SplashScreenController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
    progress.value = {"Setting": 0, "User": 0};
  }
  // @override
  // void initState() {
  //   super.initState();

  // firebaseMessaging.requestNotificationPermissions(const IosNotificationSettings(sound: true, badge: true, alert: true));
  // configureFirebase(firebaseMessaging);
  // settingRepo.setting.addListener(() {
  //   if (settingRepo.setting.value.appName != null && settingRepo.setting.value.appName != '' && settingRepo.setting.value.mainColor != null) {
  //     progress.value["Setting"] = 41;
  //     // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
  //     progress?.notifyListeners();
  //   }
  // });
  // userRepo.currentUser.addListener(() {
  //   if (userRepo.currentUser.value.auth != null) {
  //     progress.value["User"] = 59;
  //     progress?.notifyListeners();
  //   }
  // });
  // Timer(Duration(seconds: 20), () {
  //   scaffoldKey?.currentState?.showSnackBar(SnackBar(
  //     content: Text(S.of(context).verify_your_internet_connection),
  //   ));
  // });
  // }

  void getPreferences(context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    locale = prefs.getString('locale');
    setLang(locale);
    if (prefs.getString(PrefsKey.ACCESS_TOKEN) == null ||
        prefs.getString(PrefsKey.ACCESS_TOKEN) == '') {
      Future.delayed(Duration.zero, () {
        Navigator.of(context).pushReplacementNamed(RouteKeys.LOGIN);
      });
    } else {
      Future.delayed(Duration.zero, () {
        Navigator.of(context).pushReplacementNamed(RouteKeys.MY_DASHBOARD);
      });
    }
  }

  setLang(locale) {
    data.changeDirection(Locale('${locale == null ? 'fi' : locale}'));
  }
//
// void configureFirebase(FirebaseMessaging _firebaseMessaging) {
//   try {
//     _firebaseMessaging.configure(
//       onMessage: notificationOnMessage,
//       onLaunch: notificationOnLaunch,
//       onResume: notificationOnResume,
//     );
//   } catch (e) {
//     print(CustomTrace(StackTrace.current, message: e));
//     print(CustomTrace(StackTrace.current, message: 'Error Config Firebase'));
//   }
// }
//
// Future notificationOnResume(Map<String, dynamic> message) async {
//   try {
//     if (message['data']['id'] == "orders") {
//       settingRepo.navigatorKey.currentState.pushReplacementNamed('/Pages', arguments: 3);
//     }
//   } catch (e) {
//     print(CustomTrace(StackTrace.current, message: e));
//   }
// }
//
// Future notificationOnLaunch(Map<String, dynamic> message) async {
//   String messageId = await settingRepo.getMessageId();
//   try {
//     if (messageId != message['google.message_id']) {
//       if (message['data']['id'] == "orders") {
//         await settingRepo.saveMessageId(message['google.message_id']);
//         settingRepo.navigatorKey.currentState.pushReplacementNamed('/Pages', arguments: 3);
//       }
//     }
//   } catch (e) {
//     print(CustomTrace(StackTrace.current, message: e));
//   }
// }
//
// Future notificationOnMessage(Map<String, dynamic> message) async {
//   Fluttertoast.showToast(
//     msg: message['notification']['title'],
//     toastLength: Toast.LENGTH_LONG,
//     gravity: ToastGravity.TOP,
//     timeInSecForIosWeb: 5,
//   );
// }
}
