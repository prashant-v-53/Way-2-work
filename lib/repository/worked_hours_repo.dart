import 'dart:convert';

import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:way_to_work/helpers/app_config.dart';
import 'package:way_to_work/helpers/variable_keys.dart';

Future<http.Response> getWorkedHoursApi() async {
  bool result = await DataConnectionChecker().hasConnection;
  if (result) {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String sessionId = prefs.getString(PrefsKey.ACCESS_TOKEN);
    return await http
        .get(
          '${App.apiBaseUrl}worked_hours_list',
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

Future<http.Response> deleteWorkedHoursApi(ids) async {
  bool result = await DataConnectionChecker().hasConnection;
  if (result) {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String sessionId = prefs.getString(PrefsKey.ACCESS_TOKEN);
    return await http
        .post('${App.apiBaseUrl}worked_hours_delete', headers: {
          'session_id': sessionId,
        }, body: {
          'ids': ids,
        })
        .catchError((e) => null)
        .timeout(Duration(seconds: 8), onTimeout: () => null);
  } else {
    return http.Response(jsonEncode(App.noInternetJson), 503);
  }
}

Future<http.Response> useInInvoiceApi(ids) async {
  bool result = await DataConnectionChecker().hasConnection;
  if (result) {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String sessionId = prefs.getString(PrefsKey.ACCESS_TOKEN);
    return await http
        .post('${App.apiBaseUrl}worked_hours_transfer', headers: {
          'session_id': sessionId,
        }, body: {
          'ids': ids,
        })
        .catchError((e) => null)
        .timeout(Duration(seconds: 8), onTimeout: () => null);
  } else {
    return http.Response(jsonEncode(App.noInternetJson), 503);
  }
}

Future<http.Response> getDraftWorkedHours(ids) async {
  bool result = await DataConnectionChecker().hasConnection;
  if (result) {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String sessionId = prefs.getString(PrefsKey.ACCESS_TOKEN);
    return await http
        .post('${App.apiBaseUrl}draft_worked_hours_transfer', headers: {
          'session_id': sessionId,
        }, body: {
          'ids': ids,
        })
        .catchError((e) => null)
        .timeout(Duration(seconds: 8), onTimeout: () => null);
  } else {
    return http.Response(jsonEncode(App.noInternetJson), 503);
  }
}

Future<http.Response> onDuplicateAPI(date, id) async {
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

Future<http.Response> getLunchCompensationList(String year) async {
  bool result = await DataConnectionChecker().hasConnection;
  if (result) {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String sessionId = prefs.getString(PrefsKey.ACCESS_TOKEN);
    return await http
        .get('${App.apiBaseUrl}compensation/lunch_$year', headers: {
          'session_id': sessionId,
        })
        .catchError((e) => null)
        .timeout(Duration(seconds: 8), onTimeout: () => null);
  } else {
    return http.Response(jsonEncode(App.noInternetJson), 503);
  }
}

Future<http.Response> getDayCompensationList(String year) async {
  bool result = await DataConnectionChecker().hasConnection;
  if (result) {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String sessionId = prefs.getString(PrefsKey.ACCESS_TOKEN);
    return await http
        .get('${App.apiBaseUrl}compensation/day_$year', headers: {
          'session_id': sessionId,
        })
        .catchError((e) => null)
        .timeout(Duration(seconds: 8), onTimeout: () => null);
  } else {
    return http.Response(jsonEncode(App.noInternetJson), 503);
  }
}

Future<http.Response> addWorkedHoursApi(
  date,
  startTime,
  endTime,
  tripAddress,
  km,
  totalWorkedHours,
  tripTime,
  otherCompansation,
  extraInfo,
  contractType,
  dailyAllowance,
  fullHalfDayCompensation,
) async {
  bool result = await DataConnectionChecker().hasConnection;
  if (result) {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String sessionId = prefs.getString(PrefsKey.ACCESS_TOKEN);
    return await http
        .post('${App.apiBaseUrl}worked_hours_create', headers: {
          'session_id': sessionId,
        }, body: {
          "date": date,
          "start_time": startTime,
          "end_time": endTime,
          "trip_addresses": tripAddress,
          "km": km,
          "total_work_hours": totalWorkedHours,
          "daily_allawance": dailyAllowance,
          "trip_time": tripTime,
          "other_compensations": otherCompansation,
          "extra_info": extraInfo,
          "contract_type": contractType,
          "full_day_compensations": fullHalfDayCompensation,
        })
        .catchError((e) => null)
        .timeout(Duration(seconds: 8), onTimeout: () => null);
  } else {
    return http.Response(jsonEncode(App.noInternetJson), 503);
  }
}

Future<http.Response> editWorkedHoursApi(
  id,
  date,
  startTime,
  endTime,
  tripAddress,
  km,
  totalWorkedHours,
  tripTime,
  otherCompansation,
  extraInfo,
  contractType,
  dailyAllowance,
  fullHalfDayCompensation,
) async {
  bool result = await DataConnectionChecker().hasConnection;
  if (result) {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String sessionId = prefs.getString(PrefsKey.ACCESS_TOKEN);
    return await http
        .post('${App.apiBaseUrl}worked_hours_modify/$id', headers: {
          'session_id': sessionId,
        }, body: {
          "date": date,
          "start_time": startTime,
          "end_time": endTime,
          "trip_addresses": tripAddress.toString(),
          "km": km.toString(),
          "total_work_hours": totalWorkedHours.toString(),
          "daily_allawance": dailyAllowance.toString(),
          "trip_time": tripTime.toString(),
          "other_compensations": otherCompansation.toString(),
          "extra_info": extraInfo.toString(),
          "contract_type": contractType,
          "full_day_compensations": fullHalfDayCompensation,
        })
        .catchError((e) => null)
        .timeout(Duration(seconds: 8), onTimeout: () => null);
  } else {
    return http.Response(jsonEncode(App.noInternetJson), 503);
  }
}
