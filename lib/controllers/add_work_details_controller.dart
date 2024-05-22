import 'dart:convert';
import 'package:http/http.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:way_to_work/helpers/global.dart';
import 'package:way_to_work/models/add_compensation_models.dart';
import 'package:way_to_work/models/worked_hour_model.dart';
import 'package:way_to_work/locale/translation_strings.dart';
import 'package:way_to_work/packages/internet_connection.dart';
import 'package:way_to_work/repository/worked_hours_repo.dart';

class AddWorkDetailsController extends ControllerMVC {
  bool isLoading = false;
  Size size;
  List<String> contractList = ["Hours", "Pieces"];
  List<FullHalfDayCompensation> fullHalfDayCompensationList = [];
  List<LunchCompensation> lunchCompensationList = [];
  DateTime currentDate = DateTime.now();
  String contactType = 'Hours';
  var tripTimeText = TextEditingController(text: "");
  String date = '';
  String id;
  String tripStart = '';
  String tripEnd = '';
  String tripAddresses = '';
  String km = '';
  String workedHours = '';
  String tripTime = '';
  RegExp regExp = RegExp(r'^(\d+)?([.-]?\d{0,9})?$');
  String otherCompensation = '';
  String workDescription = '';
  FullHalfDayCompensation fullHalfDayCompensation;
  LunchCompensation lunch;

  void setWorkDetails(data) {
    setState(() {
      isLoading = true;
      date = data.date;
      id = data.id;
      tripStart = data.tripStart;
      tripEnd = data.tripEnd;
      tripAddresses = data.tripAddress;
      km = data.km;
      workedHours = data.workingHours;
      tripTime = data.tripTime;
      tripTimeText.text = data.tripTime;
      otherCompensation = data.otherCompensation;
      workDescription = data.extraInformation;
    });
  }

