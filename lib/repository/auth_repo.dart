import 'dart:convert';
import 'dart:io';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:device_info/device_info.dart';
import 'package:http/http.dart' as http;
import 'package:way_to_work/helpers/app_config.dart';

class AuthRepo {
  static Future<http.Response> loginUser(
      {String email, String password}) async {
    bool result = await DataConnectionChecker().hasConnection;
    if (result) {
      String deviceId;
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        deviceId = androidInfo.androidId;
      } else if (Platform.isIOS) {
        IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        deviceId = iosInfo.identifierForVendor;
      }
      return await http
          .post(
            '${App.apiBaseUrl}authentication/login',
            body: {
              'email': email,
              'password': password.toString(),
              'device_id': deviceId.toString(),
            },
          )
          .catchError((e) => null)
          .timeout(Duration(seconds: 8), onTimeout: () => null);
    } else {
      return http.Response(jsonEncode(App.noInternetJson), 503);
    }
  }

  static Future<http.Response> registerUser({
    String email,
    String password,
    String ssn,
    String taxNumber,
    String firstName,
    String lastName,
  }) async {
    bool result = await DataConnectionChecker().hasConnection;
    if (result) {
      String deviceId;
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        deviceId = androidInfo.androidId;
      } else if (Platform.isIOS) {
        IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        deviceId = iosInfo.identifierForVendor;
      }
      return await http
          .post(
            '${App.apiBaseUrl}authentication/register',
            body: {
              'email': email,
              'password': password,
              'device_id': deviceId.toString(),
              'ssn': ssn.toString(),
              'tax_number': taxNumber.toString(),
              'first_name': firstName,
              'last_name': lastName,
            },
          )
          .catchError((e) => null)
          .timeout(Duration(seconds: 8), onTimeout: () => null);
    } else {
      return http.Response(jsonEncode(App.noInternetJson), 503);
    }
  }

  static Future<http.Response> forgotPassword(
    String email,
  ) async {
    bool result = await DataConnectionChecker().hasConnection;
    if (result) {
      return await http
          .post(
            '${App.apiBaseUrl}authentication/forgot',
            body: {
              'email': email,
            },
          )
          .catchError((e) => null)
          .timeout(Duration(seconds: 8), onTimeout: () => null);
    } else {
      return http.Response(jsonEncode(App.noInternetJson), 503);
    }
  }
}
