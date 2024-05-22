import 'dart:convert';

import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:way_to_work/helpers/app_config.dart';
import 'package:way_to_work/helpers/variable_keys.dart';

Future<http.Response> getMyDocListApi() async {
  bool result = await DataConnectionChecker().hasConnection;
  if (result) {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String sessionId = prefs.getString(PrefsKey.ACCESS_TOKEN);
    return await http
        .get('${App.apiBaseUrl}my_doument_list', headers: {
          'session_id': sessionId,
        })
        .catchError((e) => null)
        .timeout(Duration(seconds: 8), onTimeout: () => null);
  } else {
    return http.Response(jsonEncode(App.noInternetJson), 503);
  }
}

Future<http.Response> getContractListApi() async {
  bool result = await DataConnectionChecker().hasConnection;
  if (result) {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String sessionId = prefs.getString(PrefsKey.ACCESS_TOKEN);
    return await http
        .get('${App.apiBaseUrl}contract_list', headers: {
          'session_id': sessionId,
        })
        .catchError((e) => null)
        .timeout(Duration(seconds: 8), onTimeout: () => null);
  } else {
    return http.Response(jsonEncode(App.noInternetJson), 503);
  }
}

Future<http.Response> getContractEmployeeListApi() async {
  bool result = await DataConnectionChecker().hasConnection;
  if (result) {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String sessionId = prefs.getString(PrefsKey.ACCESS_TOKEN);
    return await http
        .get('${App.apiBaseUrl}doc_employer_list', headers: {
          'session_id': sessionId,
        })
        .catchError((e) => null)
        .timeout(Duration(seconds: 8), onTimeout: () => null);
  } else {
    return http.Response(jsonEncode(App.noInternetJson), 503);
  }
}

Future<http.Response> deleteMyDocApi(id, fileName) async {
  bool result = await DataConnectionChecker().hasConnection;
  if (result) {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String sessionId = prefs.getString(PrefsKey.ACCESS_TOKEN);
    return await http
        .post('${App.apiBaseUrl}my_doument_delete', headers: {
          'session_id': sessionId,
        }, body: {
          "id": id,
          "fl": fileName,
        })
        .catchError((e) => null)
        .timeout(Duration(seconds: 8), onTimeout: () => null);
  } else {
    return http.Response(jsonEncode(App.noInternetJson), 503);
  }
}

Future<http.Response> getEContractApi(id) async {
  bool result = await DataConnectionChecker().hasConnection;
  if (result) {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String sessionId = prefs.getString(PrefsKey.ACCESS_TOKEN);
    return await http
        .get('${App.apiBaseUrl}eContract_view/$id', headers: {
          'session_id': sessionId,
        })
        .catchError((e) => null)
        .timeout(Duration(seconds: 8), onTimeout: () => null);
  } else {
    return http.Response(jsonEncode(App.noInternetJson), 503);
  }
}

Future<http.Response> deleteContractApi(id, fileName) async {
  bool result = await DataConnectionChecker().hasConnection;
  if (result) {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String sessionId = prefs.getString(PrefsKey.ACCESS_TOKEN);
    return await http
        .post('${App.apiBaseUrl}contract_delete', headers: {
          'session_id': sessionId,
        }, body: {
          "id": id,
          "fl": fileName,
        })
        .catchError((e) => null)
        .timeout(Duration(seconds: 8), onTimeout: () => null);
  } else {
    return http.Response(jsonEncode(App.noInternetJson), 503);
  }
}

Future<Response> addMyDocApi(type, yearlyIncome, personalTax, maxTaxPercentage,
    startDate, documentName, expiryDate, file) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String sessionId = prefs.getString(PrefsKey.ACCESS_TOKEN);
  print(sessionId);
  var uri = Uri.parse('${App.apiBaseUrl}my_doument_create');
  print(
      "$type, $yearlyIncome, $personalTax, $maxTaxPercentage, $startDate, $documentName, $expiryDate, $file");
  Response response = await Dio()
      .post(
    '$uri',
    options: Options(headers: {'session_id': sessionId}),
    data: FormData.fromMap(
      {
        'document_type': type,
        'yearly_income': yearlyIncome,
        'personal_tax': personalTax,
        'max_tax_percentage': maxTaxPercentage,
        'beginig_of_tax_card': startDate,
        'dname': documentName,
        'edate': expiryDate,
        'upload_resume': file,
      },
    ),
  )
      .catchError((e) {
    print(e);
    return null;
  });
  return response;
}

Future<Response> addContractApi(id, contractName, expiryDate, file) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String sessionId = prefs.getString(PrefsKey.ACCESS_TOKEN);
  var uri = Uri.parse('${App.apiBaseUrl}contract_create');
  Response response = await Dio()
      .post(
    '$uri',
    options: Options(headers: {'session_id': sessionId}),
    data: FormData.fromMap(
      {
        'employer_id': id,
        'contract_name': contractName,
        'contract_edate': expiryDate,
        'contract_file': file,
      },
    ),
  )
      .catchError((e) {
    return null;
  });
  return response;
}