  void getLunchCompensation(value, date, context) async {
    try {
      setState(() => isLoading = true);
      String year = date.toString() != "null"
          ? date?.substring(0, 4)
          : DateTime.now().year.toString();
      Response response = await getLunchCompensationList(year);
      if (response.statusCode == 200) {
        var res = json.decode(response.body);
        res.forEach((val) {
          LunchCompensation lunchC = LunchCompensation(
            id: val['id'].toString(),
            type: val['type'].toString(),
            value: val['value'].toString(),
          );
          setState(() => lunchCompensationList.add(lunchC));
          if (value == null) {
            setState(() => lunch = lunchCompensationList[0]);
          }
          if (value == val['value']) {
            setState(() => lunch = lunchC);
          }
        });
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
      setState(() => isLoading = true);
    }
  }

  onLunchDropChange(value) {
    setState(() => lunch = value);
  }

  onDayDropChange(value) {
    setState(() => fullHalfDayCompensation = value);
  }

  void getDayCompensation(value, date, context) async {
    try {
      setState(() => isLoading = true);
      String year = date.toString() != "null"
          ? date?.substring(0, 4)
          : DateTime.now().year.toString();
      Response response = await getDayCompensationList(year);
      if (response.statusCode == 200) {
        var res = json.decode(response.body);
        res.forEach((val) {
          FullHalfDayCompensation dayD = FullHalfDayCompensation(
            id: val['id'].toString(),
            type: val['type'].toString(),
            value: val['value'].toString(),
          );
          setState(() => fullHalfDayCompensationList.add(dayD));
          if (value == null) {
            setState(
                () => fullHalfDayCompensation = fullHalfDayCompensationList[0]);
          }
          if (value == val['value']) {
            setState(() => fullHalfDayCompensation = dayD);
          }
        });
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
      setState(() => isLoading = true);
    }
  }

  Future validateInput(context) async {
    if (workedHours.startsWith(".") || workedHours.startsWith("-")) {
      setState(() => workedHours = "0" + workedHours);
    }
    if (km.startsWith(".") || km.startsWith("-")) {
      setState(() => km = "0" + km);
    }
    if (km.isEmpty && workedHours.isEmpty) {
      return true;
    } else if (km.isEmpty && workedHours.isNotEmpty) {
      if (!regExp.hasMatch(workedHours)) {
        toast(contactType == 'Hours'
            ? "${Translations.of(context).entervalidHoursvalue}"
            : "${Translations.of(context).enterValidPiecesvalue}");
        return false;
      } else {
        return true;
      }
    } else if (km.isNotEmpty && workedHours.isEmpty) {
      if (!regExp.hasMatch(km)) {
        toast("${Translations.of(context).enterValidKm}");
        return false;
      } else {
        return true;
      }
    } else {
      if (!regExp.hasMatch(workedHours)) {
        toast(contactType == 'Hours'
            ? "${Translations.of(context).entervalidHoursvalue}"
            : "${Translations.of(context).enterValidPiecesvalue}");
        return false;
      } else if (!regExp.hasMatch(km)) {
        toast("${Translations.of(context).enterValidKm}");
        return false;
      } else {
        return true;
      }
    }
  }

  void addWorkDetailsFunction(context, fromManagePayment) async {
    if (date == '') {
      toast("${Translations.of(context).pleaseSelectDate}");
    } else {
      try {
        setState(() => isLoading = true);
        Response response = await addWorkedHoursApi(
            date,
            tripStart,
            tripEnd,
            tripAddresses,
            km.replaceAll("-", "."),
            workedHours.replaceAll("-", "."),
            tripTimeText.text,
            otherCompensation,
            workDescription,
            "${contactType[0].toUpperCase()}${contactType.substring(1)}",
            lunch.value,
            fullHalfDayCompensation.value);
        if (response.statusCode == 200) {
          var res = json.decode(response.body);
          WorkedHourModel hourModel = WorkedHourModel(
            id: res[0].toString(),
            date: date,
            tripStart: tripStart,
            tripEnd: tripEnd,
            tripAddress: tripAddresses,
            km: km.replaceAll("-", "."),
            workingHours: workedHours.replaceAll("-", "."),
            tripTime: tripTime,
            otherCompensation: otherCompensation,
            extraInformation: workDescription,
            type: "${contactType[0].toUpperCase()}${contactType.substring(1)}",
            dailyCompansations: lunch.value,
            dayCompansations: fullHalfDayCompensation.value,
          );
          Navigator.pop(context, fromManagePayment ? hourModel : true);
          toast('${Translations.of(context).addWorkSucessfully}');
          setState(() => isLoading = false);
        } else if (response.statusCode == 400) {
          toast("${Translations.of(context).pleaseSelectDate}");
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

  void editWorkDetailsFunction(context, fromManagePayment) async {
    if (date == '') {
      toast("${Translations.of(context).pleaseSelectDate}");
    } else {
      try {
        setState(() => isLoading = true);
        Response response = await editWorkedHoursApi(
          id,
          date,
          tripStart,
          tripEnd,
          tripAddresses,
          km.replaceAll("-", "."),
          workedHours.replaceAll("-", "."),
          tripTimeText.text,
          otherCompensation,
          workDescription,
          "${contactType[0].toUpperCase()}${contactType.substring(1)}",
          lunch.value,
          fullHalfDayCompensation.value,
        );
        if (response.statusCode == 200) {
          WorkedHourModel hourModel = WorkedHourModel(
            id: id,
            date: date,
            tripStart: tripStart,
            tripEnd: tripEnd,
            tripAddress: tripAddresses,
            km: km.replaceAll("-", "."),
            workingHours: workedHours.replaceAll("-", "."),
            tripTime: tripTime,
            otherCompensation: otherCompensation,
            extraInformation: workDescription,
            type: "${contactType[0].toUpperCase()}${contactType.substring(1)}",
            dailyCompansations: lunch.value,
            dayCompansations: fullHalfDayCompensation.value,
          );
          Navigator.pop(context, fromManagePayment ? hourModel : true);
          setState(() => isLoading = false);
        } else if (response.statusCode == 400) {
          toast("${Translations.of(context).pleaseSelectDate}");
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
}
