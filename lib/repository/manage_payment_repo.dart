import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:way_to_work/helpers/app_config.dart';
import 'package:way_to_work/helpers/variable_keys.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:data_connection_checker/data_connection_checker.dart';

class ManagePaymentRepo {
  static Future<http.Response> getPaymentListApi() async {
    bool result = await DataConnectionChecker().hasConnection;
    if (result) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String sessionId = prefs.getString(PrefsKey.ACCESS_TOKEN);
      print(sessionId);
      return await http
          .get(
            '${App.apiBaseUrl}payment_list',
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

  static Future<http.Response> duplicatePaymentList(id) async {
    bool result = await DataConnectionChecker().hasConnection;
    if (result) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String sessionId = prefs.getString(PrefsKey.ACCESS_TOKEN);
      return await http
          .post('${App.apiBaseUrl}payment_duplicate', headers: {
            'session_id': sessionId,
          }, body: {
            "id": id.toString(),
          })
          .catchError((e) => null)
          .timeout(Duration(seconds: 8), onTimeout: () => null);
    } else {
      return http.Response(jsonEncode(App.noInternetJson), 503);
    }
  }

  static Future<http.Response> onDuplicateAPI(date, id) async {
    bool result = await DataConnectionChecker().hasConnection;
    if (result) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String sessionId = prefs.getString(PrefsKey.ACCESS_TOKEN);
      return await http
          .post('${App.apiBaseUrl}duplicate_worked_hours', headers: {
            'session_id': sessionId,
          }, body: {
            'date': date,
            'id': id.toString(),
          })
          .catchError((e) => null)
          .timeout(Duration(seconds: 8), onTimeout: () => null);
    } else {
      return http.Response(jsonEncode(App.noInternetJson), 503);
    }
  }

  static Future<Response> addNewPaymentApi(
      ids,
      employerId,
      type,
      value,
      taxPercentage,
      dueDate,
      vat,
      receiptFile,
      // otherExpensesFile,
      // otherFiles,
      multipleFiles,
      references,
      explanation) async {
    // print(value.runtimeType);
    print(
      "$ids,$employerId,$type,$value,$taxPercentage,$dueDate,$vat,$receiptFile,$multipleFiles,$references,$explanation,",
    );
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String sessionId = prefs.getString(PrefsKey.ACCESS_TOKEN);
    var uri = Uri.parse('${App.apiBaseUrl}payment_new');
    Response response = await Dio()
        .post('$uri',
            options: Options(headers: {'session_id': sessionId}),
            data: FormData.fromMap({
              'hours_ids': ids.toString(),
              'select_employer': employerId.toString(),
              'contract_type': type,
              'contract_value': value.toString(),
              'light_entreprenure_tax': taxPercentage.toString(),
              'due_date': dueDate.toString(),
              'vat': vat.toString(),
              'recipt_file': receiptFile,
              'other_expenses_file': null,
              'other_file': null,
              'multiple_file': multipleFiles,
              'invoice_referrance': references.toString(),
              'invoice_explanation': explanation.toString(),
            }))
        .catchError((e) {
      return null;
    });
    return response;
  }
}
