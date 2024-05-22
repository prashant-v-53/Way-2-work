// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:http/http.dart';
// import 'package:intl/intl.dart';
// import 'package:way_to_work/locale/translation_strings.dart';

// class NotificationsScheduler {
//   FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();

//   final Future<dynamic> Function(String) _onSelectNotification;

//   NotificationsScheduler(this._onSelectNotification);
//   final _androidChannelId = 'recoverMeId';
//   final _androidChannelName = 'RecoverMe';
//   final _androidChannelDescription = '';
//   final _androidDefaultIcon = 'app_icon';

//   Future<void> setupNotifications(BuildContext context) async {
//     requestPermissions();
//     await cancellAllNotifications();
//     await initialiseLocalNotifications();
//     await scheduleNotifications(context);
//     await scheduleDailyNotifications(context);
//   }
//   void requestPermissions() {
//       _flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation
//   <IOSFlutterLocalNotificationsPlugin>()?.requestPermissions(
//           alert: true,
//           badge: true,
//           sound: true,
//       );
//   }

//   Future<void> initialiseLocalNotifications() async {
//     var initializationSettingsAndroid =
//         AndroidInitializationSettings(_androidDefaultIcon);
//     var initializationSettingsIOS = IOSInitializationSettings();
//     var initializationSettings = InitializationSettings(
//         initializationSettingsAndroid, initializationSettingsIOS);
//     await _flutterLocalNotificationsPlugin.initialize(initializationSettings,
//         onSelectNotification: _onSelectNotification);
//   }

//   Future<void> cancellAllNotifications() async {
//     await _flutterLocalNotificationsPlugin.cancelAll();
//   }

//   Future<void> scheduleNotifications(BuildContext context) async {
//     var androidPlatformChannelSpecifics = AndroidNotificationDetails(
//       _androidChannelId,
//       _androidChannelName,
//       _androidChannelDescription,
//       importance: Importance.high,
//       priority: Priority.high,
//       styleInformation: BigTextStyleInformation(''),
//     );
//     var iOSPlatformChannelSpecifics = IOSNotificationDetails();
//     var platformChannelSpecifics = NotificationDetails(
//         androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);

//     final GetLastCBTSessionAccessedDateUseCase
//         getLastCBTSessionAccessedDateUseCase = sl();
//     var appInstallDate = sl<GetAppInstallDateUseCase>()();
//     if (appInstallDate == null) {
//       sl<SetAppInstallDateUseCase>()();
//       appInstallDate = DateTime.now();
//     }
//     final brain = LocalNotificationsBrain(
//       currentDate: DateTime.now(),
//       lastTimeAccessedCBT: getLastCBTSessionAccessedDateUseCase(),
//       appInstallDate: appInstallDate,
//     );
//     final notifications = brain.getNotificationsToSchedule();
//     final limiter = NotificationsLimiter(notifications);
//     final oneNotificationDailyMaxList =
//         limiter.limitedNotificationsForOneByDay();
//     for (var notification in cloudScheduleMessageModel) {
//       await _flutterLocalNotificationsPlugin.schedule(
//         notification.id,
//         notification.title,
//         notification.translateKey,
//         notification.scheduledDate,
//         // DateTime.now().add(Duration(seconds: 5)),
//         platformChannelSpecifics,
//         payload: notification.payload,
//         androidAllowWhileIdle: notification.androidAllowWhileIdle,
//       );
//     }
//     for (var notification in oneNotificationDailyMaxList) {
//       await _flutterLocalNotificationsPlugin.schedule(
//         notification.id,
//         notification.title,
//         AppLocalizations.of(context).translate(notification.translateKey),
//         notification.scheduledDate,
//         platformChannelSpecifics,
//         payload: notification.payload,
//         androidAllowWhileIdle: notification.androidAllowWhileIdle,
//       );
//     }
//   }

//   Future<void> scheduleDailyNotifications(BuildContext context) async {
//     final brain = LocalNotificationsBrain(
//       currentDate: DateTime.now(),
//     );
//     final dailyNotification = brain.getDailyNotification();
//     var androidPlatformChannelSpecifics = AndroidNotificationDetails(
//       _androidChannelId,
//       _androidChannelName,
//       _androidChannelDescription,
//       importance: Importance.High,
//       priority: Priority.High,
//       styleInformation: BigTextStyleInformation(''),
//     );
//     var iOSPlatformChannelSpecifics = IOSNotificationDetails();
//     var platformChannelSpecifics = NotificationDetails(
//         androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);

//     await _flutterLocalNotificationsPlugin.showDailyAtTime(
//       dailyNotification.id,
//       dailyNotification.title,
//       Translations.of(context).accept),
//       Time(dailyNotification.hour, dailyNotification.minute,
//           dailyNotification.second),
//       platformChannelSpecifics,
//       payload: dailyNotification.payload,
//     );
//   }
// }
