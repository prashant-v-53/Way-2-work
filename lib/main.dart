import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:way_to_work/helpers/app_colors.dart';
import 'package:way_to_work/helpers/global.dart';
import 'package:way_to_work/helpers/helper.dart';
import 'package:way_to_work/helpers/variable_keys.dart';
import 'package:way_to_work/locale/translation.dart';
import 'package:way_to_work/packages/internet_connection.dart';
import 'package:way_to_work/pages/my_dashboard_screen.dart';
import 'package:way_to_work/repository/account_repo.dart';

import 'helpers/app_config.dart';
import 'route_generator.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GlobalConfiguration().loadFromAsset("configurations");
  runApp(AppWrapper());
}

class AppWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AppModel(),
        ),
      ],
      child: MainApp(),
    );
  }
}

class AppModel extends ChangeNotifier {
  Locale _appLocale = Locale('en');
  Locale get appLocal => _appLocale ?? Locale('en');
  changeDirection(Locale local) async {
    changeLang = true;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('locale', local.toString());
    _appLocale = local;
    notifyListeners();
  }
}

class MainApp extends StatefulWidget {
  @override
  _MainAppState createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  @override
  void initState() {
    initializeLocalNotifications();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AppModel data = Provider.of<AppModel>(context);
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.light,
      ),
    );
    return MaterialApp(
      title: App.appName,
      initialRoute: RouteKeys.SPLASH,
      onGenerateRoute: RouteGenerator.generateRoute,
      localizationsDelegates: [
        const TranslationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        DefaultCupertinoLocalizations.delegate
      ],
      supportedLocales: [
        const Locale('et', 'ET'),
        const Locale('en', 'EN'),
        const Locale('fi', 'FI'),
        const Locale('ru', 'RU'),
      ],
      locale: data.appLocal,
      theme: ThemeData(
          primaryColor: Colors.white,
          floatingActionButtonTheme: FloatingActionButtonThemeData(
              elevation: 0, foregroundColor: Colors.white),
          brightness: Brightness.light,
          cursorColor: AppColors.appRedColor,
          colorScheme: ColorScheme.light(primary: AppColors.appRedColor)),
    );
  }

  void initializeLocalNotifications() async {
    var androidSettings = AndroidInitializationSettings('app_icon');
    var iOSSettings = IOSInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
    );
    var initSetttings =
        InitializationSettings(android: androidSettings, iOS: iOSSettings);
    _flutterLocalNotificationsPlugin.initialize(initSetttings,
        c);
    showScheduleNotification();
  }

  Future<void> showScheduleNotification() async {
    var response = await getNotificationDetails();
    if (response.statusCode == 200) {
      var decoded = json.decode(response.body);
      DateTime now = DateTime.now();
      var scheduledNotificationDateTime = DateTime(
        now.year,
        now.month,
        now.day,
        decoded['notification_settings']['hr'],
        decoded['notification_settings']['min'],
      );
      var androidDetails = AndroidNotificationDetails(
        '1',
        'showScheduleNotification',
        'Update time',
        icon: 'app_icon',
        largeIcon: DrawableResourceAndroidBitmap('app_icon'),
        importance: Importance.high,
        priority: Priority.high,
      );
      var iOSDetails =
          IOSNotificationDetails(presentSound: true, presentAlert: true);
      var platformDetails =
          NotificationDetails(android: androidDetails, iOS: iOSDetails);
      _flutterLocalNotificationsPlugin.cancelAll();
      if (decoded['notification_settings']['status'].toString() == "true") {
        await _flutterLocalNotificationsPlugin.schedule(
          1,
          'Way2Work',
          '${decoded['notification_settings']['msg']}',
          scheduledNotificationDateTime,
          platformDetails,
          payload: 'worked_hours_screen',
        );
      }
    } else if (response.statusCode == 400) {
      var decoded = jsonDecode(response.body);
      toast(decoded['error']);
    } else if (response.statusCode == 503) {
      NetworkClass.internetNotConnection(response);
    }
  }

  Future onClickNotification(String payload) {
    return Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) {
          return MyDashBoardScreen();
        },
      ),
    );
  }
}
