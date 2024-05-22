import 'dart:convert';

import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:way_to_work/helpers/app_config.dart';
import 'package:way_to_work/helpers/variable_keys.dart';

Future<http.Response> editProfileAccInfoApi(
  firstName,
  lastName,
  mobileNo,
  phoneNo,
  dobYear,
  dobMonth,
  dobDay,
  presentAddress,
  country,
  nationality,
  city,
  taxNo,
  taxPercentage,
  yearlyInvoice,
  bankName,
  accNo,
  bic,
  gender,
  earnedSoFar,
) async {
  bool result = await DataConnectionChecker().hasConnection;
  if (result) {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String sessionId = prefs.getString(PrefsKey.ACCESS_TOKEN);
    return await http
        .post('${App.apiBaseUrl}my_account_new', headers: {
          'session_id': sessionId
        }, body: {
          "first_name": firstName.toString(),
          "last_name": lastName.toString(),
          "mobile_number": mobileNo.toString(),
          "phone_number": phoneNo == null ? "" : phoneNo.toString(),
          "dob_year": dobYear.toString(),
          "dob_month": dobMonth.toString(),
          "dob_day": dobDay.toString(),
          "present_address": presentAddress.toString(),
          "country": country,
          "nationality": nationality == null ? "" : nationality,
          "city": city.toString(),
          "personal_tax_number": taxNo.toString(),
          "max_tax_percentage": taxPercentage.toString(),
          "total_yearly_income": yearlyInvoice.toString(),
          "bank_name": bankName == null ? "" : bankName.toString(),
          "account_no": accNo == null ? "" : accNo.toString(),
          "bic": bic == null ? "" : bic.toString(),
          "gender": gender.toString(),
          "earned_so_far": earnedSoFar == null ? "" : earnedSoFar.toString(),
        })
        .catchError((e) => null)
        .timeout(Duration(seconds: 8), onTimeout: () => null);
  } else {
    return http.Response(jsonEncode(App.noInternetJson), 503);
  }
}

Future<http.Response> getProfileAccApi() async {
  bool result = await DataConnectionChecker().hasConnection;
  if (result) {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String sessionId = prefs.getString(PrefsKey.ACCESS_TOKEN);
    return await http
        .get(
          '${App.apiBaseUrl}my_account_details',
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

Future<http.Response> getNotificationDetails() async {
  bool result = await DataConnectionChecker().hasConnection;
  if (result) {
    return await http
        .get(
          '${App.apiBaseUrl}notification_settings',
        )
        .catchError((e) => null)
        .timeout(Duration(seconds: 8), onTimeout: () => null);
  } else {
    return http.Response(jsonEncode(App.noInternetJson), 503);
  }
}
