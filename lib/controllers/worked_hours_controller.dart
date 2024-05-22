import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:way_to_work/helpers/global.dart';
import 'package:way_to_work/locale/translation_strings.dart';
import 'package:way_to_work/models/worked_hour_model.dart';
import 'package:way_to_work/packages/internet_connection.dart';
import 'package:way_to_work/pages/dashboard/add_work_detail_screen.dart';
import 'package:way_to_work/pages/manage_payment/manage_payment_screen.dart';
import 'package:way_to_work/repository/worked_hours_repo.dart';

class WorkedHoursController extends ControllerMVC {
  Size size;
  bool isLoading = false;
  List hoursList = [];
  List piecesList = [];
  List invoiceIdsList = [];
  List<WorkedHourModel> workedHoursList = [];
  List<WorkedHourModel> useInInvoiceHoursList = [];
  WorkedHourModel workData;

  void addHours(context) async {
    var res = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AddWorkDetailScreen(
          data: null,
          fromManagePayment: false,
          firstTime: false,
          type: 'Hours',
        ),
      ),
    );
    if (res == true) {
      setState(() {
        workedHoursList = [];
        getWorkedHours(context);
      });
    }
  }

  void editHours(context, val) async {
    var res = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AddWorkDetailScreen(
          data: val,
          fromManagePayment: false,
          firstTime: false,
          type: val.type,
        ),
      ),
    );
    if (res == true) {
      setState(() {
        workedHoursList = [];
        getWorkedHours(context);
      });
    }
  }

  void selectItems(type, id, context) {
    if (type == 'Hours') {
      if (piecesList.isNotEmpty) {
        toast('${Translations.of(context).pleaseOnlySelectPieces}');
      } else {
        if (hoursList.contains(id)) {
          setState(() => hoursList.remove(id));
        } else {
          setState(() => hoursList.add(id));
        }
      }
    } else {
      if (hoursList.isNotEmpty) {
        toast('${Translations.of(context).pleaseOnlySelectHours}');
      } else {
        if (piecesList.contains(id)) {
          setState(() => piecesList.remove(id));
        } else {
          setState(() => piecesList.add(id));
        }
      }
    }
  }

  void getWorkedHours(context) async {
    try {
      setState(() => isLoading = true);
      Response response = await getWorkedHoursApi();
      if (response.statusCode == 200) {
        setState(() => isLoading = false);
        var decoded = jsonDecode(response.body);
        log(decoded.toString());
        if (decoded['work_details'] != []) {
          decoded['work_details'].forEach((val) {
            setState(() {
              workedHoursList.add(
                WorkedHourModel(
                  id: val['id'],
                  date: val['date'],
                  km: val['km'] == null ? '' : val['km'],
                  dailyCompansations:
                      val['daily_allow'] == null ? '' : val['daily_allow'],
                  dayCompansations: val['full_day_compensations'],
                  extraInformation: val['extra_information'] == null
                      ? ''
                      : val['extra_information'],
                  fullDate: val['created_at'] == null ? '' : val['created_at'],
                  isChecked: false,
                  otherCompensation:
                      val['other_comp'] == null ? '' : val['other_comp'],
                  tripAddress:
                      val['trip_address'] == null ? '' : val['trip_address'],
                  tripEnd: val['trip_end'] == null ? '' : val['trip_end'],
                  tripStart: val['trip_start'] == null ? '' : val['trip_start'],
                  workingHours:
                      val['total_hours'] == null ? '' : val['total_hours'],
                  tripTime: val['total_trip_time'] == null
                      ? ''
                      : val['total_trip_time'],
                  type: val['contract_type'] == null
                      ? ''
                      : "${val['contract_type'][0].toUpperCase()}${val['contract_type'].substring(1)}",
                  isExpanded: false,
                ),
              );
            });
          });
          if (workedHoursList.isNotEmpty) {
            setState(() => workData = workedHoursList[0]);
          }
        }
      } else if (response.statusCode == 400) {
        var decoded = jsonDecode(response.body);
        if (decoded is List) {
          toast(decoded.first);
        }
        setState(() => isLoading = false);
      } else if (response.statusCode == 401) {
        setState(() => isLoading = false);
        NetworkClass.unAuthenticatedUser(context, response);
      } else if (response.statusCode == 503) {
        setState(() => isLoading = false);
        NetworkClass.internetNotConnection(response);
      } else {
        setState(() => isLoading = false);
      }
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  void deleteWorkedHours(context) async {
    if (hoursList.length == 0 && piecesList.length == 0) {
      toast('${Translations.of(context).selectAtleastOneWorkedHour}');
    } else
      try {
        setState(() => isLoading = true);
        Response response = await deleteWorkedHoursApi(hoursList.length != 0
            ? hoursList.join(", ")
            : piecesList.join(", "));
        if (response.statusCode == 200) {
          setState(() => workedHoursList = []);
          getWorkedHours(context);
          toast('${Translations.of(context).deletedSuccessfully}');
        } else if (response.statusCode == 400) {
          var decoded = jsonDecode(response.body);
          if (decoded is List) {
            toast(decoded.first);
          }
          setState(() => isLoading = false);
        } else if (response.statusCode == 401) {
          setState(() => isLoading = false);
          NetworkClass.unAuthenticatedUser(context, response);
        } else if (response.statusCode == 503) {
          setState(() => isLoading = false);
          NetworkClass.internetNotConnection(response);
        } else {
          setState(() => isLoading = false);
        }
      } catch (e) {
        setState(() => isLoading = false);
      }
  }

  void useInInvoiveFun(context, fromManagePayment) async {
    if (hoursList.length == 0 && piecesList.length == 0) {
      toast("${Translations.of(context).selectAtleastOneWorkedHour}");
    } else {
      try {
        setState(() => isLoading = true);

        Response response = await useInInvoiceApi(hoursList.length != 0
            ? hoursList.join(", ")
            : piecesList.join(", "));
        var decoded = jsonDecode(response.body);
        print(decoded);
        if (response.statusCode == 200) {
          setState(() => isLoading = false);
          var decoded = jsonDecode(response.body);
          if (decoded != []) {
            setState(() => useInInvoiceHoursList = []);
            decoded.forEach((val) {
              setState(() {
                useInInvoiceHoursList.add(
                  WorkedHourModel(
                    id: val['id'],
                    date: val['date'],
                    km: val['km'] == null ? '' : val['km'],
                    dailyCompansations:
                        val['daily_allow'] == null ? '' : val['daily_allow'],
                    dayCompansations: val['full_day_compensations'] == null
                        ? ''
                        : val['full_day_compensations'],
                    extraInformation: val['extra_information'] == null
                        ? ''
                        : val['extra_information'],
                    fullDate:
                        val['created_at'] == null ? '' : val['created_at'],
                    otherCompensation:
                        val['other_comp'] == null ? '' : val['other_comp'],
                    tripAddress:
                        val['trip_address'] == null ? '' : val['trip_address'],
                    tripEnd: val['trip_end'] == null ? '' : val['trip_end'],
                    tripStart:
                        val['trip_start'] == null ? '' : val['trip_start'],
                    workingHours:
                        val['total_hours'] == null ? '' : val['total_hours'],
                    tripTime: val['total_trip_time'] == null
                        ? ''
                        : val['total_trip_time'],
                    type: val['contract_type'] == null
                        ? ''
                        : "${val['contract_type'][0].toUpperCase()}${val['contract_type'].substring(1)}",
                    isChecked: false,
                    isExpanded: false,
                  ),
                );
              });
            });
            if (useInInvoiceHoursList.isNotEmpty) {
              setState(() => workData = useInInvoiceHoursList[0]);
            }
          }
          if (fromManagePayment == false) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ManagePaymentScreen(
                  workedHoursList: useInInvoiceHoursList,
                ),
              ),
            );
          }
        } else if (response.statusCode == 400) {
          var decoded = jsonDecode(response.body);
          if (decoded is List) {
            toast(decoded.first);
          }
          setState(() => isLoading = false);
        } else if (response.statusCode == 401) {
          setState(() => isLoading = false);
          NetworkClass.unAuthenticatedUser(context, response);
        } else if (response.statusCode == 503) {
          setState(() => isLoading = false);
          NetworkClass.internetNotConnection(response);
        } else {
          setState(() => isLoading = false);
        }
      } catch (e) {
        setState(() => isLoading = false);
      }
    }
  }

  void onDuplicateFun(date, id, context) async {
    try {
      setState(() => isLoading = true);
      Response response = await onDuplicateAPI(date, id);
      if (response.statusCode == 200) {
        setState(() => workedHoursList = []);
        getWorkedHours(context);
      } else if (response.statusCode == 400) {
        var decoded = jsonDecode(response.body);
        if (decoded is List) {
          toast(decoded.first);
        }
        setState(() => isLoading = false);
      } else {
        setState(() => isLoading = false);
      }
    } catch (e) {
      setState(() => isLoading = false);
    }
  }
}
