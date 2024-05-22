import 'dart:convert';

import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:way_to_work/helpers/app_config.dart';
import 'package:way_to_work/helpers/variable_keys.dart';

Future<http.Response> getDashboardApi() async {
  bool result = await DataConnectionChecker().hasConnection;
  if (result) {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String sessionId = prefs.getString(PrefsKey.ACCESS_TOKEN);
    return await http
        .get(
          '${App.apiBaseUrl}dashboard',
          headers: {
            'session_id': sessionId,
          },
        )
        .catchError((e) => null)
        .timeout(Duration(seconds: 8), onTimeout: () => null);
  } else {
    return http.Response(jsonEncode(App.noInternetJson), 503);
  }
}

Future<http.Response> sendEmailApi(
  name,
  proffesional,
  dob,
  ssn,
  packageName,
  address,
  email,
  packageId,
  phone,
) async {
  bool result = await DataConnectionChecker().hasConnection;
  if (result) {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String sessionId = prefs.getString(PrefsKey.ACCESS_TOKEN);
    return await http
        .post('${App.apiBaseUrl}send_insurence_email', headers: {
          'session_id': sessionId,
        }, body: {
          "sending_email": email,
          "first_name": name,
          "last_name": "",
          "dob": dob,
          "package": packageName,
          "address": address,
          "email": email,
          "phone_number": phone,
          "ssn": ssn,
          "le_profession": proffesional == null ? "" : proffesional,
          "package_id": packageId,
        })
        .catchError((e) => null)
        .timeout(Duration(seconds: 8), onTimeout: () => null);
  } else {
    return http.Response(jsonEncode(App.noInternetJson), 503);
  }
}

Future<http.Response> sendInviteApi(
  String name,
  String email,
) async {
  bool result = await DataConnectionChecker().hasConnection;
  if (result) {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String sessionId = prefs.getString(PrefsKey.ACCESS_TOKEN);
    return await http
        .post('${App.apiBaseUrl}send_invite', headers: {
          'session_id': sessionId,
        }, body: {
          "name": name,
          "email": email,
        })
        .catchError((e) => null)
        .timeout(Duration(seconds: 8), onTimeout: () => null);
  } else {
    return http.Response(jsonEncode(App.noInternetJson), 503);
  }
}

Future<Response> uploadProfileImageApi(image) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String sessionId = prefs.getString(PrefsKey.ACCESS_TOKEN);
  var uri = Uri.parse('${App.apiBaseUrl}upload_photo');
  Response response = await Dio()
      .post('$uri',
          options: Options(headers: {'session_id': sessionId}),
          data: FormData.fromMap(
            {
              'upload_pic': image,
            },
          ))
      .catchError((e) {
    return null;
  });
  return response;
}

Future<http.Response> deleteProfileImageApi() async {
  bool result = await DataConnectionChecker().hasConnection;
  if (result) {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String sessionId = prefs.getString(PrefsKey.ACCESS_TOKEN);
    return await http
        .get('${App.apiBaseUrl}delete_photo', headers: {
          'session_id': sessionId,
        })
        .catchError((e) => null)
        .timeout(Duration(seconds: 8), onTimeout: () => null);
  } else {
    return http.Response(jsonEncode(App.noInternetJson), 503);
  }
}
