import 'dart:convert';

import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:way_to_work/helpers/app_config.dart';
import 'package:way_to_work/helpers/variable_keys.dart';

Future<http.Response> getEmployerListApi() async {
  bool result = await DataConnectionChecker().hasConnection;
  if (result) {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String sessionId = prefs.getString(PrefsKey.ACCESS_TOKEN);
    print(sessionId);
    return await http
        .get(
          '${App.apiBaseUrl}employer_list',
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

Future<http.Response> deleteEmployerApi(id) async {
  bool result = await DataConnectionChecker().hasConnection;
  if (result) {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String sessionId = prefs.getString(PrefsKey.ACCESS_TOKEN);
    return await http
        .delete(
          '${App.apiBaseUrl}employer_delete/$id',
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

Future<http.Response> getPaySlipSummeryApi() async {
  bool result = await DataConnectionChecker().hasConnection;
  if (result) {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String sessionId = prefs.getString(PrefsKey.ACCESS_TOKEN);
    return await http
        .get('${App.apiBaseUrl}payslip_details', headers: {
          'session_id': sessionId,
        })
        .catchError((e) => null)
        .timeout(Duration(seconds: 8), onTimeout: () => null);
  } else {
    return http.Response(jsonEncode(App.noInternetJson), 503);
  }
}

Future<http.Response> removeInvoice(id) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String sessionId = prefs.getString(PrefsKey.ACCESS_TOKEN);
  return await http
      .post('${App.apiBaseUrl}payment_delete', headers: {
        'session_id': sessionId,
      }, body: {
        "id": id.toString(),
      })
      .catchError((e) => null)
      .timeout(Duration(seconds: 8), onTimeout: () => null);
}

Future<http.Response> getEmployerDetailsApi(id) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String sessionId = prefs.getString(PrefsKey.ACCESS_TOKEN);
  return await http
      .get('${App.apiBaseUrl}employer_details/$id', headers: {
        'session_id': sessionId,
      })
      .catchError((e) => null)
      .timeout(Duration(seconds: 8), onTimeout: () => null);
}

Future<http.Response> addEmployerApi(
  name,
  telephone,
  yTunnus,
  ssn,
  tax,
  address,
  email,
  companyName,
) async {
  bool result = await DataConnectionChecker().hasConnection;
  if (result) {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String sessionId = prefs.getString(PrefsKey.ACCESS_TOKEN);
    return await http
        .post('${App.apiBaseUrl}employer_new', headers: {
          'session_id': sessionId,
        }, body: {
          "anonim_name": name,
          "anonim_telephone": telephone.toString(),
          "anonim_ytunnus": yTunnus.toString(),
          "anonim_ssn": ssn.toString(),
          "anonim_tax": tax.toString(),
          "anonim_address": address,
          "anonim_email": email,
          "company_name": companyName,
        })
        .catchError((e) => null)
        .timeout(Duration(seconds: 8), onTimeout: () => null);
  } else {
    return http.Response(jsonEncode(App.noInternetJson), 503);
  }
}

Future<http.Response> editEmployerApi(
  id,
  name,
  telephone,
  yTunnus,
  ssn,
  tax,
  address,
  email,
  companyName,
) async {
  bool result = await DataConnectionChecker().hasConnection;
  if (result) {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String sessionId = prefs.getString(PrefsKey.ACCESS_TOKEN);
    return await http
        .post('${App.apiBaseUrl}employer_modify/$id', headers: {
          'session_id': sessionId,
        }, body: {
          "anonim_name": name,
          "anonim_telephone": telephone.toString(),
          "anonim_ytunnus": yTunnus,
          "anonim_ssn": ssn.toString(),
          "anonim_tax": tax,
          "anonim_address": address,
          "anonim_email": email,
          "company_name": companyName,
        })
        .catchError((e) => null)
        .timeout(Duration(seconds: 8), onTimeout: () => null);
  } else {
    return http.Response(jsonEncode(App.noInternetJson), 503);
  }
}
